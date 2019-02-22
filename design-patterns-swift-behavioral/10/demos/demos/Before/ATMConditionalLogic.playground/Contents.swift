//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## State
//: Allows an object to behave differently when its internal state changes.
//:
//: ##  ATM Demo with Conditional Logic
//: This is the original project we're going to refactor.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

public final class ATM {
    private var isPINValid = false
    fileprivate static var availableFunds: Float = 1000
    
    public func enter(pin: String) {
        guard pin == "1234" else {
            print("INVALID PIN")
            print("Transaction Failed… don’t forget your card!")
            return
        }
        
        isPINValid = true
        print("PIN OK")
    }
    
    public func withdraw(amount: Float) -> Bool {
        guard isPINValid == true else {
            return false
        }
        
        print("> Withdraw $\(amount)")
        
        guard amount > 0 else {
            print("Error! Enter a valid amount")
            return false
        }
        
        var result = true
        
        if ATM.availableFunds >= amount {
            ATM.availableFunds -= amount
        } else {
            print("Insufficient funds!")
            result = false
        }
        
        print("Transaction Complete… don’t forget your card!")
        return result
    }
}
//: Testing
let atm = ATM()
atm.enter(pin: "1234")
atm.withdraw(amount: 1500)
