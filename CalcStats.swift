// Calculate Stats Kata
// https://sammancoaching.org/kata_descriptions/calc_stats.html
//
// Rules:
//   Given a sequence of integers, return min, max, count, and average.
//   Throw (or return an error) when the sequence is empty.

enum StatsError: Error, Equatable {
    case emptySequence
}

struct Stats {
    let minimum: Int
    let maximum: Int
    let count: Int
    let average: Double
}

struct CalcStats {
    func execute(_ numbers: [Int]) throws -> Stats {
        guard !numbers.isEmpty else { throw StatsError.emptySequence }
        return Stats(
            minimum: numbers.min()!,
            maximum: numbers.max()!,
            count:   numbers.count,
            average: Double(numbers.reduce(0, +)) / Double(numbers.count)
        )
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

func assertThrows<E: Error & Equatable>(_ block: () throws -> Any, expectedError: E, _ label: String = "") {
    do {
        _ = try block()
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected error but none was thrown")
    } catch let error as E {
        if error == expectedError {
            print("PASS\(label.isEmpty ? "" : " [\(label)]")")
        } else {
            print("FAIL\(label.isEmpty ? "" : " [\(label)]") — wrong error: \(error)")
        }
    } catch {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — unexpected error type: \(error)")
    }
}

// MARK: - Tests

func runTests() {
    let calc = CalcStats()

    // Empty sequence throws
    assertThrows({ try calc.execute([]) }, expectedError: StatsError.emptySequence, "empty throws")

    // Single element
    let single = try! calc.execute([42])
    assertEqual(single.minimum, 42,   "single: min")
    assertEqual(single.maximum, 42,   "single: max")
    assertEqual(single.count,   1,    "single: count")
    assertEqual(single.average, 42.0, "single: average")

    // Mixed positive and negative
    let stats = try! calc.execute([6, 9, 15, -2, 92, 11])
    assertEqual(stats.minimum, -2,                              "minimum")
    assertEqual(stats.maximum, 92,                              "maximum")
    assertEqual(stats.count,   6,                               "count")
    assertEqual(abs(stats.average - 21.833) < 0.001, true,     "average ≈ 21.83")
}

runTests()
