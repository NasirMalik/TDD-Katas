// Supermarket Receipt Kata
// https://sammancoaching.org/kata_descriptions/supermarket_receipt.html
//
// Rules:
//   Products have a price; cart holds quantities.
//   Promotions: buy-N-get-one-free, % discount, bundle pricing.
//   Receipt shows line items, discounts, and total.

struct Product: Hashable {
    let name:  String
    let price: Double
}

// MARK: - Promotions

enum Promotion {
    case buyNGetOneFree(n: Int)     // e.g. buy 2 get 1 free → every 3rd is free
    case percentDiscount(Double)    // e.g. 0.20 = 20% off
    case bundlePrice(quantity: Int, bundlePrice: Double) // e.g. 5 for $7.49
}

struct ReceiptLine {
    let product:  Product
    let quantity: Double
    let total:    Double
}

struct Discount {
    let product:     Product
    let description: String
    let amount:      Double   // negative
}

struct Receipt {
    let lines:     [ReceiptLine]
    let discounts: [Discount]

    var subtotal: Double { lines.reduce(0)     { $0 + $1.total } }
    var savings:  Double { discounts.reduce(0) { $0 + $1.amount } }
    var total:    Double { subtotal + savings }
}

// MARK: - Cart & Checkout

class ShoppingCart {
    private var items: [(Product, Double)] = []

    func add(_ product: Product, quantity: Double = 1) {
        items.append((product, quantity))
    }

    func checkout(promotions: [Product: Promotion] = [:]) -> Receipt {
        // Aggregate quantities
        var quantities: [Product: Double] = [:]
        for (product, qty) in items {
            quantities[product, default: 0] += qty
        }

        var lines: [ReceiptLine] = []
        var discounts: [Discount] = []

        for (product, qty) in quantities {
            let lineTotal = product.price * qty
            lines.append(ReceiptLine(product: product, quantity: qty, total: lineTotal))

            if let promo = promotions[product] {
                switch promo {
                case .buyNGetOneFree(let n):
                    let freeCount = floor(qty / Double(n + 1))
                    if freeCount > 0 {
                        let saving = -freeCount * product.price
                        discounts.append(Discount(product: product,
                            description: "Buy \(n) get 1 free", amount: saving))
                    }
                case .percentDiscount(let pct):
                    let saving = -(lineTotal * pct)
                    discounts.append(Discount(product: product,
                        description: "\(Int(pct*100))% off", amount: saving))
                case .bundlePrice(let bundleQty, let bundlePrice):
                    let bundles = floor(qty / Double(bundleQty))
                    if bundles > 0 {
                        let normalCost = bundles * Double(bundleQty) * product.price
                        let bundleCost = bundles * bundlePrice
                        discounts.append(Discount(product: product,
                            description: "\(bundleQty) for \(bundlePrice)", amount: bundleCost - normalCost))
                    }
                }
            }
        }

        return Receipt(lines: lines, discounts: discounts)
    }
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
    let toothbrush = Product(name: "Toothbrush", price: 0.99)
    let apple      = Product(name: "Apple",      price: 1.99)
    let toothpaste = Product(name: "Toothpaste", price: 1.79)

    let cart = ShoppingCart()
    cart.add(toothbrush, quantity: 2)
    cart.add(apple,      quantity: 0.5)  // sold by weight (kg)
    cart.add(toothpaste, quantity: 5)

    let promotions: [Product: Promotion] = [
        toothbrush: .buyNGetOneFree(n: 2),     // buy 2 get 1 free
        apple:      .percentDiscount(0.20),     // 20% off
        toothpaste: .bundlePrice(quantity: 5, bundlePrice: 7.49)
    ]

    let receipt = cart.checkout(promotions: promotions)

    assertEqual(receipt.lines.count,     3, "three product lines")
    assertEqual(receipt.discounts.count, 3, "three discounts applied")

    // Apple: 0.5 * $1.99 = $0.995, 20% off = $0.199
    let appleLine = receipt.lines.first { $0.product == apple }!
    assertEqual(appleLine.total, 0.995, tolerance: 0.001, "apple line total")

    // Toothpaste: 5 * $1.79 = $8.95, bundle $7.49 → saving $-1.46
    let pasteDiscount = receipt.discounts.first { $0.product == toothpaste }!
    assertEqual(pasteDiscount.amount, 7.49 - 8.95, tolerance: 0.001, "toothpaste bundle saving")

    // Total should be less than subtotal (discounts applied)
    assertEqual(receipt.total < receipt.subtotal, true, "total is less than subtotal")
}

runTests()
