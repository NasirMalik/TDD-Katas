// Lift Kata
// https://sammancoaching.org/kata_descriptions/lift.html
//
// Rules:
//   A lift fulfills a request when it moves to a floor and opens doors.
//   A lift can only move when doors are closed.
//   Requests from inside the lift; calls from floor buttons.

enum LiftDoorState { case open, closed }
enum LiftDirection { case up, down, idle }

class Lift {
    private(set) var floor: Int = 0
    private(set) var doorState: LiftDoorState = .closed
    private(set) var direction: LiftDirection = .idle

    private var requests: Set<Int> = []  // passengers inside requesting floors
    private var calls:    Set<Int> = []  // floor buttons pressed

    // Passenger inside presses a floor button
    func requestFloor(_ floor: Int) {
        requests.insert(floor)
    }

    // Someone on a floor calls the lift
    func callFromFloor(_ floor: Int) {
        calls.insert(floor)
    }

    // Process one step of movement
    func step() {
        guard doorState == .closed else {
            closeDoors()
            return
        }

        let targets = requests.union(calls)
        guard !targets.isEmpty else {
            direction = .idle
            return
        }

        let nextFloor = targets.sorted().first(where: { $0 >= floor }) ?? targets.sorted().last!
        if nextFloor > floor {
            direction = .up
            floor += 1
        } else if nextFloor < floor {
            direction = .down
            floor -= 1
        }

        if targets.contains(floor) {
            openDoors()
            requests.remove(floor)
            calls.remove(floor)
        }
    }

    func openDoors() {
        guard doorState == .closed else { return }
        doorState = .open
    }

    func closeDoors() {
        doorState = .closed
    }

    // Run until all requests fulfilled
    func runUntilIdle(maxSteps: Int = 100) {
        var steps = 0
        while (!requests.isEmpty || !calls.isEmpty || doorState == .open), steps < maxSteps {
            step()
            steps += 1
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
    let lift = Lift()
    assertEqual(lift.floor,     0,       "starts at floor 0")
    assertEqual(lift.doorState, .closed, "doors start closed")
    assertEqual(lift.direction, .idle,   "starts idle")

    // Request floor 3 and run
    lift.requestFloor(3)
    lift.runUntilIdle()
    assertEqual(lift.floor,     3,       "reached floor 3")
    assertEqual(lift.doorState, .closed, "doors closed after servicing")

    // Call from floor 1 (below current position)
    lift.callFromFloor(1)
    lift.runUntilIdle()
    assertEqual(lift.floor,     1,       "reached floor 1")

    // Multiple requests
    lift.requestFloor(5)
    lift.requestFloor(2)
    lift.runUntilIdle()
    assertEqual(lift.floor, 5, "fulfils all requests")
}

runTests()
