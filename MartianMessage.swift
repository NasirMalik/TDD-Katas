// Martian Message Kata
// https://sammancoaching.org/kata_descriptions/martian_message.html
//
// Rules:
//   17 positions in a circle: 0x0–0xF plus a "?" card (index 16).
//   Each ASCII character is encoded as two hex digits.
//   Camera starts at position 0x0; chooses shortest rotation (CW or CCW).
//   Returns a sequence of (direction, steps) motor commands.

enum RotationDirection { case clockwise, counterClockwise }

struct MotorCommand {
    let direction: RotationDirection
    let steps:     Int
}

struct MartianMessage {
    private let positions: [Character] = [
        "0","1","2","3","4","5","6","7",
        "8","9","A","B","C","D","E","F","?"
    ]
    private let totalPositions = 17

    func encode(message: String) -> [MotorCommand] {
        var commands: [MotorCommand] = []
        var currentPos = 0   // starts at 0x0

        for char in message {
            let ascii = Int(char.asciiValue ?? 0)
            let highNibble = ascii >> 4
            let lowNibble  = ascii & 0xF

            for nibble in [highNibble, lowNibble] {
                let cmd = rotate(from: currentPos, to: nibble)
                commands.append(cmd)
                currentPos = nibble
            }
        }
        return commands
    }

    private func rotate(from: Int, to: Int) -> MotorCommand {
        let cwSteps  = (to - from + totalPositions) % totalPositions
        let ccwSteps = (from - to + totalPositions) % totalPositions

        if cwSteps <= ccwSteps {
            return MotorCommand(direction: .clockwise,        steps: cwSteps)
        } else {
            return MotorCommand(direction: .counterClockwise, steps: ccwSteps)
        }
    }
}

extension Character {
    var asciiValue: UInt8? { asciiValue(of: self) }
    private func asciiValue(of c: Character) -> UInt8? {
        c.asciiValue
    }
}

extension Character {
    var asciiValue: UInt8? {
        guard let scalar = unicodeScalars.first, scalar.value < 128 else { return nil }
        return UInt8(scalar.value)
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
    let kata = MartianMessage()

    // 'H' = 0x48
    // From 0x0 → 0x4: 4 steps CW
    // From 0x4 → 0x8: 4 steps CW
    let cmds = kata.encode(message: "H")
    assertEqual(cmds.count, 2, "one char = two nibble commands")
    assertEqual(cmds[0].direction, .clockwise,     "high nibble direction")
    assertEqual(cmds[0].steps,     4,              "high nibble 0→4")
    assertEqual(cmds[1].direction, .clockwise,     "low nibble direction")
    assertEqual(cmds[1].steps,     4,              "low nibble 4→8")

    // 'A' = 0x41
    // From 0 → 4: 4 CW
    // From 4 → 1: CCW 3 (shorter than CW 13)
    let cmdA = kata.encode(message: "A")
    assertEqual(cmdA[0].steps, 4, "A high nibble: 4 CW")
    assertEqual(cmdA[1].steps, 3, "A low nibble: 3 CCW")
    assertEqual(cmdA[1].direction, .counterClockwise, "A low nibble direction")

    // Empty message
    let empty = kata.encode(message: "")
    assertEqual(empty.count, 0, "empty message = no commands")

    // All commands use shortest path (steps ≤ 8 for 17-position circle)
    let allCmds = kata.encode(message: "HOW ALIVE?")
    assertEqual(allCmds.allSatisfy { $0.steps <= 8 }, true, "all rotations use shortest path")
}

runTests()
