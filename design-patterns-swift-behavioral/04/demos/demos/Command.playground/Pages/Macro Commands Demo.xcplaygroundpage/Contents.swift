//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Command
//: Encapsulates a request into an object. Allows performing requests without knowing the actions or the receiver.
//:
//: ##  Undoable Commands
//: Add support for macro commands
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


struct ScaleArgs {
    var duration: TimeInterval
    var scale: Float
}

struct ScaleCommand: EnhancedAnimationCommand {
    let receiver: UIView
    let arguments: ScaleArgs?
    
    init(receiver: UIView, arguments: ScaleArgs? = ScaleArgs(duration: 0.3, scale: 1)) {
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        if let scale = arguments?.scale {
            UIView.animate(withDuration: arguments?.duration ?? 0.3, animations: {
                self.receiver.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            })
        }
    }
}











struct RotateArgs {
    var duration: TimeInterval
    var degrees: Float
}

struct RotateCommand: EnhancedAnimationCommand {
    let receiver: UIView
    let arguments: RotateArgs?
    
    init(receiver: UIView, arguments: RotateArgs? = RotateArgs(duration: 0.3, degrees: 1)) {
        self.receiver = receiver
        self.arguments = arguments
    }
    
    func execute() {
        if let rotate = arguments?.degrees {
            let angleRadians = CGFloat(rotate * .pi / 180)
            
            UIView.animate(withDuration: arguments?.duration ?? 0.3, animations: {
                self.receiver.transform = CGAffineTransform(rotationAngle: angleRadians)
            })
        }
    }
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


class MacroAnimationCommands {
    fileprivate var commands = [Command]()
    
    func addCommands(_ commands: [Command]) {
        self.commands.append(contentsOf: commands)
    }
    
    func execute() {
        for command in commands {
            command.execute()
        }
    }
}

//: Testing
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = containerView

let view = UIView(frame: CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: 100, height: 100))
view.center = containerView.center

view.backgroundColor = .white
containerView.addSubview(view)

// scale up -> fade out -> rotate -> fade in -> scale down -> rotate back
let macro = MacroAnimationCommands()

// scale-up command first
let scaleUpCommand = ScaleCommand(receiver: view, arguments: ScaleArgs(duration: 2, scale: 2))
// fade out
let fadeOutCommand = FadeOutCommand(receiver: view, arguments: 2)
// rotate 180 degrees
let rotateCommand = RotateCommand(receiver: view, arguments: RotateArgs(duration: 2, degrees: 180))

macro.addCommands([scaleUpCommand, fadeOutCommand, rotateCommand])

macro.execute()

//: [Previous: Undoable Commands](@previous)

