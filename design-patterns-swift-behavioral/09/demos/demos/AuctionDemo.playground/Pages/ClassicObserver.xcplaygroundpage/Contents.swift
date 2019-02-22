//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Observer
//: Allows subscribers to get notified about changes in another object, without being tightly coupled to the sender.
//:
//: ##  Auction Demo using the Classic Observer
//: Notify bidders when bid changes. Avoid tight coupling between auctioneer and bidders
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

protocol Observer {
    associatedtype Notification
    func update(notification: Notification)
}

protocol Subject {
    associatedtype O: Observer
    mutating func attach(observer: O)
    mutating func detach(observer: O)
    func notifyObservers()
}

struct Bidder: Observer {
    var id: String
    
    func update(notification: BidNotification) {
        print("\t\(self.id) new bid is:\(notification.bid) \(notification.message ?? "")")
    }
}

struct BidNotification {
    var bid: Float
    var message: String?
}

struct Auctioneer: Subject {
    private var bidders = [Bidder]()
    
    mutating func attach(observer: Bidder) {
        bidders.append(observer)
    }
    
    mutating func detach(observer: Bidder) {
        self.bidders = bidders.filter{ $0.id != observer.id }
    }
    
    func notifyObservers() {
        let message = bid > reservePrice ? "Reserve met, item sold" : nil
        let notification = BidNotification(bid: bid, message: message)
        bidders.forEach { $0.update(notification: notification) }
    }
    
    mutating func attach(observers: [Bidder]) {
        bidders.append(contentsOf: observers)
    }
    
    private var auctionEnded: Bool = false
    private var currentBid: Float = 0
    private var reservePrice: Float = 0
    var bid: Float {
        set {
            if auctionEnded {
                print("\nAuction ended. We don't accept new bids.")
            } else if newValue > currentBid {
                print("\nNew bid $\(newValue) accepted")
                if newValue >= reservePrice {
                    print("Reserve price met! Auction ended.")
                    auctionEnded = true
                }
                currentBid = newValue
                notifyObservers()
            }
        }
        get {
            return currentBid
        }
    }

    init(initialBid: Float = 0, reservePrice: Float) {
        self.bid = initialBid
        self.reservePrice = reservePrice
    }
}
//: Testing
var auctioneer = Auctioneer(reservePrice: 500)

let bidder1 = Bidder(id: "Joe")
let bidder2 = Bidder(id: "Quinn")
let bidder3 = Bidder(id: "Sal")
let bidder4 = Bidder(id: "Murr")

auctioneer.attach(observers: [bidder1, bidder2, bidder3, bidder4])

auctioneer.bid = 100
auctioneer.bid = 150
auctioneer.detach(observer: bidder1)
auctioneer.bid = 300
auctioneer.bid = 550

//: [Next: NotificationCenter](@next)
