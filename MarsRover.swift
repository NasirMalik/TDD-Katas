// Mars Rover Kata
// https://sammancoaching.org/kata_descriptions/mars_rover.html
//
// Rules:
//   Rover starts at (x, y) facing a direction (N/S/E/W).
//   Commands: L (turn left 90°), R (turn right 90°), M (move forward 1).
//   North of (x, y) is (x, y+1).

enum Direction: CaseIterable {
    case north, east, south, west

    var turnLeft: Direction {
        switch self {
        case .north: return .west
        case .west: return .south
        case .south: return .east
        case .east: return .north
        }
    }

    var turnRight: Direction {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }

    var description: String {
        switch self { case .north: return "N"; case .east: return "E"
                      case .south: return "S"; case .west: return "W" }
    }

    static func from(_ char: Character) -> Direction {
        switch char { case "N": return .north; case "E": return .east
                      case "S": return .south; default:  return .west }
    }
}

struct Rover {
    var x: Int
    var y: Int
    var facing: Direction

    mutating func execute(_ commands: String) {
        for cmd in commands {
            switch cmd {
            case "L": facing = facing.turnLeft
            case "R": facing = facing.turnRight
            case "M":
                switch facing {
                case .north: y += 1
                case .south: y -= 1
                case .east:  x += 1
                case .west:  x -= 1
                }
            default: break
            }
        }
    }

    var position: String { "\(x) \(y) \(facing.description)" }
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
    // Example from kata: (1,2,N) + "LMLMLMLMM" → (1,3,N)
    var rover1 = Rover(x: 1, y: 2, facing: .north)
    rover1.execute("LMLMLMLMM")
    assertEqual(rover1.position, "1 3 N", "rover 1 final position")

    // Example from kata: (3,3,E) + "MMRMMRMRRM" → (5,1,E)
    var rover2 = Rover(x: 3, y: 3, facing: .east)
    rover2.execute("MMRMMRMRRM")
    assertEqual(rover2.position, "5 1 E", "rover 2 final position")

    // Turning only
    var rover3 = Rover(x: 0, y: 0, facing: .north)
    rover3.execute("LLLL")
    assertEqual(rover3.position, "0 0 N", "four left turns = full circle")

    rover3.execute("RRRR")
    assertEqual(rover3.position, "0 0 N", "four right turns = full circle")

    // Moving north increases y
    var rover4 = Rover(x: 0, y: 0, facing: .north)
    rover4.execute("M")
    assertEqual(rover4.position, "0 1 N", "move north")
}

runTests()
