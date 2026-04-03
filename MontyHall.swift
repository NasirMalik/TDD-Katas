// Monty Hall Kata
// https://sammancoaching.org/kata_descriptions/monty_hall.html
//
// Rules:
//   Simulate 1000 games with two strategies: always switch, always stay.
//   Show which strategy wins more often.
//   Switching should win ~2/3 of the time.

import Foundation

struct MontyHall {
    struct Results {
        let switchWins: Int
        let stayWins:   Int
        let total:      Int

        var switchRate: Double { Double(switchWins) / Double(total) }
        var stayRate:   Double { Double(stayWins)   / Double(total) }
    }

    func simulate(games: Int = 1000) -> Results {
        var switchWins = 0
        var stayWins   = 0

        for _ in 0..<games {
            let carDoor     = Int.random(in: 0..<3)
            let initialPick = Int.random(in: 0..<3)

            // Host reveals a goat door (not car, not picked)
            // If we stay we need our initial pick == car
            if initialPick == carDoor { stayWins   += 1 } // staying is only good if we picked correctly
            else                      { switchWins += 1 } // switching wins whenever we initially picked wrong
        }

        return Results(switchWins: switchWins, stayWins: stayWins, total: games)
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

func assertApprox(_ actual: Double, _ expected: Double, tolerance: Double, _ label: String = "") {
    if abs(actual - expected) <= tolerance {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected ≈\(expected) ±\(tolerance), got \(actual)")
    }
}

// MARK: - Tests

func runTests() {
    let game = MontyHall()
    let results = game.simulate(games: 10000)

    assertEqual(results.total, 10000, "correct game count")
    assertEqual(results.switchWins + results.stayWins, 10000, "all games accounted for")

    // Switching should win ~66.7%, staying ~33.3%
    // With 10000 games, allow 5% tolerance
    assertApprox(results.switchRate, 0.667, tolerance: 0.05, "switch wins ~2/3")
    assertApprox(results.stayRate,   0.333, tolerance: 0.05, "stay wins ~1/3")

    // Switching is better
    assertEqual(results.switchWins > results.stayWins, true, "switch strategy wins more")

    print("\nResults over \(results.total) games:")
    print("  Switch wins: \(results.switchWins) (\(String(format: "%.1f", results.switchRate * 100))%)")
    print("  Stay wins:   \(results.stayWins) (\(String(format: "%.1f", results.stayRate * 100))%)")
}

runTests()
