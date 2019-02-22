//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Template Method
//: Allows specific steps in an algorithm to be replaced by clients without modifying the structure of the algorithm.
//:
//: ##  Pretty-Print Demo
//: Encode and display objects as JSON or XML. Template Method implemented the Protocol-Oriented way.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

struct Contacts: Encodable {
    var contacts: [Contact]
}

struct Contact: Encodable {
    var firstName: String
    var lastName: String
    var phone: String
}

protocol PrettyPrintable {
    func display<Value: Encodable>(context: Value) -> String?
    func encodeHook<Value: Encodable>(context: Value) -> Data?
    func formattedString(data: Data) -> String?
    func displayHook(text: String)
}

extension PrettyPrintable {
    func display<Value: Encodable>(context: Value) -> String? {
        guard let encodedData = encodeHook(context: context),
            let formattedString = formattedString(data: encodedData) else {
                return nil
        }
        displayHook(text: formattedString)
        return formattedString
    }
    
    func encodeHook<Value: Encodable>(context: Value) -> Data? {
        return nil
    }
    
    func formattedString(data: Data) -> String? {
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func displayHook(text: String) {
        print(text)
    }
}
class JSONDisplayable: PrettyPrintable {
    
    lazy var jsonEncoder = JSONEncoder()
    
    func encodeHook<Value: Encodable>(context: Value) -> Data? {
        let jsonData = try? jsonEncoder.encode(context)
        return jsonData
    }
}

class XMLDisplayable: PrettyPrintable {
    
    lazy var pListEncoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()
    
    func encodeHook<Value: Encodable>(context: Value) -> Data? {
        let pListData = try? pListEncoder.encode(context)
        return pListData
    }
}
//: Testing
let jony = Contact(firstName: "Jony", lastName: "Ive", phone: "555-5555")
let steve = Contact(firstName: "Steve", lastName: "Appleseed", phone: "444-4444")

var contacts = Contacts(contacts: [jony, steve])

let xmlDisplayer = XMLDisplayable()
xmlDisplayer.display(context: contacts)

let jsonDisplayer = JSONDisplayable()
jsonDisplayer.display(context: contacts)
