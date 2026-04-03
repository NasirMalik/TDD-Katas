// Lift Button Kata
// https://sammancoaching.org/kata_descriptions/lift_button.html
//
// State machine:
//   - Press button → light ON
//   - Lift arrives (doors open) → light OFF
//   - Press while light already ON and doors closed → no change
//   - Press while doors open → no change

enum DoorState { case open, closed }

class LiftButton {
    private(set) var isLit: Bool = false
    private var doorState: DoorState = .closed

    func press() {
        guard doorState == .closed, !isLit else { return }
        isLit = true
    }

    func doorsOpened() {
        doorState = .open
        isLit = false
    }

    func doorsClosed() {
        doorState = .closed
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
    let button = LiftButton()
    assertEqual(button.isLit, false, "starts unlit")

    // Press → light on
    button.press()
    assertEqual(button.isLit, true, "light on after press")

    // Press again while lit → no change
    button.press()
    assertEqual(button.isLit, true, "still lit when pressed again")

    // Lift arrives → light off
    button.doorsOpened()
    assertEqual(button.isLit, false, "light off when doors open")

    // Press while doors open → no effect
    button.press()
    assertEqual(button.isLit, false, "press while doors open has no effect")

    // Doors close, press again → light on
    button.doorsClosed()
    button.press()
    assertEqual(button.isLit, true, "light on after doors close and press")
}

runTests()
