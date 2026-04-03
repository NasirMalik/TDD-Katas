// Office Cleaning Robot Kata
// https://sammancoaching.org/kata_descriptions/office_cleaner.html
//
// Rules:
//   Robot starts at (x, y).
//   Commands: direction (N/S/E/W) + steps.
//   The robot cleans every position it visits (not just where it stops).
//   Output: count of unique cleaned positions.

struct OfficeCleaner {
    struct Command {
        let direction: Character
        let steps: Int
    }

    func execute(start: (x: Int, y: Int), commands: [Command]) -> Int {
        var cleaned: Set<String> = []
        var x = start.x
        var y = start.y
        cleaned.insert("\(x),\(y)")

        for cmd in commands {
            let (dx, dy): (Int, Int) = switch cmd.direction {
            case "N": (0,  1)
            case "S": (0, -1)
            case "E": (1,  0)
            default:  (-1, 0) // W
            }
            for _ in 0..<cmd.steps {
                x += dx
                y += dy
                cleaned.insert("\(x),\(y)")
            }
        }
        return cleaned.count
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
    let robot = OfficeCleaner()

    // No commands: only starting position
    assertEqual(robot.execute(start: (0, 0), commands: []), 1, "no movement, just start")

    // Move east 2 then north 1 from (10,22) → 4 unique positions
    assertEqual(
        robot.execute(
            start: (10, 22),
            commands: [
                OfficeCleaner.Command(direction: "E", steps: 2),
                OfficeCleaner.Command(direction: "N", steps: 1)
            ]
        ),
        4,
        "example from kata"
    )

    // Revisit positions: move east 2, then west 2 → only 3 unique (0,1,2)
    assertEqual(
        robot.execute(
            start: (0, 0),
            commands: [
                OfficeCleaner.Command(direction: "E", steps: 2),
                OfficeCleaner.Command(direction: "W", steps: 2)
            ]
        ),
        3,
        "overlapping path"
    )

    // Single step in each direction from origin
    assertEqual(
        robot.execute(
            start: (0, 0),
            commands: [
                OfficeCleaner.Command(direction: "N", steps: 1),
                OfficeCleaner.Command(direction: "E", steps: 1),
                OfficeCleaner.Command(direction: "S", steps: 1),
                OfficeCleaner.Command(direction: "W", steps: 1)
            ]
        ),
        5,
        "plus shape: origin + 4 cardinal positions"
    )
}

runTests()
