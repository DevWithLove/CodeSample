//
//  InventoryManager.swift
//  inventoryapp
//
//  Created by Brett Romero on 12/27/16.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit
import CoreData

class InventoryManager: NSObject {

    static let entityName = "InventoryItem"
    //static var shared:InventoryManager = InventoryManager()
    static var shared:DataStoreProtocol!
    static let days = [25,30,35,40]
    
    static func setContext(dataStore: DataStoreProtocol){
        InventoryManager.shared = dataStore
    }
    
    static func add(item: InventoryItem) {
        InventoryManager.shared.add(item: item)
    }
    
    static func delete(index: Int) {
        InventoryManager.shared.delete(index: index)
    }
    
    static func getCount() -> Int {
        return InventoryManager.shared.getCount()
    }
    
    static func getItem(index: Int) -> InventoryItem {
        return InventoryManager.shared.getItem(index:index)
    }
    
    static func olderThanDays() -> [InventoryItem]{
        return InventoryManager.shared.olderThanDays()
    }
}

protocol DataStoreProtocol {
    func add(item:InventoryItem)
    func delete(index:Int)
    func getCount() -> Int
    func getItem(index:Int) -> InventoryItem
    func olderThanDays() -> [InventoryItem]
}

class ArrayDataStore:NSObject, DataStoreProtocol{
    var items:[InventoryItem] = []
    let days = [25,30,35,40]
    
    @discardableResult
    override init(){
        items.append(InventoryItem(name: "Highlander", units: 50, manufacturerName: "Toyota"))
        items.append(InventoryItem(name: "Altima", units: 40, manufacturerName: "Nissan"))
        items.append(InventoryItem(name: "Focus", units: 70, manufacturerName: "Ford"))
        items.append(InventoryItem(name: "Impreza", units: 10, manufacturerName: "Subaru"))
    }
    
    func add(item: InventoryItem) {
        items.append(item)
    }
    
    func delete(index: Int) {
        items.remove(at: index)
    }
    
    func getCount() -> Int {
        return items.count
    }
    
    func getItem(index: Int) -> InventoryItem {
        return items[index]
    }
    
    func olderThanDays() -> [InventoryItem] {
        let thirtyDaysAgo = NSCalendar.current.date(byAdding: Calendar.Component.day, //Here you can add year, month, hour, etc.
            value: -PreferenceManager.getDaysOlderThan(),  //Here you can add number of units
            to: Date())
        //return collection of items older than 30 days.
        return items.filter({  $0.getDateAdded().compare(thirtyDaysAgo!) == .orderedAscending })
    }
}

class CoreDataStore: DataStoreProtocol{
    var appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var managedObjectContext:NSManagedObjectContext
    var items:[InventoryItem]
    
    init(){
        managedObjectContext = appDelegate.persistentContainer.viewContext
        let itemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: InventoryManager.entityName)
        itemsFetch.sortDescriptors = [
            NSSortDescriptor(key: "manufacturerName", ascending: true)
        ]
        do {
            items = try managedObjectContext.fetch(itemsFetch) as! [InventoryItem]
        }
        catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func add(item: InventoryItem) {
        do {
            items.append(item)
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Failed to save an item", error)
        }
    }
    
    func delete(index: Int) {
        items.remove(at: index)
        do{
            try managedObjectContext.save()
        } catch {
            fatalError("delete(): Error deleting item \(index)")
        }
    }
    
    func getCount() -> Int {
        return items.count
    }
    
    func getItem(index: Int) -> InventoryItem {
        return items[index]
    }
    
    func olderThanDays() -> [InventoryItem] {
        let thirtyDaysAgo = NSCalendar.current.date(byAdding: Calendar.Component.day,
            value: -PreferenceManager.getDaysOlderThan(),
            to: Date())
        return items.filter({  $0.getDateAdded().compare(thirtyDaysAgo!) == .orderedAscending })
    }
    
    func clear(){
        items = []
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("clear(): Error removing all items")
        }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventoryItem> {
        return NSFetchRequest<InventoryItem>(entityName:InventoryManager.entityName)
    }
    
}

class DetermineImageURL {
    func setImageURL(item: InventoryItem) {
        switch item.manufacturerName {
        case "Ford"?:
            item.logoUrl = "http://www.bitesizebschool.com/pluralsight_mocksstubs/fordlogo.png"
        case "Chevy"?:
            item.logoUrl = "http://www.bitesizebschool.com/pluralsight_mocksstubs/chevylogo.png"
        case "Toyota"?:
            item.logoUrl = "http://www.bitesizebschool.com/pluralsight_mocksstubs/toyotalogo.png"
        case "Nissan"?:
            item.logoUrl = "http://www.bitesizebschool.com/pluralsight_mocksstubs/nissanlogo.png"
        default:
            item.logoUrl = ""
        }
    }
}
