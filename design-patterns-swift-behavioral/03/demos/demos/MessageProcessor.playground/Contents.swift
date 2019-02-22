//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Chain of Responsibility
//: Organizes potential request processors in a sequence and decouples responders from callers.
//:
//: ##  MessageProcessor demo
//: Let the right object process a particular message
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

public protocol Message {
    var name: String {get}
}

public protocol MessageProcessing {
    init(next: MessageProcessing?)
    func process(message: Message)
    
    var messageIDs: [String]? {get}
    var next: MessageProcessing? {get}
}

extension MessageProcessing {
    public func process(message: Message) {
        if let shouldProcess = messageIDs?.contains(where: { $0 == message.name }),
            shouldProcess == true {
            print("Message processed by \(self)\n")
        } else {
            if let next = next {
                print("\(self) could not process message \(message.name)")
                print("\t Forwarding to \(next)")
                next.process(message: message)
            } else {
                print("Next responder not set. Reached the end of the responder chain\n")
            }
        }
    }
}

public struct ResponseMessage: Message {
    public var name: String
}

public struct XMLProcessor: MessageProcessing, CustomStringConvertible {
    public var next: MessageProcessing? {
        return nextProcessor
    }

    fileprivate var nextProcessor: MessageProcessing?
    
    public var messageIDs: [String]? {
        return ["XML"]
    }
    
    public init(next: MessageProcessing?) {
        nextProcessor = next
    }
    
// Extracted to protocol extension
    
//    public func process(message: Message) {
//        if let shouldProcess = messageIDs?.contains(where: { $0 == message.name }),
//            shouldProcess == true {
//            print("Message processed by \(self)\n")
//        } else {
//            if let next = nextProcessor {
//                print("\(self) could not process message \(message.name)")
//                print("\t Forwarding to \(next)")
//                next.process(message: message)
//            } else {
//                print("Next responder not set. Reached the end of the responder chain\n")
//            }
//        }
//    }
    
    public var description: String {
        return "XMLProcessor"
    }
}


public struct JSONProcessor: MessageProcessing, CustomStringConvertible {
    public var next: MessageProcessing? {
        return nextProcessor
    }

    fileprivate var nextProcessor: MessageProcessing?
    
    public var messageIDs: [String]? {
        return ["JSON"]
    }
    
    public init(next: MessageProcessing?) {
        nextProcessor = next
    }
    
// Extracted to protocol extension
    
//    public func process(message: Message) {
//        if let shouldProcess = messageIDs?.contains(where: { $0 == message.name }),
//            shouldProcess == true {
//            print("Message processed by \(self)\n")
//        } else {
//            if let next = nextProcessor {
//                print("\(self) could not process request \(message.name)")
//                print("\t Forwarding to \(next)")
//                next.process(message: message)
//            } else {
//                print("Next responder not set. Reached the end of the responder chain\n")
//            }
//        }
//    }
    
    public var description: String {
        return "JSONProcessor"
    }
}


public struct ResponderChainEnd: MessageProcessing {
    public var next: MessageProcessing? = nil

    public var messageIDs: [String]? {
        return nil
    }
    
    public init(next: MessageProcessing?) {
        //
    }
    
    public func process(message: Message) {
        print("Reached the end of the responder chain\n")
    }
}
//: Testing
let message = ResponseMessage(name: "Test")

let responderChainEnd = ResponderChainEnd(next: nil)
let jsonProcessor = JSONProcessor(next: responderChainEnd)
let xmlProcessor = XMLProcessor(next: jsonProcessor)

xmlProcessor.process(message: message)


let xmlMessage = ResponseMessage(name: "XML")
xmlProcessor.process(message: xmlMessage)

let jsonMessage = ResponseMessage(name: "JSON")
xmlProcessor.process(message: jsonMessage)
