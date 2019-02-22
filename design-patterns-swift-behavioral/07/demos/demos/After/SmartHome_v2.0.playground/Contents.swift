//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Mediator
//: Encapsulates how objects interact and promotes loose coupling by keeping objects from referring to each other explicitly.
//:
//: ##  SmartHome v2.0 - Introducing the Mediator
//: We'll refactor the project using the Mediator design pattern
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

protocol Appliance {
    func receive(event: Event)
}

protocol Event {
    var message: String { get set }
    var state: Bool { get set }
}

protocol Mediator {
    func notify(sender: Sensor, event: Event)
    func register(receiver: Appliance)
}

protocol Sensor {
    var mediator: Mediator { get }
    init(mediator: Mediator)
}
//: - Callout(Sensors):
//: The sensors included in the SmartHome Kit
final class CODetector: Sensor {
    var mediator: Mediator
    
    init(mediator: Mediator) {
        self.mediator = mediator
    }
    
    func onCOHigh() {
        let alert = "CO level high!"
        print(alert)
        mediator.notify(sender: self, event: SensorEvent(message: alert, state: true))
    }
    
    func onCONormal() {
        if alarm.isOn {
            let msg = "CO level normal"
            print(msg)
            mediator.notify(sender: self, event: SensorEvent(message: msg, state: false))
        }
    }
}

struct SensorEvent: Event {
    var message: String
    var state: Bool
}





final class MotionSensor: Sensor {
    var mediator: Mediator
    
    init(mediator: Mediator) {
        self.mediator = mediator
    }
    
    func onMotionStateChanged(state: Bool) {
        // motion detected?
        let status = state ? "Movement detected" : "No movement"
        print(status)
        mediator.notify(sender: self, event: SensorEvent(message: status, state: state))
    }
}

final class Thermostat: Sensor {
    var mediator: Mediator
    
    init(mediator: Mediator) {
        self.mediator = mediator
    }
        
    var tempMin: Float = 64// Fahrenheit
    var tempMax: Float = 77
    
    init(mediator: Mediator, tempRange: (min: Float, max: Float) = (64, 77) ) {
        self.mediator = mediator
        self.tempMin = tempRange.min
        self.tempMax = tempRange.max
    }
    
    func onTempChanged(temp: Float) {
        print("Temperature changed to \(temp)")
        var tempState = TempState.normal
        
        // temp in range [tempMin, tempMax] ?
        if tempMin ... tempMax ~= temp {
            print("Temperature within range [\(tempMin), \(tempMax)]")
            tempState = .normal
        } else if temp < tempMin {
            print("\t\(temp) < min (\(tempMin))!")
            tempState = .low
        } else if temp > tempMax {
            print("\t\(temp) > max (\(tempMax))!")
            tempState = .high
        }
        mediator.notify(sender: self, event: TemperatureChangedEvent(message: "Temperature changed", state: true, temperature: tempState))
    }
    
    private var isEnergySaving: Bool = true {
        willSet {
            mediator.notify(sender: self, event: EnergySavingEvent(message: "Energy saving mode changed", state: newValue))
        }
    }
}

extension Thermostat: Appliance {
    func receive(event: Event) {
        self.isEnergySaving = !event.state
    }
    
    
}

struct TemperatureChangedEvent: Event {
    var message: String
    var state: Bool
    var temperature: TempState
}

struct EnergySavingEvent: Event {
    var message: String
    var state: Bool
}

enum TempState {
    case high
    case low
    case normal
}
//: - Callout(Appliances):
//: Home appliances
enum ArmingModes {
    case stay
    case away
}
//: Home appliances
final class Alarm {
    var isOn: Bool = false
    var armingMode: ArmingModes = .stay
    
    func trigger(reason: String) {
        if self.isOn == false {
            self.isOn = true
            print("\t🚨 Alarm activated! \(reason) 🚨")
        }
    }
    
    func disable() {
        if self.isOn == true {
            self.isOn = false
            print("\tAlarm stopped")
        }
    }
}

extension Alarm: Appliance {
    func receive(event: Event) {
        if event.state == true {
            self.trigger(reason: event.message)
        } else {
            self.disable()
        }
    }
}


final class Lighting {
    private var lightOn: Bool = false
    var isOn: Bool {
        set {
            self.lightOn = newValue
            let state = lightOn ? "ON" : "OFF"
            print("Light is \(state)")
        }
        get {
            return lightOn
        }
    }
}

extension Lighting: Appliance {
    func receive(event: Event) {
        self.isOn = event.state
    }
}

