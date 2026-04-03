// Log Parser Kata
// https://sammancoaching.org/kata_descriptions/log_parser.html
//
// This kata is a TESTING kata: add tests for an existing log parser.
// The log parser reads lines like:
//   "2026-04-03 14:23:01 INFO  App started"
// and exposes fields: date, time, level, message.
//
// Your task: write tests that characterize the existing behaviour.
// Below is a clean implementation of the parser with a comprehensive test suite.

import Foundation

// MARK: - Domain

struct LogEntry {
    let date:    String
    let time:    String
    let level:   String
    let message: String
}

enum LogLevel: String {
    case info    = "INFO"
    case warn    = "WARN"
    case error   = "ERROR"
    case debug   = "DEBUG"
    case unknown = "UNKNOWN"
}

// MARK: - Parser

struct LogParser {
    func parse(line: String) -> LogEntry? {
        let parts = line.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
        guard parts.count == 4 else { return nil }
        return LogEntry(
            date:    String(parts[0]),
            time:    String(parts[1]),
            level:   String(parts[2]),
            message: String(parts[3])
        )
    }

    func parse(log: String) -> [LogEntry] {
        log.split(separator: "\n", omittingEmptySubsequences: true)
           .compactMap { parse(line: String($0)) }
    }

    func filter(entries: [LogEntry], level: LogLevel) -> [LogEntry] {
        entries.filter { $0.level == level.rawValue }
    }

    func errorCount(in log: String) -> Int {
        filter(entries: parse(log: log), level: .error).count
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
    let parser = LogParser()

    // Parse a valid line
    let entry = parser.parse(line: "2026-04-03 14:23:01 INFO  App started")
    assertEqual(entry?.date,    "2026-04-03", "date parsed")
    assertEqual(entry?.time,    "14:23:01",   "time parsed")
    assertEqual(entry?.level,   "INFO",       "level parsed")
    assertEqual(entry?.message, "App started","message parsed")

    // Malformed line returns nil
    let bad = parser.parse(line: "not a log line")
    assertEqual(bad == nil, true, "malformed line returns nil")

    // Multi-line log
    let log = """
    2026-04-03 09:00:00 INFO  Server booting
    2026-04-03 09:00:01 DEBUG Config loaded
    2026-04-03 09:00:02 ERROR Database unreachable
    2026-04-03 09:00:03 WARN  Retrying connection
    2026-04-03 09:00:04 ERROR Connection failed
    """

    let entries = parser.parse(log: log)
    assertEqual(entries.count, 5, "five entries parsed")

    // Filter by level
    let errors = parser.filter(entries: entries, level: .error)
    assertEqual(errors.count, 2, "two ERROR entries")

    let infos = parser.filter(entries: entries, level: .info)
    assertEqual(infos.count, 1, "one INFO entry")

    // Error count
    assertEqual(parser.errorCount(in: log), 2, "error count matches")

    // Messages are preserved
    assertEqual(errors[0].message, "Database unreachable", "first error message")
    assertEqual(errors[1].message, "Connection failed",     "second error message")
}

runTests()
