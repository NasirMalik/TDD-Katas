// Shopping Basket Kata
// https://sammancoaching.org/kata_descriptions/shopping_basket.html
//
// Rules:
//   Add items with a unit price and quantity.
//   Discount tiers (applied to basket total before discounts):
//     > $100 → 5% off
//     > $200 → 10% off

struct BasketItem {
    let name: String
    let unitPrice: Double
    let quantity: Int

    var subtotal: Double { unitPrice * Double(quantity) }
}

class ShoppingBasket {
    private var items: [BasketItem] = []

    func add(name: String, unitPrice: Double, quantity: Int = 1) {
        items.append(BasketItem(name: name, unitPrice: unitPrice, quantity: quantity))
    }

    func quantity(of name: String) -> Int {
        items.filter { $0.name == name }.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Double { items.reduce(0) { $0 + $1.subtotal } }

    var discountRate: Double {
        switch subtotal {
        case let s where s > 200: return 0.10
        case let s where s > 100: return 0.05
        default:                  return 0.0
        }
    }

    var total: Double { subtotal * (1 - discountRate) }
}

// MARK: - Test Helpers

func assertEqual(_ actual: Double, _ expected: Double, tolerance: Double = 0.001, _ label: String = "") {
    if abs(actual - expected) <= tolerance {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected \(expected), got \(actual)")
    }
}

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ label: String = "") {
    if actual == expected {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected \"\(expected)\", got \"\(actual)\"")
    }
}

// MARK: - Tests

func runTests() {
    let basket = ShoppingBasket()
    assertEqual(basket.total, 0.0, "empty basket total")

    // Below $100 — no discount
    basket.add(name: "Book", unitPrice: 20.0, quantity: 3)
    assertEqual(basket.subtotal,    60.0, "subtotal $60")
    assertEqual(basket.discountRate, 0.0, "no discount below $100")
    assertEqual(basket.total,       60.0, "total equals subtotal")

    // Between $100-$200 — 5%
    basket.add(name: "Widget", unitPrice: 50.0, quantity: 2)  // +$100 → subtotal $160
    assertEqual(basket.discountRate, 0.05, "5% discount over $100")
    assertEqual(basket.total,       152.0, "total after 5% discount")

    // Over $200 — 10%
    basket.add(name: "Gadget", unitPrice: 60.0, quantity: 1)  // +$60 → subtotal $220
    assertEqual(basket.discountRate, 0.10, "10% discount over $200")
    assertEqual(basket.total,       198.0, "total after 10% discount")

    // Quantity tracking
    assertEqual(basket.quantity(of: "Book"),    3, "book quantity")
    assertEqual(basket.quantity(of: "Widget"),  2, "widget quantity")
    assertEqual(basket.quantity(of: "Unknown"), 0, "unknown item quantity")
}

runTests()
