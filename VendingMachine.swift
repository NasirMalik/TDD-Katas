// Vending Machine Kata
// https://sammancoaching.org/kata_descriptions/vending_machine.html
//
// Rules:
//   Accepts nickels (5¢), dimes (10¢), quarters (25¢); rejects pennies.
//   Products: cola $1.00, chips $0.50, candy $0.65.
//   Display: "INSERT COIN" when empty, amount when coins inserted.
//   "THANK YOU" on purchase (then resets), "PRICE x" if insufficient funds.
//   "SOLD OUT" if inventory empty. "EXACT CHANGE ONLY" when machine can't make change.

enum Coin: Int {
    case penny = 1, nickel = 5, dime = 10, quarter = 25
}

enum Product: String {
    case cola = "Cola", chips = "Chips", candy = "Candy"
    var price: Int {
        switch self { case .cola: return 100; case .chips: return 50; case .candy: return 65 }
    }
}

class VendingMachine {
    private var insertedCents: Int = 0
    private var coinReturn:    [Coin] = []
    private var inventory:     [Product: Int] = [.cola: 5, .chips: 5, .candy: 5]
    private var lastMessage:   String? = nil

    func insert(coin: Coin) {
        if coin == .penny {
            coinReturn.append(coin)
        } else {
            insertedCents += coin.rawValue
        }
    }

    func select(product: Product) {
        guard (inventory[product] ?? 0) > 0 else {
            lastMessage = "SOLD OUT"
            return
        }
        if insertedCents >= product.price {
            let change = insertedCents - product.price
            insertedCents = 0
            inventory[product]! -= 1
            lastMessage = "THANK YOU"
            makeChange(cents: change)
        } else {
            lastMessage = "PRICE \(formatCents(product.price))"
        }
    }

    func returnCoins() {
        makeChange(cents: insertedCents)
        insertedCents = 0
    }

    func collectCoinReturn() -> [Coin] {
        defer { coinReturn = [] }
        return coinReturn
    }

    var display: String {
        if let msg = lastMessage {
            lastMessage = nil
            return msg
        }
        if insertedCents == 0 { return "INSERT COIN" }
        return formatCents(insertedCents)
    }

    private func formatCents(_ cents: Int) -> String {
        return String(format: "$%.2f", Double(cents) / 100)
    }

    private func makeChange(cents: Int) {
        var remaining = cents
        for coin in [Coin.quarter, .dime, .nickel] {
            while remaining >= coin.rawValue {
                coinReturn.append(coin)
                remaining -= coin.rawValue
            }
        }
    }
}

// MARK: - Test Helpers

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ label: String = "") {
    if actual == expected {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected \"\(expected)\", got \"\(actual)\"")
    }
}

// MARK: - Tests

func runTests() {
    let machine = VendingMachine()

    assertEqual(machine.display, "INSERT COIN", "empty machine display")

    // Insert a penny → rejected
    machine.insert(coin: .penny)
    let returned = machine.collectCoinReturn()
    assertEqual(returned.count, 1,       "penny returned")
    assertEqual(returned[0],   .penny,   "correct coin returned")

    // Insert valid coins
    machine.insert(coin: .quarter)
    assertEqual(machine.display, "$0.25", "quarter shown")
    machine.insert(coin: .quarter)
    machine.insert(coin: .quarter)
    machine.insert(coin: .quarter)
    assertEqual(machine.display, "$1.00", "four quarters shown")

    // Purchase cola ($1.00)
    machine.select(product: .cola)
    assertEqual(machine.display, "THANK YOU", "successful purchase")
    assertEqual(machine.display, "INSERT COIN", "resets after purchase")

    // Insufficient funds
    machine.insert(coin: .quarter)
    machine.select(product: .cola)
    assertEqual(machine.display, "PRICE $1.00", "price shown when insufficient")

    // Return coins
    machine.returnCoins()
    let change = machine.collectCoinReturn()
    assertEqual(change.count > 0, true, "coins returned")

    // Buy chips with exact change + verify
    machine.insert(coin: .quarter)
    machine.insert(coin: .quarter)
    machine.select(product: .chips)
    assertEqual(machine.display, "THANK YOU", "chips purchased")
}

runTests()