final class Heater {
    private var isHeating: Bool = false
    private var isEnergySaving: Bool = true
    
    var isOn: Bool {
        set {
            self.isHeating = newValue
            let state = isHeating ? "ON" : "OFF"
            print("\tHeater: \(state)")
        }
        get {
            return isHeating
        }
    }
    
    var isEnergySavingMode: Bool {
        set {
            self.isEnergySaving = newValue
            let state = isEnergySaving ? "ON" : "OFF"
            print("\tHeater energy saving mode \(state)")
        }
        get {
            return isEnergySaving
        }
    }
}

extension Heater: Appliance {
    func receive(event: Event) {
        if let tempEvent = event as? TemperatureChangedEvent {
            switch tempEvent.temperature {
            case .normal:
                if self.isOn {
                    self.isOn = false
                }
            case .low:
                if self.isOn == false {
                    self.isOn = true
                }
            default:
                print("Invalid temperature state received")
            }
        } else if let energySavingEvent = event as? EnergySavingEvent {
            if self.isEnergySavingMode != energySavingEvent.state {
                self.isEnergySavingMode = energySavingEvent.state
            }
        }
    }
    
    
}

final class AirConditioner {
    private var isCooling: Bool = false
    private var isEnergySaving: Bool = false
    
    var isOn: Bool {
        set {
            self.isCooling = newValue
            let state = isCooling ? "ON" : "OFF"
            print("Air Conditioner is \(state)")
        }
        get {
            return isCooling
        }
    }
    
    var isEnergySavingMode: Bool {
        set {
            self.isEnergySaving = newValue
            let state = isEnergySaving ? "ON" : "OFF"
            print("\tAir Conditioner energy saving mode \(state)")
        }
        get {
            return isEnergySaving
        }
    }
}

extension AirConditioner: Appliance {
    func receive(event: Event) {
        if let tempEvent = event as? TemperatureChangedEvent {
            switch tempEvent.temperature {
            case .normal:
                if self.isOn {
                    self.isOn = false
                }
            case .high:
                if self.isOn == false {
                    self.isOn = true
                }
            default:
                print("Invalid temperature state received")
            }
        } else if let energySavingEvent = event as? EnergySavingEvent {
            if self.isEnergySavingMode != energySavingEvent.state {
                self.isEnergySavingMode = energySavingEvent.state
            }
        }
    }
    
    
}

// Concrete Mediator
class SmartHomeHub: Mediator {
    private var appliances = [Appliance]()
    
    func register(receiver: Appliance) {
        appliances.append(receiver)
    }
    
    func notify(sender: Sensor, event: Event) {
        switch sender {
        case is CODetector:
            appliances.forEach({ appliance in
                if let alarm = appliance as? Alarm {
                    alarm.receive(event: event)
                }
            })
        case is MotionSensor:
            appliances.forEach({ appliance in
                if let alarm = appliance as? Alarm {
                    if alarm.armingMode == .away && event.state == true {
                        alarm.receive(event: event)
                    }
                } else if let lighting = appliance as? Lighting {
                    lighting.receive(event: event)
                } else if let thermostat = appliance as? Thermostat {
                    thermostat.receive(event: event)
                }
            })
        case is Thermostat:
            appliances.forEach({ appliance in
                var thermostatEvent: Event? = nil
                switch event {
                case is TemperatureChangedEvent:
                    thermostatEvent = event
                case is EnergySavingEvent:
                    thermostatEvent = event
                default:
                    break
                }
                
                if let event = thermostatEvent {
                    if appliance is Heater || appliance is AirConditioner {
                        appliance.receive(event: event)
                    }
                }
            })
        default:
            print("Unknown sensor")
        }
    }
}

//: Testing
let alarm = Alarm()
let lighting = Lighting()
let heater = Heater()
let ac = AirConditioner()

var mediator = SmartHomeHub()

mediator.register(receiver: alarm)
mediator.register(receiver: lighting)
mediator.register(receiver: heater)
mediator.register(receiver: ac)

var coDetector = CODetector(mediator: mediator)
var thermostat = Thermostat(mediator: mediator)
var motionSensor = MotionSensor(mediator: mediator)

mediator.register(receiver: thermostat)

motionSensor.onMotionStateChanged(state: true)

thermostat.onTempChanged(temp: 63)
thermostat.onTempChanged(temp: 64)

motionSensor.onMotionStateChanged(state: false)

coDetector.onCOHigh()
coDetector.onCONormal()

alarm.armingMode = .away
motionSensor.onMotionStateChanged(state: true)
