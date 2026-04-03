// String Calculator Kata
// https://sammancoaching.org/kata_descriptions/string_calculator.html
//
// Incremental TDD steps:
//   1. Parse a single integer (including negatives)
//   2. Add two numbers separated by "+"
//   3. Support subtraction with "-"
//   4. Ignore whitespace
//   5. Support multiplication "*" and parentheses (extend at your own pace)
//
// Note: No use of eval().

struct StringCalculator {
    func execute(_ expression: String) -> Double {
        let trimmed = expression.trimmingCharacters(in: .whitespaces)
        return parse(trimmed[trimmed.startIndex...])
    }

    // Recursive-descent: handles +/- at the top level, then */
    private func parse(_ input: Substring) -> Double {
        var tokens = tokenize(String(input))
        return parseExpression(&tokens)
    }

    private func parseExpression(_ tokens: inout [String]) -> Double {
        var result = parseTerm(&tokens)
        while let op = tokens.first, op == "+" || op == "-" {
            tokens.removeFirst()
            let rhs = parseTerm(&tokens)
            result = op == "+" ? result + rhs : result - rhs
        }
        return result
    }

    private func parseTerm(_ tokens: inout [String]) -> Double {
        var result = parseFactor(&tokens)
        while let op = tokens.first, op == "*" || op == "/" {
            tokens.removeFirst()
            let rhs = parseFactor(&tokens)
            result = op == "*" ? result * rhs : result / rhs
        }
        return result
    }

    private func parseFactor(_ tokens: inout [String]) -> Double {
        guard !tokens.isEmpty else { return 0 }
        if tokens.first == "(" {
            tokens.removeFirst() // consume "("
            let result = parseExpression(&tokens)
            if tokens.first == ")" { tokens.removeFirst() }
            return result
        }
        let token = tokens.removeFirst()
        return Double(token) ?? 0
    }

    private func tokenize(_ expression: String) -> [String] {
        var tokens: [String] = []
        var current = ""
        for char in expression {
            if char.isWhitespace { continue }
            if char == "+" || char == "*" || char == "/" || char == "(" || char == ")" {
                if !current.isEmpty { tokens.append(current); current = "" }
                tokens.append(String(char))
            } else if char == "-" {
                // unary minus or binary minus
                if current.isEmpty && (tokens.isEmpty || tokens.last == "(" || tokens.last == "+" || tokens.last == "-" || tokens.last == "*" || tokens.last == "/") {
                    current += String(char)
                } else {
                    if !current.isEmpty { tokens.append(current); current = "" }
                    tokens.append(String(char))
                }
            } else {
                current += String(char)
            }
        }
        if !current.isEmpty { tokens.append(current) }
        return tokens
    }
}

// MARK: - Test Helpers

func assertEqual(_ actual: Double, _ expected: Double, _ label: String = "", tolerance: Double = 1e-9) {
    if abs(actual - expected) <= tolerance {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected \(expected), got \(actual)")
    }
}

// MARK: - Tests

func runTests() {
    let calc = StringCalculator()

    assertEqual(calc.execute("42"),        42,   "single integer")
    assertEqual(calc.execute("-7"),        -7,   "negative integer")
    assertEqual(calc.execute("1 + 2"),     3,    "addition")
    assertEqual(calc.execute("10 - 4"),    6,    "subtraction")
    assertEqual(calc.execute("3 * 4"),     12,   "multiplication")
    assertEqual(calc.execute("10 / 2"),    5,    "division")
    assertEqual(calc.execute("2 + 3 * 4"), 14,   "precedence: multiply before add")
    assertEqual(calc.execute("(2 + 3) * 4"), 20, "parentheses override precedence")
    assertEqual(calc.execute(" 5 + 5 "),  10,    "whitespace ignored")
    assertEqual(calc.execute("1 + 2 + 3 + 4"), 10, "multiple additions")
}

runTests()
