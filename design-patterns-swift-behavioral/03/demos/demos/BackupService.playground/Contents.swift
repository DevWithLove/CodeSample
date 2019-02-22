//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Chain of Responsibility
//: Organizes potential request processors in a sequence and decouples responders from callers.
//:
//: ##  BackupService
//: Fall back to other service if one fails
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)

import Foundation

public protocol WeatherService {
    var backupService: WeatherService? { get }
    init(backupService: WeatherService?)
    func fetchCurrentWeather(city: String, countryCode: String,
                             completionHandler: (WeatherData?, WeatherServiceError?) -> Void)
}

public struct WeatherData {
    public let city: String
    public let countryCode: String
    public let weather: String
    public let temp: Float
    public let unit: TempUnit
}

public enum TempUnit {
    case scientific
    case metric
    case imperial
}

extension TempUnit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .scientific:
            return "Kelvin"
        case .metric:
            return "Celsius"
        case .imperial:
            return "Fahrenheit"
        }
    }
}

extension WeatherService {
    public var backupService: WeatherService? {
        return nil
    }
}

public enum WeatherServiceError: Error {
    case serviceDown
    case noData
    case unknown
}

extension WeatherServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceDown:
            return "Service unavailable"
        case .noData:
            return "Could not retrieve weather data"
        case .unknown:
            return "Unknown error occured"
        }
    }
}

fileprivate struct OpenWeatherService: WeatherService, CustomStringConvertible {
    fileprivate var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countryCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        guard self.hasError() == nil else {
            if let backupService = self.backupService {
                let error = self.hasError() ?? .unknown
                print("\(self) could not fetch weather data. Reason: \(error.errorDescription ?? "unknown")")
                print("\t Falling back to \(backupService)")
                
                backupService.fetchCurrentWeather(city: city, countryCode: countryCode, completionHandler: completionHandler)
            } else {
                print("Backup service not set. Reached the end of the fallback chain\n")
                completionHandler(nil, self.hasError())
            }
            return
        }
        
        print("Weather data successfully fetched using \(self)")
        completionHandler(WeatherData(city: city, countryCode: countryCode, weather: "Clear", temp: 72, unit: .imperial), nil)
    }
    
    var description: String {
        return "OpenWeatherService"
    }
    
    fileprivate func hasError() -> WeatherServiceError? {
        return .serviceDown
    }
}

//: AccuWeather Service
fileprivate struct AccuWeatherService: WeatherService, CustomStringConvertible {
    fileprivate var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countryCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        guard self.hasError() == nil else {
            if let backupService = backupService {
                let error = self.hasError() ?? .unknown
                print("\(self) could not fetch weather data. Reason: \(error.errorDescription!)")
                print("\t Falling back to \(backupService)")
                backupService.fetchCurrentWeather(city: city, countryCode: countryCode, completionHandler: completionHandler)
            } else {
                print("Backup service not set. Reached the end of the fallback chain\n")
                completionHandler(nil, self.hasError())
            }
            return
        }
        
        print("Weather data successfully fetched using \(self)")
        completionHandler(WeatherData(city: city, countryCode: countryCode, weather: "Clear", temp: 72, unit: .imperial), nil)
    }
    
    var description: String {
        return "AccuWeatherService"
    }
    
    fileprivate func hasError() -> WeatherServiceError? {
        return nil//.noData
    }
}

//: DarkSky Service
fileprivate struct DarkSkyService: WeatherService, CustomStringConvertible {
    fileprivate var backupService: WeatherService?
    
    init(backupService: WeatherService? = nil) {
        self.backupService = backupService
    }
    
    func fetchCurrentWeather(city: String, countryCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        guard self.hasError() == nil else {
            if let backupService = backupService {
                let error = self.hasError() ?? .unknown
                print("\(self) could not fetch weather data. Reason: \(error.errorDescription!)")
                print("\t Falling back to \(backupService)")
                backupService.fetchCurrentWeather(city: city, countryCode: countryCode, completionHandler: completionHandler)
            } else {
                print("Backup service not set. Reached the end of the fallback chain\n")
                completionHandler(nil, self.hasError())
            }
            return
        }
        
        print("Weather data successfully fetched using \(self)")
        completionHandler(WeatherData(city: city, countryCode: countryCode, weather: "Clear", temp: 72, unit: .imperial), nil)
    }
    
    var description: String {
        return "DarkSky"
    }
    
    fileprivate func hasError() -> WeatherServiceError? {
        return nil
    }
}

public struct WeatherServiceWrapper: WeatherService {
    public init(backupService: WeatherService? = nil) {
        // nop
    }
    
    public func fetchCurrentWeather(city: String, countryCode: String, completionHandler: (WeatherData?, WeatherServiceError?) -> Void) {
        let darkSkyService = DarkSkyService()
        let accuWeatherService = AccuWeatherService(backupService: darkSkyService)
        let openWeatherService = OpenWeatherService(backupService: accuWeatherService)
        
        openWeatherService.fetchCurrentWeather(city: city, countryCode: countryCode) { (weatherData, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            completionHandler(weatherData, nil)
        }
    }
}

//: - Callout(Testing):
//: The client interacts with the WeatherServiceWrapper instance
let weatherService = WeatherServiceWrapper()
weatherService.fetchCurrentWeather(city: "San Francisco", countryCode: "US") { (weatherData, error) in
    guard error == nil else {
        print("Error while retrieving weather data: \(error?.errorDescription ?? "")")
        return
    }
    
    print(weatherData ?? "No weather data")
}
