// Word Wrap Kata
// https://sammancoaching.org/kata_descriptions/word_wrap.html
//
// Rules:
//   Given a string and a column width, insert newlines so no line exceeds
//   the column width. Break at word boundaries (spaces) when possible.
//   If a single word is longer than the column, break it mid-word.

struct WordWrap {
    func execute(_ text: String, column: Int) -> String {
        guard column > 0 else { return text }
        var result = ""
        var remaining = text

        while remaining.count > column {
            let index = remaining.index(remaining.startIndex, offsetBy: column)
            let candidate = String(remaining[..<index])

            if let lastSpace = candidate.lastIndex(of: " ") {
                result += String(remaining[..<lastSpace]) + "\n"
                remaining = String(remaining[remaining.index(after: lastSpace)...])
            } else {
                result += candidate + "\n"
                remaining = String(remaining[index...])
            }
        }
        result += remaining
        return result
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
    let wrap = WordWrap()

    assertEqual(wrap.execute("", column: 5), "", "empty string")
    assertEqual(wrap.execute("hello", column: 5), "hello", "fits exactly")
    assertEqual(wrap.execute("hello world", column: 5), "hello\nworld", "wrap at space")
    assertEqual(wrap.execute("hello", column: 4), "hell\no", "forced mid-word break")
    assertEqual(wrap.execute("hello world", column: 11), "hello world", "just fits")
    assertEqual(wrap.execute("hello world", column: 10), "hello\nworld", "wrap before limit")
    assertEqual(
        wrap.execute("the quick brown fox", column: 10),
        "the quick\nbrown fox",
        "multi-word wrap"
    )
    assertEqual(
        wrap.execute("a b c d e f", column: 3),
        "a b\nc d\ne f",
        "short words"
    )
}

runTests()
