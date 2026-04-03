// Recently Used List Kata
// https://sammancoaching.org/kata_descriptions/recently_used_list.html
//
// Rules:
//   - Initially empty.
//   - Most recently added item is first (index 0).
//   - Items are unique; adding a duplicate moves it to the front.
//   - Optional: reject empty strings; configurable capacity.

struct RecentlyUsedList {
    private var items: [String] = []
    private let capacity: Int?

    init(capacity: Int? = nil) {
        self.capacity = capacity
    }

    var count: Int { items.count }
    var isEmpty: Bool { items.isEmpty }

    subscript(index: Int) -> String { items[index] }

    mutating func add(_ item: String) {
        guard !item.isEmpty else { return }
        // Remove duplicate if present
        items.removeAll { $0 == item }
        // Prepend
        items.insert(item, at: 0)
        // Trim to capacity
        if let cap = capacity, items.count > cap {
            items = Array(items.prefix(cap))
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
    var list = RecentlyUsedList()

    assertEqual(list.isEmpty, true, "starts empty")
    assertEqual(list.count,   0,    "initial count is 0")

    list.add("apple")
    assertEqual(list.count,   1,       "one item added")
    assertEqual(list[0],      "apple", "first item is apple")

    list.add("banana")
    assertEqual(list[0], "banana", "most recent is first")
    assertEqual(list[1], "apple",  "older item is second")

    // Duplicate moves to front
    list.add("apple")
    assertEqual(list.count, 2,        "no duplicate stored")
    assertEqual(list[0],    "apple",  "re-added item is now first")
    assertEqual(list[1],    "banana", "other item shifted")

    // Empty strings rejected
    list.add("")
    assertEqual(list.count, 2, "empty string not added")

    // Capacity
    var bounded = RecentlyUsedList(capacity: 2)
    bounded.add("a")
    bounded.add("b")
    bounded.add("c")
    assertEqual(bounded.count, 2, "capacity enforced")
    assertEqual(bounded[0],    "c", "newest is first")
    assertEqual(bounded[1],    "b", "second newest")
}

runTests()
