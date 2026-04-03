// Ten Green Bottles Kata
// https://sammancoaching.org/kata_descriptions/ten_green_bottles.html
//
// Rules:
//   Generate the full lyrics of the counting-down song programmatically.
//   No hardcoded full lyrics; program must be "small".
//   Each verse decrements the bottle count from 10 down to 0.

struct TenGreenBottles {
    func execute() -> String {
        (1...10).reversed().map { verse(bottles: $0) }.joined(separator: "\n")
    }

    private func verse(bottles: Int) -> String {
        let plural   = bottles == 1 ? "bottle" : "bottles"
        let nextCount = bottles - 1
        let nextWord  = nextCount == 0 ? "no" : "\(nextCount)"
        let nextPlural = nextCount == 1 ? "bottle" : "bottles"

        return """
        \(bottles) green \(plural) hanging on the wall,
        \(bottles) green \(plural) hanging on the wall,
        And if one green bottle should accidentally fall,
        There'll be \(nextWord) green \(nextPlural) hanging on the wall.
        """
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

func assertContains(_ actual: String, _ substring: String, _ label: String = "") {
    if actual.contains(substring) {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — \"\(substring)\" not found")
    }
}

// MARK: - Tests

func runTests() {
    let song = TenGreenBottles()
    let lyrics = song.execute()

    assertContains(lyrics, "10 green bottles", "starts with 10")
    assertContains(lyrics, "1 green bottle",   "singular 'bottle' for 1")
    assertContains(lyrics, "no green bottles", "ends with 'no green bottles'")

    let verses = lyrics.components(separatedBy: "\n\n").filter { !$0.isEmpty }
    assertEqual(verses.count, 10, "10 verses total")

    // First verse check
    assertContains(verses[0], "10 green bottles", "first verse starts at 10")
    assertContains(verses[0], "9 green bottles",  "first verse references 9")

    // Last verse (index 9, i.e. 1 bottle)
    assertContains(verses.last ?? "", "1 green bottle", "last verse has 1 bottle")
    assertContains(verses.last ?? "", "no green bottles", "last verse ends at 0")
}

runTests()
