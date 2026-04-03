// Bank Account Kata
// https://sammancoaching.org/kata_descriptions/bank_account.html
//
// Rules:
//   - deposit(amount): add funds
//   - withdraw(amount): remove funds
//   - printStatement(): returns a formatted string with date | amount | balance
//   - Transactions ordered by date; withdrawals shown as negative

import Foundation

struct Transaction {
    let date: String
    let amount: Int
    let balance: Int
}

class BankAccount {
    private var balance: Int = 0
    private var transactions: [Transaction] = []

    private var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: Date())
    }

    func deposit(_ amount: Int) {
        balance += amount
        transactions.append(Transaction(date: today, amount: amount, balance: balance))
    }

    func withdraw(_ amount: Int) {
        balance -= amount
        transactions.append(Transaction(date: today, amount: -amount, balance: balance))
    }

    func printStatement() -> String {
        var lines = ["Date       | Amount | Balance"]
        for t in transactions {
            let amountStr = t.amount >= 0 ? " \(t.amount)" : "\(t.amount)"
            lines.append("\(t.date) | \(amountStr.padding(toLength: 6, withPad: " ", startingAt: 0)) | \(t.balance)")
        }
        return lines.joined(separator: "\n")
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

func assertContains(_ actual: String, _ substring: String, _ label: String = "") {
    if actual.contains(substring) {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — \"\(substring)\" not found in output")
    }
}

// MARK: - Tests

func runTests() {
    let account = BankAccount()

    // New account has zero balance, empty statement
    let emptyStatement = account.printStatement()
    assertContains(emptyStatement, "Date", "statement has header")

    account.deposit(1000)
    assertEqual(account.printStatement().contains("1000"), true, "deposit shown")

    account.withdraw(200)
    let statement = account.printStatement()
    assertContains(statement, "-200",  "withdrawal is negative")
    assertContains(statement, "800",   "balance after withdrawal")

    account.deposit(500)
    let statement2 = account.printStatement()
    assertContains(statement2, "1300", "balance after second deposit")

    // Running balance: lines should be in order deposited
    let lines = statement2.split(separator: "\n").dropFirst()
    assertEqual(lines.count, 3, "three transactions recorded")
}

runTests()
