// Phonebook Kata
// https://sammancoaching.org/kata_descriptions/phonebook.html
//
// Rules:
//   - Support name → number lookup.
//   - No number may be a prefix of another number already stored.
//   - Skip (and record) conflicting entries.

struct PhonebookEntry {
    let name:   String
    let number: String
}

class Phonebook {
    private var entries:  [String: String] = [:]  // name → number
    private(set) var skipped: [PhonebookEntry] = []

    @discardableResult
    func add(name: String, number: String) -> Bool {
        // Check prefix conflict
        for existing in entries.values {
            if existing.hasPrefix(number) || number.hasPrefix(existing) {
                skipped.append(PhonebookEntry(name: name, number: number))
                return false
            }
        }
        entries[name] = number
        return true
    }

    func lookup(name: String) -> String? { entries[name] }

    var count: Int { entries.count }
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
    let book = Phonebook()

    // Basic add and lookup
    assertEqual(book.add(name: "Alice", number: "1234"), true, "add Alice")
    assertEqual(book.lookup(name: "Alice"), "1234", "lookup Alice")
    assertEqual(book.lookup(name: "Bob"),   nil,    "unknown name")

    // Prefix conflict: "12" is a prefix of "1234"
    assertEqual(book.add(name: "Charlie", number: "12"), false, "prefix conflict rejected")
    assertEqual(book.skipped.count,  1,         "skipped entry recorded")
    assertEqual(book.skipped[0].name, "Charlie", "skipped entry name")

    // Non-conflicting number added fine
    assertEqual(book.add(name: "Bob", number: "5678"), true, "non-conflicting number added")
    assertEqual(book.count, 2, "two valid entries")

    // Exact match of existing number is also a prefix conflict
    assertEqual(book.add(name: "Dave", number: "1234"), false, "exact duplicate number rejected")
}

runTests()
