//
//  InventoryItem.swift
//  inventoryapp


import UIKit
import CoreData

@objc(InventoryItem)
public class InventoryItem: NSManagedObject {
    @NSManaged var name:String?
    @NSManaged var units:Int32
    @NSManaged var manufacturerName:String?
    @NSManaged var logoUrl:String?
    @NSManaged private var dateAdded:Date?
    @NSManaged private var timeOut:Double
    
    //for fetches
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(name:String, units:Int32, manufacturerName:String){
        let appDelegate:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        let entityDescription = NSEntityDescription.entity(forEntityName: InventoryManager.entityName, in: appDelegate.persistentContainer.viewContext)
        super.init(entity: entityDescription!, insertInto: appDelegate.persistentContainer.viewContext)
        
        self.name = name
        self.units = units
        self.manufacturerName = manufacturerName
        //self.logoUrl = URL(string: "http://www.carlogos.org/logo/Toyota-logo-1989-2560x1440.png")!
        //self.logoUrl = "http://www.carlogos.org/logo/Toyota-logo-1989-2560x1440.png"
        self.dateAdded = Date()
        self.setTimeOut(timeOut: TimeInterval(20))
    }
    
    convenience init(name:String, units:Int32, manufacturerName:String, date:Date){
        self.init(name: name, units: units, manufacturerName: manufacturerName)
        self.dateAdded = date
        self.setTimeOut(timeOut: TimeInterval(20))
    }
    
    func setDate(dateAdded:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        self.dateAdded = dateFormatter.date(from: dateAdded)!
        
    }
    
    //used when dateadded went private
    func getDateAdded() -> Date{
        return self.dateAdded!
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void){
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = self.timeOut // timeout, in seconds
        //https://commons.wikimedia.org/wiki/File:%27Calypso%27_Panorama_of_Spirit%27s_View_from_%27Troy%27_(Stereo).jpg
        //let url = URL(string: "https://www.nasa.gov/sites/default/files/thumbnails/image/hs-2015-02-a-hires_jpg.jpg")!
        //87MB
        //let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/72/%27Calypso%27_Panorama_of_Spirit%27s_View_from_%27Troy%27_%28Stereo%29.jpg")!

        DetermineImageURL().setImageURL(item: self)
        
        let url = URL(string: self.logoUrl!)!
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }
            var mydata = data
            if(data == nil){
                mydata = UIImagePNGRepresentation(#imageLiteral(resourceName: "noimage"))
            }
            completion(UIImage(data: mydata!)!)
        }.resume()
    }
    
    func setTimeOut(timeOut:TimeInterval){
        self.timeOut = timeOut
    }
    
    func getTimeOut() -> TimeInterval {
        return self.timeOut
    }
}
