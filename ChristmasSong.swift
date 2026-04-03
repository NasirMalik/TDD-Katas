// Twelve Days of Christmas Kata
// https://sammancoaching.org/kata_descriptions/christmas_song.html
//
// Rules:
//   Generate all 12 verses of the song programmatically.
//   No hardcoded full lyrics.
//   Each verse is cumulative: day N lists gifts 1..N in reverse order.

struct ChristmasSong {
    private let ordinals = [
        "first", "second", "third", "fourth", "fifth", "sixth",
        "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"
    ]
    private let gifts = [
        "A partridge in a pear tree",
        "Two turtle doves",
        "Three French hens",
        "Four calling birds",
        "Five gold rings",
        "Six geese a-laying",
        "Seven swans a-swimming",
        "Eight maids a-milking",
        "Nine ladies dancing",
        "Ten lords a-leaping",
        "Eleven pipers piping",
        "Twelve drummers drumming"
    ]

    func execute() -> String {
        (0..<12).map { verse(day: $0) }.joined(separator: "\n\n")
    }

    private func verse(day: Int) -> String {
        let giftList = (0...day).reversed().map { gifts[$0] }.joined(separator: ",\n")
        return "On the \(ordinals[day]) day of Christmas my true love gave to me:\n\(giftList)."
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
    let song = ChristmasSong()
    let lyrics = song.execute()

    let verses = lyrics.components(separatedBy: "\n\n").filter { !$0.isEmpty }
    assertEqual(verses.count, 12, "12 verses total")

    // Day 1: only partridge
    assertContains(verses[0], "first day",                     "day 1 ordinal")
    assertContains(verses[0], "A partridge in a pear tree",    "day 1 gift")

    // Day 2: turtle doves AND partridge (cumulative)
    assertContains(verses[1], "second day",                    "day 2 ordinal")
    assertContains(verses[1], "Two turtle doves",              "day 2 new gift")
    assertContains(verses[1], "A partridge in a pear tree",    "day 2 cumulative")

    // Day 12: all gifts
    assertContains(verses[11], "twelfth day",                  "day 12 ordinal")
    assertContains(verses[11], "Twelve drummers drumming",     "day 12 new gift")
    assertContains(verses[11], "A partridge in a pear tree",   "day 12 cumulative")
}

runTests()
