// Leap Years Kata
// https://sammancoaching.org/kata_descriptions/leap_years.html
//
// Rules:
//   A year is a leap year if:
//     - Divisible by 4
//     - BUT NOT divisible by 100
//     - UNLESS also divisible by 400

struct LeapYears {
    func execute(_ year: Int) -> Bool {
        switch (year % 400 == 0, year % 100 == 0, year % 4 == 0) {
        case (true,  _,    _):    return true   // divisible by 400 → leap
        case (false, true, _):    return false  // divisible by 100 but not 400 → not leap
        case (false, false, true): return true  // divisible by 4 but not 100 → leap
        default:                   return false
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
    let leapYears = LeapYears()

    assertEqual(leapYears.execute(1996), true,  "1996 — divisible by 4")
    assertEqual(leapYears.execute(2000), true,  "2000 — divisible by 400")
    assertEqual(leapYears.execute(2024), true,  "2024 — divisible by 4")
    assertEqual(leapYears.execute(2001), false, "2001 — not divisible by 4")
    assertEqual(leapYears.execute(1900), false, "1900 — divisible by 100 but not 400")
    assertEqual(leapYears.execute(1800), false, "1800 — divisible by 100 but not 400")
    assertEqual(leapYears.execute(1600), true,  "1600 — divisible by 400")
}

runTests()
