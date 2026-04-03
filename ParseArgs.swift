// Parse Command-Line Args Kata
// https://sammancoaching.org/kata_descriptions/parse_args.html
//
// Rules:
//   Parse "--flag value" pairs into a typed data structure.
//   Schema defines expected argument names and types (string, int, bool).
//   Return errors for unexpected flags or wrong types.

enum ArgType { case string, int, bool }
enum ArgValue: Equatable {
    case string(String)
    case int(Int)
    case bool(Bool)
}

enum ParseError: Error, Equatable {
    case unknownFlag(String)
    case typeMismatch(flag: String, expected: ArgType)
    case missingValue(String)
}

struct ArgSchema {
    let flag: String
    let type: ArgType
}

struct ParseArgs {
    private let schema: [ArgSchema]

    init(schema: [ArgSchema]) {
        self.schema = schema
    }

    func parse(_ args: [String]) throws -> [String: ArgValue] {
        var result: [String: ArgValue] = [:]
        var index = 0

        while index < args.count {
            let token = args[index]
            guard token.hasPrefix("--") else { index += 1; continue }

            let flag = String(token.dropFirst(2))

            guard let schemaEntry = schema.first(where: { $0.flag == flag }) else {
                throw ParseError.unknownFlag(flag)
            }

            switch schemaEntry.type {
            case .bool:
                // Bool flags are standalone (presence = true)
                result[flag] = .bool(true)

            case .string:
                guard index + 1 < args.count else { throw ParseError.missingValue(flag) }
                index += 1
                result[flag] = .string(args[index])

            case .int:
                guard index + 1 < args.count else { throw ParseError.missingValue(flag) }
                index += 1
                guard let intVal = Int(args[index]) else {
                    throw ParseError.typeMismatch(flag: flag, expected: .int)
                }
                result[flag] = .int(intVal)
            }

            index += 1
        }
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

func assertThrows<E: Error & Equatable>(_ block: () throws -> Any, error: E, _ label: String = "") {
    do {
        _ = try block()
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected error \(error) but none thrown")
    } catch let e as E {
        assertEqual(e, error, label)
    } catch {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — wrong error type: \(error)")
    }
}

// MARK: - Tests

func runTests() {
    let schema: [ArgSchema] = [
        ArgSchema(flag: "log",     type: .string),
        ArgSchema(flag: "verbose", type: .int),
        ArgSchema(flag: "debug",   type: .bool)
    ]
    let parser = ParseArgs(schema: schema)

    // String arg
    let result1 = try! parser.parse(["--log", "output.txt"])
    assertEqual(result1["log"], .string("output.txt"), "string arg")

    // Int arg
    let result2 = try! parser.parse(["--verbose", "3"])
    assertEqual(result2["verbose"], .int(3), "int arg")

    // Bool flag (presence = true)
    let result3 = try! parser.parse(["--debug"])
    assertEqual(result3["debug"], .bool(true), "bool flag")

    // Multiple args
    let result4 = try! parser.parse(["--log", "app.log", "--verbose", "5", "--debug"])
    assertEqual(result4["log"],     .string("app.log"), "multi: string")
    assertEqual(result4["verbose"], .int(5),            "multi: int")
    assertEqual(result4["debug"],   .bool(true),        "multi: bool")

    // Unknown flag
    assertThrows({ try parser.parse(["--unknown"]) },
                 error: ParseError.unknownFlag("unknown"), "unknown flag error")

    // Type mismatch
    assertThrows({ try parser.parse(["--verbose", "notanumber"]) },
                 error: ParseError.typeMismatch(flag: "verbose", expected: .int), "type mismatch error")

    // Missing value
    assertThrows({ try parser.parse(["--log"]) },
                 error: ParseError.missingValue("log"), "missing value error")
}

runTests()
