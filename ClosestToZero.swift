// Closest to Zero Kata
// https://sammancoaching.org/kata_descriptions/closest_to_zero.html
//
// Part 1 Rules:
//   Given a list of integers, return the one closest to zero.
//   Tie (e.g. -5 and 5): return the positive value.
//   Empty list: return 0.

struct ClosestToZero {
    func execute(_ numbers: [Int]) -> Int {
        guard !numbers.isEmpty else { return 0 }
        return numbers.reduce(numbers[0]) { best, n in
            let absN    = abs(n)
            let absBest = abs(best)
            if absN < absBest { return n }
            if absN == absBest { return max(n, best) } // positive wins on tie
            return best
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
    let kata = ClosestToZero()

    assertEqual(kata.execute([]),          0,  "empty list → 0")
    assertEqual(kata.execute([0]),         0,  "zero itself")
    assertEqual(kata.execute([1]),         1,  "single positive")
    assertEqual(kata.execute([-1]),       -1,  "single negative")
    assertEqual(kata.execute([1, 2, 3]),   1,  "all positive, smallest is closest")
    assertEqual(kata.execute([-3, -2, -1]), -1, "all negative, largest magnitude is farthest")
    assertEqual(kata.execute([-5, 5]),     5,  "tie → positive wins")
    assertEqual(kata.execute([-1, 2, -3]), -1, "mixed: -1 is closest")
    assertEqual(kata.execute([10, -2, 3]), -2, "mixed: -2 is closest")
}

runTests()
