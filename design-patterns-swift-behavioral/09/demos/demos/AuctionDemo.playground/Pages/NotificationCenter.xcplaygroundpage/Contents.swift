//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Observer
//: Allows subscribers to get notified about changes in another object, without being tightly coupled to the sender.
//:
//: ##  Auction Demo using NotificationCenter
//: Notify bidders when bid changes. Avoid tight coupling between auctioneer and bidders
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation
struct Bidder {
    var id: String
    init(id: String) {
        self.id = id
        NotificationCenter.default.addObserver(forName: NSNotification.Name(BidNotificationNames.bidNotification), object: nil, queue: nil) { (notification) in
            if let userInfo = notification.userInfo,
                let bidValue = userInfo["bid"] as? Float,
                let message = userInfo["message"] as? String {
                print("\t\(id) new bid is \(bidValue) \(message)")
            }
        }
    }
}

struct BidNotificationNames {
    static let bidNotification = "bidNotification"
}

struct BidNotification {
    var bid: Float
    var message: String?
}

struct Auctioneer {
    private var bidders = [Bidder]()

    private var auctionEnded: Bool = false
    private var currentBid: Float = 0
    private var reservePrice: Float = 0
    
    var bid: Float {
        set {
            if auctionEnded {
                print("\nAuction ended. We don't accept new bids")
            } else if newValue > currentBid {
                print("\nNew bid $\(newValue) accepted")
                if newValue >= reservePrice {
                    print("Reserve price met! Auction ended.")
                    auctionEnded = true
                }
                currentBid = newValue
                
                let message = bid > reservePrice ? "Reserve met, item sold" : ""
                let notification = Notification(name: Notification.Name(BidNotificationNames.bidNotification), object: nil, userInfo: ["bid": bid, "message": message])
                NotificationCenter.default.post(notification)
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

auctioneer.bid = 100
auctioneer.bid = 150

//auctioneer.detach(observer: bidder1)
auctioneer.bid = 300
auctioneer.bid = 550

//: [Previous: ClassicObserver](@previous)
