//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Command
//: Encapsulates a request into an object. Allows performing requests without knowing the actions or the receiver.
//:
//: ##  Animation Commands
//: Encapsulate animation method invocations in command objects
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

struct FadeOutCommand: Command {
    fileprivate let receiver: UIView
    fileprivate let duration: TimeInterval
    
    init(receiver: UIView, duration: TimeInterval = 0.3) {
        self.receiver = receiver
        self.duration = duration
    }
    
    func execute() {
        UIView.animate(withDuration: duration) {
            self.receiver.alpha = 0
        }
    }
}

struct FadeInCommand: Command {
    fileprivate let receiver: UIView
    fileprivate let duration: TimeInterval
    
    init(receiver: UIView, duration: TimeInterval = 0.3) {
        self.receiver = receiver
        self.duration = duration
    }
    
    func execute() {
        UIView.animate(withDuration: duration) {
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

let fadeOutCommand = FadeOutCommand(receiver: view, duration: 2)

invoker.setCommand(fadeOutCommand)

let delay = 2
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) { 
    
    invoker.animate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: { 
        let fadeInCommand = FadeInCommand(receiver: view, duration: 2)
        invoker.setCommand(fadeInCommand)
        
        invoker.animate()
    })
}

//: [Next: Enhanced Commands](@next)
