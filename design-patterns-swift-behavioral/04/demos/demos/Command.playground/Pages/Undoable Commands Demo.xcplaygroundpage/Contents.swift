//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Command
//: Encapsulates a request into an object. Allows performing requests without knowing the actions or the receiver.
//:
//: ##  Undoable Commands
//: Add support for undo operations
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import UIKit
import PlaygroundSupport

protocol Command {
    func execute()
    func undo()
}

protocol EnhancedAnimationCommand: Command {
    
    associatedtype Arguments
    
    var receiver: UIView { get }
    var arguments: Arguments? { get }
    
    init(receiver: UIView, arguments: Arguments?)
}

extension EnhancedAnimationCommand {
    var argumets: Arguments? { return nil }
}

struct FadeOutCommand: EnhancedAnimationCommand {
    let receiver: UIView
    let arguments: TimeInterval?
    
    init(receiver: UIView, arguments: TimeInterval? = 0.3) {
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        UIView.animate(withDuration: arguments ?? 0.3) {
            self.receiver.alpha = 0
        }
    }
    
    func undo() {
        UIView.animate(withDuration: arguments ?? 0.3) { 
            self.receiver.alpha = 1
        }
    }
}

struct FadeInCommand: EnhancedAnimationCommand {
    let receiver: UIView
    let arguments: TimeInterval?
    
    init(receiver: UIView, arguments: TimeInterval? = 0.3) {
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        UIView.animate(withDuration: arguments ?? 0.3) {
            self.receiver.alpha = 1
        }
    }
    
    func undo() {
        UIView.animate(withDuration: arguments ?? 0.3) { 
            self.receiver.alpha = 0
        }
    }
}

class AnimationController {
    fileprivate var commandsByID = [String: Command]()
    fileprivate var undoStack = [Command]()
    
    func setCommand(_ command: Command, id: String) {
        commandsByID[id] = command
    }

    func performCommand(id: String) {
        guard let command = commandsByID[id] else {
            print("No command found for \(id)")
            return
        }
        
        undoStack.append(command)
        command.execute()
    }
    
    func undo() {
        guard undoStack.isEmpty == false else {
            return
        }
        
        let lastCommand = undoStack.removeLast()
        lastCommand.undo()
    }
}
//: Testing
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = containerView

let view = UIView(frame: CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: 100, height: 100))
view.center = containerView.center

view.backgroundColor = .white
containerView.addSubview(view)

// scale up -> fade out -> fade in -> scale down
let invoker = AnimationController()

// fade out
let fadeOutCommand = FadeOutCommand(receiver: view, arguments: 2)

// fade in
let fadeInCommand = FadeInCommand(receiver: view, arguments: 2)

invoker.setCommand(fadeOutCommand, id: "FadeOut")
invoker.setCommand(fadeInCommand, id: "FadeIn")

// fade out the view
invoker.performCommand(id: "FadeOut")

let delay = 2
// fade-in after some delay
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
    
    // fade in the view
    invoker.performCommand(id: "FadeIn")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
        // undo last command
        // it was fade in, so the view will now fade out
        invoker.undo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
            // undo last command
            // it was fade out, so the view will now fade in
            invoker.undo()
        })
    })
})

//: [Previous: Enhanced Commands](@previous) | [Next: Macro Commands](@next)
