// Theatrical Players Kata
// https://sammancoaching.org/kata_descriptions/theatrical_players.html
//
// This is a REFACTORING kata from Martin Fowler's "Refactoring" 2nd edition.
// The starting code calculates billing statements for theatrical performances.
//
// Refactoring goals:
//   - Rename for clarity
//   - Extract methods / phases
//   - Replace conditionals with polymorphism

// MARK: - Domain

enum PlayType { case tragedy, comedy }

struct Play {
    let name:  String
    let type:  PlayType
}

struct Performance {
    let playID:   String
    let audience: Int
}

struct Invoice {
    let customer:     String
    let performances: [Performance]
}

// MARK: - Refactored Statement Generator

struct TheatricalPlayers {
    private let plays: [String: Play]

    init(plays: [String: Play]) {
        self.plays = plays
    }

    func statement(for invoice: Invoice) -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"

        for perf in invoice.performances {
            let play   = plays[perf.playID]!
            let amount = calculateAmount(for: perf, play: play)
            volumeCredits += calculateCredits(for: perf, play: play)
            result += "  \(play.name): \(formatCents(amount)) (\(perf.audience) seats)\n"
            totalAmount += amount
        }

        result += "Amount owed is \(formatCents(totalAmount))\n"
        result += "You earned \(volumeCredits) credits\n"
        return result
    }

    private func calculateAmount(for perf: Performance, play: Play) -> Int {
        switch play.type {
        case .tragedy:
            var amount = 40_000
            if perf.audience > 30 { amount += 1_000 * (perf.audience - 30) }
            return amount

        case .comedy:
            var amount = 30_000
            if perf.audience > 20 { amount += 10_000 + 500 * (perf.audience - 20) }
            amount += 300 * perf.audience
            return amount
        }
    }

    private func calculateCredits(for perf: Performance, play: Play) -> Int {
        var credits = max(perf.audience - 30, 0)
        if play.type == .comedy { credits += perf.audience / 5 }
        return credits
    }

    private func formatCents(_ cents: Int) -> String {
        String(format: "$%.2f", Double(cents) / 100)
    }
}

// MARK: - Test Helpers

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ label: String = "") {
    if actual == expected {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected:\n\"\(expected)\"\ngot:\n\"\(actual)\"")
    }
}

func assertContains(_ actual: String, _ substring: String, _ label: String = "") {
    if actual.contains(substring) {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — \"\(substring)\" not found")
    }
}

// MARK: - Tests

func runTests() {
    let plays: [String: Play] = [
        "hamlet":  Play(name: "Hamlet",           type: .tragedy),
        "aslike":  Play(name: "As You Like It",   type: .comedy),
        "othello": Play(name: "Othello",           type: .tragedy)
    ]

    let invoice = Invoice(
        customer: "BigCo",
        performances: [
            Performance(playID: "hamlet",  audience: 55),
            Performance(playID: "aslike",  audience: 35),
            Performance(playID: "othello", audience: 40)
        ]
    )

    let printer = TheatricalPlayers(plays: plays)
    let output  = printer.statement(for: invoice)

    assertContains(output, "Statement for BigCo", "customer name in output")
    assertContains(output, "Hamlet",              "Hamlet in output")
    assertContains(output, "As You Like It",      "comedy in output")
    assertContains(output, "Othello",             "Othello in output")
    assertContains(output, "Amount owed",         "total shown")
    assertContains(output, "credits",             "credits shown")

    // Hamlet: tragedy, 55 seats → 40000 + (55-30)*1000 = 65000 cents = $650.00
    assertContains(output, "$650.00", "Hamlet amount correct")

    // As You Like It: comedy, 35 seats → 30000+10000+500*(35-20)+300*35 = 58500 cents = $547.50
    assertContains(output, "$547.50", "As You Like It amount correct")
}

runTests()
