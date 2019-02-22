//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Visitor
//: Allows adding new behavior to unrelated types without changing their implementation.
//:
//: ##  ShoppingCart - with Type Extensions
//: Calculate total price of unrelated items.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

protocol CommonAttributes {
    var price: Float { get }
}

struct Book {
    var isbn: String
    var title: String
    var itemPrice: Float
}

extension Book: CommonAttributes {
    var price: Float {
        return itemPrice
    }
}

struct Computer {
    var serialNumber: String
    var brand: String
    var unitPrice: Float
}

extension Computer: CommonAttributes {
    var price: Float {
        return unitPrice
    }
}

struct Car {
    var ean: String
    var make: String
    var model: String
    var stickerPrice: Float
}

extension Car: CommonAttributes {
    var price: Float {
        return stickerPrice
    }
}

let book = Book(isbn: "178-4-19-155607-0", title: "Swift Design Patterns", itemPrice: 30)
let macBook = Computer(serialNumber: "12345-00", brand: "Apple MacBook Pro", unitPrice: 2500)
let teslaS = Car(ean: "1KL4KXBG0AF148193", make: "Tesla", model: "S", stickerPrice: 69200)

var shoppingCart = [CommonAttributes]()
shoppingCart.append(contentsOf: [book, macBook, teslaS] as [CommonAttributes])


func calculateTotalPrice(items: [CommonAttributes]) -> Float {
    var price: Float = 0
    for item in items {
        price += item.price
    }
    return price
}

print(calculateTotalPrice(items: shoppingCart))
