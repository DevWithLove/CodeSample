//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Interpreter
//: Defines a simple language and an object representation of the language grammar along with an interpreter to evaluate the grammar.
//:
//: ##  Calculator Demo
//: Add support for compound expressions
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

protocol Expression {
    func interpret() -> Double
}

struct Number: Expression {
    private let value: Double
    
    init(value: Double) {
        self.value = value
    }
    
    func interpret() -> Double {
        return self.value
    }
}

protocol CompoundExpression: Expression {
    var leftOperand: Expression { get }
    var rightOperand: Expression { get }
    init(lhs: Expression, rhs: Expression)
}

struct Add: CompoundExpression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(lhs: Expression, rhs: Expression) {
        self.leftOperand = lhs
        self.rightOperand = rhs
    }
    
    func interpret() -> Double {
        return self.leftOperand.interpret() + self.rightOperand.interpret()
    }
}

struct Subtract: CompoundExpression {
    var leftOperand: Expression
    var rightOperand: Expression
    
    init(lhs: Expression, rhs: Expression) {
        self.leftOperand = lhs
        self.rightOperand = rhs
    }
    
    func interpret() -> Double {
        return self.leftOperand.interpret() - self.rightOperand.interpret()
    }
}

func parse(_ text: String) -> Double {
    var result: Double = 0
    
    let items: [String] = text.components(separatedBy: CharacterSet.whitespaces)
    var accumulator = Number(value: 0)
    
    var index = 0
    
    while index < items.count {
        let item = items[index]
        let expression: Expression
        
        switch item {
        case "plus":
            guard (index + 1) < items.count,
                let nextValue = Double(items[index + 1]) else {
                    print("Parse Error: The expression \(text) is invalid")
                    return Double.nan
            }
            let nextExpression = Number(value: nextValue)
            let prevValue = accumulator
            
            expression = Add(lhs: prevValue, rhs: nextExpression)
            result = expression.interpret()
            
            accumulator = Number(value: result)
            
            index += 2
            
        case "minus":
            guard (index + 1) < items.count,
                let nextValue = Double(items[index + 1]) else {
                    print("Parse Error: The expression \"\(text)\" is invalid")
                    return Double.nan
            }
            let nextExpression = Number(value: nextValue)
            expression = Subtract(lhs: accumulator, rhs: nextExpression)
            
            result = expression.interpret()
            
            accumulator = Number(value: result)
            
            index += 2
            
        default:
            if let doubleValue = Double(item) {
                let previousIndex = index - 1
                if previousIndex >= 0 {
                    guard items[previousIndex] == "+" || items[previousIndex] == "-" else {
                        print("Parse Error: the sequence \"\(items[previousIndex]) \(item)\" is invalid in expression \"\(text)\".")
                        return Double.nan
                    }
                }
                accumulator = Number(value: doubleValue)
            } else {
                print("Invalid token \"\(item)\" found at index \(index)")
            }
            
            index += 1
        }
    }
    
    return result
}

//: Testing
let str = "1 plus 3 minus 7 plus 11 minus 8 plus 10"
let res = parse(str)
print(res)
