//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Iterator
//: Provides sequential access to the elements of a container without exposing its underlying details.
//:
//: ##  StackTraversal
//: Add traversal capability to a custom collection
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

struct Stack<T> {
    fileprivate var items = [T]()
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T? {
        return items.popLast()
    }
}

extension Stack: Sequence {
    public func makeIterator() -> Array<T>.Iterator {
        return items.makeIterator()
    }
}

//: Testing
var stack = Stack<Int>()

stack.push(1)
stack.push(3)
stack.push(7)

for n in stack {
    print(n)
}

//: [Next: Custom Iterator](@next)
