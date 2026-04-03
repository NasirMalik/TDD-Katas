// Yatzy Kata
// https://sammancoaching.org/kata_descriptions/yatzy.html
//
// Rules:
//   Score a given roll of 5 dice in a given category.
//   Return the score, or 0 if the roll doesn't qualify.

enum YatzyCategory {
    case ones, twos, threes, fours, fives, sixes
    case chance
    case pair, twoPairs, threeOfAKind, fourOfAKind
    case smallStraight, largeStraight
    case fullHouse
    case yatzy
}

struct Yatzy {
    func score(_ dice: [Int], category: YatzyCategory) -> Int {
        let counts = (1...6).map { n in dice.filter { $0 == n }.count }

        switch category {
        case .ones:   return counts[0] * 1
        case .twos:   return counts[1] * 2
        case .threes: return counts[2] * 3
        case .fours:  return counts[3] * 4
        case .fives:  return counts[4] * 5
        case .sixes:  return counts[5] * 6

        case .chance: return dice.reduce(0, +)

        case .pair:
            return counts.reversed().enumerated()
                .first(where: { $0.element >= 2 })
                .map { (6 - $0.offset) * 2 } ?? 0

        case .twoPairs:
            let pairs = counts.enumerated().filter { $0.element >= 2 }.map { ($0.offset + 1) }
            guard pairs.count >= 2 else { return 0 }
            return pairs.suffix(2).reduce(0, +) * 2

        case .threeOfAKind:
            return counts.enumerated()
                .first(where: { $0.element >= 3 })
                .map { ($0.offset + 1) * 3 } ?? 0

        case .fourOfAKind:
            return counts.enumerated()
                .first(where: { $0.element >= 4 })
                .map { ($0.offset + 1) * 4 } ?? 0

        case .smallStraight:
            return counts[0...4].allSatisfy({ $0 >= 1 }) ? 15 : 0

        case .largeStraight:
            return counts[1...5].allSatisfy({ $0 >= 1 }) ? 20 : 0

        case .fullHouse:
            let threeIdx = counts.firstIndex(where: { $0 == 3 })
            let twoIdx   = counts.firstIndex(where: { $0 == 2 })
            guard let t3 = threeIdx, let t2 = twoIdx, t3 != t2 else { return 0 }
            return (t3 + 1) * 3 + (t2 + 1) * 2

        case .yatzy:
            return counts.contains(5) ? 50 : 0
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
    let y = Yatzy()

    // Number categories
    assertEqual(y.score([1,1,2,3,4], category: .ones),   2,  "ones")
    assertEqual(y.score([2,2,3,4,5], category: .twos),   4,  "twos")
    assertEqual(y.score([3,3,3,1,2], category: .threes), 9,  "threes")

    // Chance
    assertEqual(y.score([1,2,3,4,5], category: .chance), 15, "chance")

    // Pair: highest pair
    assertEqual(y.score([3,3,4,4,5], category: .pair), 8, "highest pair (4s)")

    // Two pairs
    assertEqual(y.score([1,1,2,2,3], category: .twoPairs), 6, "two pairs")
    assertEqual(y.score([1,2,3,4,5], category: .twoPairs), 0, "no two pairs")

    // Three of a kind
    assertEqual(y.score([3,3,3,1,2], category: .threeOfAKind), 9, "three of a kind")

    // Four of a kind
    assertEqual(y.score([4,4,4,4,2], category: .fourOfAKind), 16, "four of a kind")

    // Straights
    assertEqual(y.score([1,2,3,4,5], category: .smallStraight), 15, "small straight")
    assertEqual(y.score([2,3,4,5,6], category: .largeStraight),  20, "large straight")
    assertEqual(y.score([1,2,3,4,6], category: .smallStraight),   0, "not small straight")

    // Full house
    assertEqual(y.score([2,2,3,3,3], category: .fullHouse), 13, "full house")
    assertEqual(y.score([1,1,1,1,1], category: .fullHouse),  0, "yatzy is not full house")

    // Yatzy
    assertEqual(y.score([6,6,6,6,6], category: .yatzy), 50, "yatzy")
    assertEqual(y.score([1,2,3,4,5], category: .yatzy),  0, "not yatzy")
}

runTests()
