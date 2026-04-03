// Tennis Kata
// https://sammancoaching.org/kata_descriptions/tennis.html
//
// Rules:
//   Points map: 0→Love, 1→Fifteen, 2→Thirty, 3→Forty
//   When both players have ≥3 points and are equal → "Deuce"
//   When tied at Deuce +1 → "Advantage <player>"
//   First to ≥4 points and ≥2 ahead → wins (not in scope for scoring string)

struct TennisGame {
    private(set) var pointsA: Int = 0
    private(set) var pointsB: Int = 0

    mutating func scoreA() { pointsA += 1 }
    mutating func scoreB() { pointsB += 1 }

    func score() -> String {
        let names = ["Love", "Fifteen", "Thirty", "Forty"]

        // Deuce / Advantage territory
        if pointsA >= 3 && pointsB >= 3 {
            switch pointsA - pointsB {
            case 0:    return "Deuce"
            case 1:    return "Advantage Player A"
            case -1:   return "Advantage Player B"
            case let d where d >= 2:  return "Player A wins"
            default:   return "Player B wins"
            }
        }

        // Normal scoring
        if pointsA == pointsB {
            return "\(names[pointsA])-All"
        }
        return "\(names[pointsA])-\(names[pointsB])"
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
    var game = TennisGame()
    assertEqual(game.score(), "Love-All", "start of game")

    game.scoreA()
    assertEqual(game.score(), "Fifteen-Love", "A scores first")

    game.scoreB()
    assertEqual(game.score(), "Fifteen-All", "tied at Fifteen")

    game.scoreA()
    assertEqual(game.score(), "Thirty-Fifteen", "A leads")

    game.scoreA()
    assertEqual(game.score(), "Forty-Fifteen", "A at Forty")

    game.scoreB()
    game.scoreB()
    assertEqual(game.score(), "Deuce", "both at Deuce")

    game.scoreA()
    assertEqual(game.score(), "Advantage Player A", "A has advantage")

    game.scoreB()
    assertEqual(game.score(), "Deuce", "back to Deuce")

    game.scoreB()
    assertEqual(game.score(), "Advantage Player B", "B has advantage")

    game.scoreA()
    assertEqual(game.score(), "Deuce", "back to Deuce again")

    game.scoreA()
    game.scoreA()
    assertEqual(game.score(), "Player A wins", "A wins from advantage")
}

runTests()
