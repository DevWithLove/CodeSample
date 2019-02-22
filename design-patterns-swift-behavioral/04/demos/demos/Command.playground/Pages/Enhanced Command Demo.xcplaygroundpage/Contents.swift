//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Command
//: Encapsulates a request into an object. Allows performing requests without knowing the actions or the receiver.
//:
//: ##  Enhanced Commands
//: Embed references to receiver and arguments in the command protocol
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import UIKit
import PlaygroundSupport

protocol Command {
    func execute()
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
}

class AnimationController {
    fileprivate var command: Command?
    
    func setCommand(_ command: Command) {
        self.command = command
    }
    
    func animate() {
        command?.execute()
    }
}
//: Testing
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = containerView

let view = UIView(frame: CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: 100, height: 100))
view.center = containerView.center
view.backgroundColor = .white

containerView.addSubview(view)

let invoker = AnimationController()

let fadeOutCommand = FadeOutCommand(receiver: view, arguments: 2)

invoker.setCommand(fadeOutCommand)

let delay = 2
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
    
    invoker.animate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
        let fadeInCommand = FadeInCommand(receiver: view, arguments: 2)
        invoker.setCommand(fadeInCommand)
        
        invoker.animate()
    })
}

//: [Previous: Animation Commands](@previous) | [Next: Undoable Commands](@next)
