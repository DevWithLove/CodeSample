//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Visitor
//: Allows adding new behavior to unrelated types without changing their implementation.
//:
//: ##  ShoppingCart - Classical Visitor
//: Calculate total price of unrelated items.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

struct Book {
    var isbn: String
    var title: String
    var itemPrice: Float
}

struct Computer {
    var serialNumber: String
    var brand: String
    var unitPrice: Float
}

struct Car {
    var ean: String
    var make: String
    var model: String
    var stickerPrice: Float
}

protocol Visitor {
    func visit(item: Book)
    func visit(item: Computer)
    func visit(item: Car)
}

protocol Product {
    func accept(visitor: Visitor)
}

extension Book: Product {
    func accept(visitor: Visitor) {
        visitor.visit(item: self)
    }
}

extension Computer: Product {
    func accept(visitor: Visitor) {
        visitor.visit(item: self)
    }
}

extension Car: Product {
    func accept(visitor: Visitor) {
        visitor.visit(item: self)
    }
}

class PriceVisitor: Visitor {
    var totalPrice: Float = 0
    func visit(item: Book) {
        totalPrice += item.itemPrice
    }
    
    func visit(item: Computer) {
        totalPrice += item.unitPrice
    }
    
    func visit(item: Car) {
        totalPrice += item.stickerPrice
    }
}

let book = Book(isbn: "178-4-19-155607-0", title: "Swift Design Patterns", itemPrice: 30)
let macBook = Computer(serialNumber: "12345-00", brand: "Apple MacBook Pro", unitPrice: 2500)
let teslaS = Car(ean: "1KL4KXBG0AF148193", make: "Tesla", model: "S", stickerPrice: 69200)

var shoppingCart = [Any]()
shoppingCart.append(contentsOf: [book, macBook, teslaS])

func calculateTotalPrice(items: [Product]) -> Float {
    let priceVisitor = PriceVisitor()
    
    for item in items {
        item.accept(visitor: priceVisitor)
    }
    return priceVisitor.totalPrice
}

print(calculateTotalPrice(items: shoppingCart as! [Product]))
