// FizzBuzz Kata
// https://sammancoaching.org/kata_descriptions/fizzbuzz.html
//
// Rules:
//   Multiples of 3 → "Fizz"
//   Multiples of 5 → "Buzz"
//   Multiples of both → "FizzBuzz"
//   Otherwise → the number as a string
//
// TDD Cycle: Add a new assertEqual in runTests(), watch it fail (Red),
// then update FizzBuzz.execute() (Green), then refactor (Refactor).

struct FizzBuzz {
    func execute(_ number: Int) -> String {
        switch (number % 3 == 0, number % 5 == 0) {
        case (true,  true):  return "FizzBuzz"
        case (true,  false): return "Fizz"
        case (false, true):  return "Buzz"
        case (false, false): return "\(number)"
        }
    }

    func executeRange(upTo limit: Int) -> [String] {
        return (1...limit).map { execute($0) }
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
    let fizzbuzz = FizzBuzz()

    assertEqual(fizzbuzz.execute(1),  "1",        "plain number")
    assertEqual(fizzbuzz.execute(3),  "Fizz",     "multiple of 3")
    assertEqual(fizzbuzz.execute(5),  "Buzz",     "multiple of 5")
    assertEqual(fizzbuzz.execute(15), "FizzBuzz", "multiple of both")
    assertEqual(fizzbuzz.execute(9),  "Fizz",     "another multiple of 3")
    assertEqual(fizzbuzz.execute(25), "Buzz",     "another multiple of 5")
    assertEqual(fizzbuzz.execute(30), "FizzBuzz", "another multiple of both")
    assertEqual(fizzbuzz.execute(7),  "7",        "plain number not divisible")

    let results = fizzbuzz.executeRange(upTo: 100)
    assertEqual(results.count,  100,        "range produces 100 elements")
    assertEqual(results[0],     "1",        "first element")
    assertEqual(results[14],    "FizzBuzz", "15th element")
    assertEqual(results[99],    "Buzz",     "100th element")
}

runTests()
