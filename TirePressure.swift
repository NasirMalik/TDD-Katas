// Tire Pressure Kata
// https://sammancoaching.org/kata_descriptions/tire_pressure.html
//
// Rules:
//   Monitor tire pressure; activate alarm if pressure is outside 17–21 PSI.
//   The real sensor (popNextValue()) can't be called in unit tests,
//   so we use a protocol + dependency injection to test the alarm logic.

// MARK: - Sensor Protocol (dependency injection boundary)

protocol PressureSensor {
    func popNextValue() -> Double
}

// MARK: - Real Sensor (uses hardware — not called in tests)

struct TireSensor: PressureSensor {
    func popNextValue() -> Double {
        // In a real system this would read from hardware
        return Double.random(in: 15...23)
    }
}

// MARK: - Alarm

class Alarm {
    private let sensor: PressureSensor
    private let lowThreshold:  Double = 17
    private let highThreshold: Double = 21

    private(set) var isAlarmOn: Bool = false

    init(sensor: PressureSensor) {
        self.sensor = sensor
    }

    func check() {
        let pressure = sensor.popNextValue()
        if pressure < lowThreshold || pressure > highThreshold {
            isAlarmOn = true
        }
    }
}

// MARK: - Stub Sensor (for testing)

struct StubSensor: PressureSensor {
    var value: Double
    func popNextValue() -> Double { value }
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
    // Normal pressure → alarm stays off
    let normalAlarm = Alarm(sensor: StubSensor(value: 19.0))
    assertEqual(normalAlarm.isAlarmOn, false, "alarm off before check")
    normalAlarm.check()
    assertEqual(normalAlarm.isAlarmOn, false, "alarm off within range")

    // Low pressure → alarm on
    let lowAlarm = Alarm(sensor: StubSensor(value: 16.0))
    lowAlarm.check()
    assertEqual(lowAlarm.isAlarmOn, true, "alarm on for low pressure")

    // High pressure → alarm on
    let highAlarm = Alarm(sensor: StubSensor(value: 22.5))
    highAlarm.check()
    assertEqual(highAlarm.isAlarmOn, true, "alarm on for high pressure")

    // Boundary values
    let lowerBound = Alarm(sensor: StubSensor(value: 17.0))
    lowerBound.check()
    assertEqual(lowerBound.isAlarmOn, false, "17 PSI is acceptable")

    let upperBound = Alarm(sensor: StubSensor(value: 21.0))
    upperBound.check()
    assertEqual(upperBound.isAlarmOn, false, "21 PSI is acceptable")

    // Just outside boundary
    let justLow = Alarm(sensor: StubSensor(value: 16.9))
    justLow.check()
    assertEqual(justLow.isAlarmOn, true, "16.9 PSI triggers alarm")
}

runTests()
