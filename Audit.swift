// Audit Kata
// https://sammancoaching.org/kata_descriptions/audit.html
//
// Rules:
//   Visitor log stored in flat text files.
//   Each file has a max number of entries.
//   When full, a new file with incremented index is created.
//   The system appends to the most recent file.
//
// Design: AuditManager is the domain logic; FileSystem is injected
// (protocol) so we can test without real I/O.

// MARK: - Port

protocol AuditFileSystem {
    func readFiles(inDirectory dir: String) -> [(name: String, lines: [String])]
    func writeFile(name: String, inDirectory dir: String, lines: [String])
}

// MARK: - Domain

struct AuditManager {
    private let maxEntriesPerFile: Int
    private let directory: String
    private let fileSystem: AuditFileSystem

    init(maxEntriesPerFile: Int, directory: String, fileSystem: AuditFileSystem) {
        self.maxEntriesPerFile = maxEntriesPerFile
        self.directory         = directory
        self.fileSystem        = fileSystem
    }

    func addRecord(visitorName: String, timeOfVisit: String) {
        let files = fileSystem
            .readFiles(inDirectory: directory)
            .sorted { fileIndex($0.name) < fileIndex($1.name) }

        let newEntry = "\(visitorName); \(timeOfVisit)"

        if files.isEmpty {
            fileSystem.writeFile(name: "audit_1.txt", inDirectory: directory, lines: [newEntry])
            return
        }

        let latest = files.last!
        if latest.lines.count < maxEntriesPerFile {
            fileSystem.writeFile(
                name: latest.name,
                inDirectory: directory,
                lines: latest.lines + [newEntry]
            )
        } else {
            let nextIndex = fileIndex(latest.name) + 1
            fileSystem.writeFile(
                name: "audit_\(nextIndex).txt",
                inDirectory: directory,
                lines: [newEntry]
            )
        }
    }

    private func fileIndex(_ name: String) -> Int {
        let base = name
            .components(separatedBy: "_").last?
            .components(separatedBy: ".").first ?? "0"
        return Int(base) ?? 0
    }
}

// MARK: - In-Memory Stub

class InMemoryAuditFileSystem: AuditFileSystem {
    private(set) var storage: [String: [String]] = [:]

    func readFiles(inDirectory dir: String) -> [(name: String, lines: [String])] {
        storage.map { (name: $0.key, lines: $0.value) }
    }

    func writeFile(name: String, inDirectory dir: String, lines: [String]) {
        storage[name] = lines
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
    let fs      = InMemoryAuditFileSystem()
    let manager = AuditManager(maxEntriesPerFile: 3, directory: "/audit", fileSystem: fs)

    // First entry creates audit_1.txt
    manager.addRecord(visitorName: "Alice", timeOfVisit: "09:00")
    assertEqual(fs.storage["audit_1.txt"]?.count, 1, "first entry creates file")
    assertEqual(fs.storage["audit_1.txt"]?.first?.contains("Alice"), true, "entry contains name")

    // Second and third entries go to same file
    manager.addRecord(visitorName: "Bob",   timeOfVisit: "09:30")
    manager.addRecord(visitorName: "Carol", timeOfVisit: "10:00")
    assertEqual(fs.storage["audit_1.txt"]?.count, 3, "three entries in first file")

    // Fourth entry triggers new file
    manager.addRecord(visitorName: "Dave", timeOfVisit: "10:30")
    assertEqual(fs.storage["audit_2.txt"]?.count, 1, "new file created when first is full")
    assertEqual(fs.storage["audit_2.txt"]?.first?.contains("Dave"), true, "entry in new file")
    assertEqual(fs.storage.count, 2, "two files exist")
}

runTests()
