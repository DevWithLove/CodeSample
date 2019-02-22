//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Mediator
//: Encapsulates how objects interact and promotes loose coupling by keeping objects from referring to each other explicitly.
//:
//: ##  SmartHome v1.0 - a brute-force approach
//: In this solution, the sensors and the appliances are tightly coupled.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation
//: - Callout(Sensors):
//: The sensors included in the SmartHome Kit
final class CODetector {
    private var alarm: Alarm
    
    init(alarm: Alarm) {
        self.alarm = alarm
    }
    
    func onCOHigh() {
        let alert = "CO level high!"
        print(alert)
        alarm.trigger(reason: alert)
    }
    
    func onCONormal() {
        if alarm.isOn {
            let msg = "CO level normal"
            print(msg)
            alarm.disable()
        }
    }
}

final class MotionSensor {
    private var alarm: Alarm
    private var lighting: Lighting
    private var thermostat: Thermostat?
    
    // we can also add a thermostat optionally to make our home even smarter
    init(alarm: Alarm, lighting: Lighting, thermostat: Thermostat? = nil) {
        self.alarm = alarm
        self.lighting = lighting
        self.thermostat = thermostat
    }
    
    func onMotionStateChanged(state: Bool) {
        // motion detected?
        let status = state ? "Movement detected" : "No movement"
        print(status)
        
        let alarmMode = alarm.armingMode
        
        if state == true {
            if alarmMode == .away {
                alarm.trigger(reason: "Motion detected!")
            } else if lighting.isOn == false {
                lighting.isOn = true
            }
        } else if lighting.isOn == true // no more motion and lights are on?
            && alarmMode == .away {   // don't turn down the lights when the alarm is on ;)
            lighting.isOn = false
        }
        
        // call thermostat
        if alarmMode == .stay {
            self.thermostat?.onMotionStateChanged(state: state)
        }
    }
}

final class Thermostat {
    private var airConditioner: AirConditioner
    private var heater: Heater
    
    var tempMin: Float // Fahrenheit
    var tempMax: Float
    
    init(ac: AirConditioner, heater: Heater, tempRange: (min: Float, max: Float) = (64, 77) ) {
        self.airConditioner = ac
        self.heater = heater
        self.tempMin = tempRange.min
        self.tempMax = tempRange.max
    }
    
    func onTempChanged(temp: Float) {
        print("Temperature changed to \(temp)")
        // temp in range [tempMin, tempMax] ?
        if tempMin ... tempMax ~= temp {
            print("Temperature within range [\(tempMin), \(tempMax)]")
            if self.heater.isOn {
                self.heater.isOn = false
            }
            if self.airConditioner.isOn {
                self.airConditioner.isOn = false
            }
        } else if temp < tempMin {
            print("\t\(temp) < min (\(tempMin))!")
            self.heater.isOn = true
        } else if temp > tempMax {
            print("\t\(temp) > max (\(tempMax))!")
            self.airConditioner.isOn = true
        }
    }
    
    func onMotionStateChanged(state: Bool) {
        // enable power saving mode if no motion detected
        self.isEnergySaving = !state //? false : true
    }
    
    private var isEnergySaving: Bool = true {
        willSet {
            self.heater.isEnergySavingMode = newValue
            self.airConditioner.isEnergySavingMode = newValue
        }
    }
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
//: Testing
let alarm = Alarm()
let lighting = Lighting()
let heater = Heater()
let ac = AirConditioner()

let coDetector = CODetector(alarm: alarm)
let thermostat = Thermostat(ac: ac, heater: heater)

let motionSensor = MotionSensor(alarm: alarm, lighting: lighting, thermostat: thermostat)

motionSensor.onMotionStateChanged(state: true)

thermostat.onTempChanged(temp: 63)
thermostat.onTempChanged(temp: 64)

motionSensor.onMotionStateChanged(state: false)

coDetector.onCOHigh()
coDetector.onCONormal()

alarm.armingMode = .away
motionSensor.onMotionStateChanged(state: true)
