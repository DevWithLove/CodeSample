//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Interpreter
//: Defines a simple language and an object representation of the language grammar along with an interpreter to evaluate the grammar.
//:
//: ##  Steering Demo
//: Interpret a language consisting of simple steering commands.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import UIKit
import PlaygroundSupport

struct Pose {
    var position: (Int, Int)
    var orientation: (Int, Int)
}

protocol Expression {
    func interpret(context: inout Pose)
}

struct North: Expression {
    func interpret(context pose: inout Pose) {
        pose.orientation = (0, -1)
    }
}

struct South: Expression {
    func interpret(context pose: inout Pose) {
        pose.orientation = (0, 1)
    }
}

struct East: Expression {
    func interpret(context pose: inout Pose) {
        pose.orientation = (1, 0)
    }
}

struct West: Expression {
    func interpret(context pose: inout Pose) {
        pose.orientation = (-1, 0)
    }
}

struct Move: Expression {
    func interpret(context pose: inout Pose) {
        pose.position = (pose.position.0 + pose.orientation.0 * 10, pose.position.1 + pose.orientation.1 * 10)
    }
}

struct Unknown: Expression {
    func interpret(context position: inout Pose) {
        print("Unsupported")
    }
}

let directions = "headSouth move move headEast move move headNorth move move headWest move move move headNorth move move move"

let commands = directions.components(separatedBy: .whitespaces)

// start at origin, heading North
var context = Pose(position: (250, 250), orientation: (0, -1))

var positions = [(Int, Int)]()
positions.append(context.position)

for command in commands {
    var expression: Expression
    switch command {
    case "move":
        expression = Move()
    case "headNorth":
        expression = North()
    case "headSouth":
        expression = South()
    case "headEast":
        expression = East()
    case "headWest":
        expression = West()
    default:
        expression = Unknown()
    }
    
    expression.interpret(context: &context)
    positions.append(context.position)
}

class PathView : UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        
        let initialPosition = positions.remove(at: 0)
        path.move(to: CGPoint(x: initialPosition.0, y: initialPosition.1))
        
        for position in positions {
            path.addLine(to: CGPoint(x: position.0, y: position.1))
            path.move(to: CGPoint(x: position.0, y: position.1))
        }
        
        path.close()
        let strokeColor = UIColor.white
        strokeColor.setStroke()
        path.lineWidth = 5
        
        path.stroke()
    }
}
//: Testing
let graphView = PathView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = graphView
