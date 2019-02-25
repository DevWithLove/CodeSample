//
//  PreferenceManager.swift
//  inventoryapp
//

import Foundation

class PreferenceManager: NSObject {
    private static var fontSize:Int = 8
    private static var userDefaults:UserDefaultsProtocol = UserDefaults.standard
    private static var daysOlderThan = 30
    
    static func setStorage(storage:UserDefaultsProtocol){
        PreferenceManager.userDefaults = storage
    }
    
    static func setFontSize(fontSize:Int) {
        PreferenceManager.fontSize = fontSize
        PreferenceManager.userDefaults.setTheObject(fontSize, forKey: "fontSize")
    }
    
    static func getFontSize() -> Int {
        if let fontSize = PreferenceManager.userDefaults.theObject(forKey: "fontSize") {
            return fontSize as! Int
        }
        return PreferenceManager.fontSize
    }
    
    static func setDaysOlderThan(days:Int){
        PreferenceManager.daysOlderThan = days
        PreferenceManager.userDefaults.setTheObject(days, forKey: "daysOlderThan")
    }
    
    static func getDaysOlderThan() -> Int{
        if let daysOlder = PreferenceManager.userDefaults.theObject(forKey: "daysOlderThan") {
            return daysOlder as! Int
        }
        return PreferenceManager.daysOlderThan
    }
}

extension UserDefaults: UserDefaultsProtocol {
    func theObject(forKey key: String) -> Any? {
        return self.object(forKey: key)
    }
    
    func setTheObject(_ object: Any, forKey key: String) {
        self.set(object, forKey: key)
    }
    
    func removeTheObject(forKey key: String) {
      self.removeObject(forKey: key)
    }
    
    func synchronizeAll() {
      self.synchronize()
    }
}

protocol UserDefaultsProtocol {
    func theObject(forKey key:String) -> Any?
    func setTheObject(_ object:Any, forKey key:String)
    func removeTheObject(forKey key:String)
    func synchronizeAll()
}
