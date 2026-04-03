// Fractions Kata
// https://sammancoaching.org/kata_descriptions/fractions.html
//
// Rules:
//   Fraction is an immutable value object.
//   Support addition; result must be in lowest terms.
//   e.g. 1/2 + 3/4 = 5/4 (or 1 1/4 if you want mixed numbers)

struct Fraction: Equatable, CustomStringConvertible {
    let numerator:   Int
    let denominator: Int

    init(_ numerator: Int, _ denominator: Int) {
        precondition(denominator != 0, "Denominator cannot be zero")
        let sign = denominator < 0 ? -1 : 1
        let g    = Fraction.gcd(abs(numerator), abs(denominator))
        self.numerator   = sign * numerator   / g
        self.denominator = sign * denominator / g
    }

    static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(
            lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator,
            lhs.denominator * rhs.denominator
        )
    }

    var description: String {
        return denominator == 1 ? "\(numerator)" : "\(numerator)/\(denominator)"
    }

    private static func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
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
    // Creation and simplification
    assertEqual(Fraction(2, 4), Fraction(1, 2), "2/4 reduces to 1/2")
    assertEqual(Fraction(6, 10), Fraction(3, 5), "6/10 reduces to 3/5")
    assertEqual(Fraction(1, 1), Fraction(2, 2), "whole numbers equal")

    // Negative denominator normalised
    assertEqual(Fraction(1, -2), Fraction(-1, 2), "negative denominator normalised")

    // Addition
    assertEqual(Fraction(1, 2) + Fraction(1, 2), Fraction(1, 1), "1/2 + 1/2 = 1")
    assertEqual(Fraction(1, 2) + Fraction(3, 4), Fraction(5, 4), "1/2 + 3/4 = 5/4")
    assertEqual(Fraction(1, 3) + Fraction(1, 6), Fraction(1, 2), "1/3 + 1/6 = 1/2")
    assertEqual(Fraction(1, 4) + Fraction(3, 4), Fraction(1, 1), "1/4 + 3/4 = 1")

    // Description
    assertEqual(Fraction(3, 5).description,  "3/5", "string representation")
    assertEqual(Fraction(4, 2).description,  "2",   "whole number description")
}

runTests()
