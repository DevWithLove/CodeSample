//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## State
//: Allows an object to behave differently when its internal state changes.
//:
//: ##  ATM Demo Refactor
//: Revamp using the State pattern. Get rid of the complex conditional logic
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

public final class ATM {
    fileprivate var state: ATMState = IdleState()
    
    public func enter(pin: String) {
        state = EnterPINState(context: self)
        state.validate(pin: pin)
    }
    
    public func withdraw(amount: Float) -> Bool {
        return state.withdraw(amount: amount)
    }
}

fileprivate protocol ATMState {
    func validate(pin: String)
    func withdraw(amount: Float) -> Bool
    func transactionCompleted(success: Bool)
}

extension ATMState {
    func validate(pin: String) {
        print("\(#function) not implemented for \(self) state")
    }
    
    func withdraw(amount: Float) -> Bool {
        print("\(#function) not implemented for \(self) state")
        return false
    }
    
    func transactionCompleted(success: Bool) {
        print("\(#function) not implemented for \(self) state")
    }
}

fileprivate struct IdleState: ATMState {}

fileprivate struct EnterPINState: ATMState {
    var context: ATM
    
    func validate(pin: String) {
        guard pin == "1234" else {
            print("INVALID PIN")
            context.state = TransactionCompleteState(context: context)
            context.state.transactionCompleted(success: false)
            return
        }
        
        print("PIN OK")
        context.state = WithdrawState(context: context)
    }
}

fileprivate struct TransactionCompleteState: ATMState {
    var context: ATM
    
    func transactionCompleted(success: Bool) {
        var statusMessage = success ? "Transaction complete..." : "Transaction failed..."
        statusMessage += " don't forget your card!"
        print(statusMessage)
        context.state = IdleState()
    }
}

fileprivate struct WithdrawState: ATMState {
    var context: ATM
    static var availableFunds: Float = 1000
    
    func withdraw(amount: Float) -> Bool {
        print("> Withdraw $\(amount)")
        
        guard amount > 0 else {
            print("Error! Enter a valid amount")
            context.state = TransactionCompleteState(context: context)
            context.state.transactionCompleted(success: false)
            return false
        }
        
        guard WithdrawState.availableFunds >= amount else {
            print("Insufficient funds!")
            context.state = TransactionCompleteState(context: context)
            context.state.transactionCompleted(success: false)
            return false
        }
        
        WithdrawState.availableFunds -= amount
        context.state = TransactionCompleteState(context: context)
        context.state.transactionCompleted(success: true)
        return true
    }
}
//: Testing
let atm = ATM()
atm.enter(pin: "1234")
atm.withdraw(amount: 5000)
