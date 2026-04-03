// Diamond Kata
// https://sammancoaching.org/kata_descriptions/diamond.html
//
// Rules:
//   Input: a letter (e.g. 'C')
//   Output: ASCII diamond starting with 'A' at top, widening to the
//           input letter at the middle, then mirroring back to 'A'.
//
// Example for 'C':
//   "  A  "
//   " B B "
//   "C   C"
//   " B B "
//   "  A  "

struct Diamond {
    func execute(_ letter: Character) -> String {
        let letters = (0...Int(letter.asciiValue! - Character("A").asciiValue!))
            .map { Character(UnicodeScalar(Character("A").asciiValue! + UInt8($0))!) }
        let width = letters.count * 2 - 1

        var rows: [String] = []
        for (i, ch) in letters.enumerated() {
            let outerSpaces = String(repeating: " ", count: letters.count - 1 - i)
            let innerSpaces = i == 0 ? "" : String(repeating: " ", count: i * 2 - 1)
            let row = i == 0
                ? "\(outerSpaces)\(ch)\(outerSpaces)"
                : "\(outerSpaces)\(ch)\(innerSpaces)\(ch)\(outerSpaces)"
            rows.append(row)
        }

        let allRows = rows + rows.dropLast().reversed()
        return allRows.joined(separator: "\n")
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

// MARK: - Tests

func runTests() {
    let diamond = Diamond()

    assertEqual(diamond.execute("A"), "A", "single letter A")

    assertEqual(
        diamond.execute("B"),
        " A \nB B\n A ",
        "letter B"
    )

    assertEqual(
        diamond.execute("C"),
        "  A  \n B B \nC   C\n B B \n  A  ",
        "letter C"
    )

    // Property: first and last row is 'A' (trim spaces)
    let d = diamond.execute("D")
    let rows = d.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    assertEqual(rows.first?.trimmingCharacters(in: .whitespaces), "A", "first row is A")
    assertEqual(rows.last?.trimmingCharacters(in: .whitespaces),  "A", "last row is A")

    // Property: all rows have the same width
    let widths = Set(rows.map { $0.count })
    assertEqual(widths.count, 1, "all rows same width")

    // Property: symmetric (top mirrors bottom)
    assertEqual(rows.first, rows.last, "top == bottom row")
}

runTests()
