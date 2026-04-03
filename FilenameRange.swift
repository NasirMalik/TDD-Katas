// Filename Range Kata
// https://sammancoaching.org/kata_descriptions/filename_range.html
//
// Rules:
//   Return (start, end) indexes of the "base name" portion of a filename,
//   excluding: directory prefix, file extension, and test-related keywords
//   (test, tests, spec, step) plus their separators (. _ -).

struct FilenameRange {
    func execute(_ path: String) -> (start: Int, end: Int) {
        // Strip directory prefix
        var name = path
        if let slash = name.lastIndex(of: "/") {
            name = String(name[name.index(after: slash)...])
        }

        // Strip file extension
        if let dot = name.lastIndex(of: ".") {
            name = String(name[..<dot])
        }

        // Strip test-related suffixes/prefixes (case-insensitive)
        let testKeywords = ["tests", "test", "spec", "step"]
        let separators   = CharacterSet(charactersIn: "._-")

        for keyword in testKeywords {
            // Suffix: name ends with separator + keyword
            let lower = name.lowercased()
            if lower.hasSuffix(keyword) {
                let stripped = name.dropLast(keyword.count)
                if let last = stripped.last, separators.contains(last.unicodeScalars.first!) {
                    name = String(stripped.dropLast())
                    break
                }
            }
            // Prefix: name starts with keyword + separator
            if lower.hasPrefix(keyword) {
                let stripped = name.dropFirst(keyword.count)
                if let first = stripped.first, separators.contains(first.unicodeScalars.first!) {
                    name = String(stripped.dropFirst())
                    break
                }
            }
        }

        // Find the range of `name` in the original path
        // Re-derive offset from directory prefix removal
        var offset = 0
        if let slash = path.lastIndex(of: "/") {
            offset = path.distance(from: path.startIndex, to: path.index(after: slash))
        }

        // After stripping extension from original, find `name` starting at offset
        let start = offset
        let end   = start + name.count - 1
        return (start, end)
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

// Helper to extract the selected substring
func selectedName(path: String, range: (start: Int, end: Int)) -> String {
    let chars = Array(path)
    guard range.start <= range.end, range.end < chars.count else { return "" }
    return String(chars[range.start...range.end])
}

// MARK: - Tests

func runTests() {
    let kata = FilenameRange()

    var r = kata.execute("hiker.cpp")
    assertEqual(selectedName(path: "hiker.cpp", range: r), "hiker", "strips extension")

    r = kata.execute("HikerTest.js")
    assertEqual(selectedName(path: "HikerTest.js", range: r), "Hiker", "strips Test suffix")

    r = kata.execute("FizzBuzz_test.exs")
    assertEqual(selectedName(path: "FizzBuzz_test.exs", range: r), "FizzBuzz", "strips _test suffix")

    r = kata.execute("test/FizzBuzz_test.exs")
    assertEqual(selectedName(path: "test/FizzBuzz_test.exs", range: r), "FizzBuzz", "strips directory and _test")

    r = kata.execute("HikerSpec.rb")
    assertEqual(selectedName(path: "HikerSpec.rb", range: r), "Hiker", "strips Spec suffix")

    r = kata.execute("step_definitions/calculator.rb")
    assertEqual(selectedName(path: "step_definitions/calculator.rb", range: r), "calculator", "strips directory only")
}

runTests()
