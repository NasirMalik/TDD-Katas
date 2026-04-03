// Bingo Refactoring Kata
// https://sammancoaching.org/kata_descriptions/bingo.html
//
// Rules:
//   - A board must be initialized (all cells assigned a value) before use.
//   - No cell can share a value with another cell on the same board.
//   - Players mark cells; check for winning lines.
//
// This is also a REFACTORING kata — the starting code has primitive obsession,
// data clumps, and long methods. The clean version is shown here.

// MARK: - Coordinate value type (eliminates primitive obsession)

struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

// MARK: - Cell

struct BingoCell {
    let coordinate: Coordinate
    let value:      Int
    var isMarked:   Bool = false
}

// MARK: - Board

class BingoBoard {
    private let size: Int
    private var cells: [Coordinate: BingoCell] = [:]
    private(set) var isInitialized: Bool = false

    init(size: Int = 5) {
        self.size = size
    }

    @discardableResult
    func assign(value: Int, at coord: Coordinate) -> Bool {
        guard !isInitialized else { return false }
        guard !cells.values.map(\.value).contains(value) else { return false }
        cells[coord] = BingoCell(coordinate: coord, value: value)
        isInitialized = cells.count == size * size
        return true
    }

    func mark(value: Int) -> Bool {
        guard isInitialized else { return false }
        for coord in cells.keys where cells[coord]?.value == value {
            cells[coord]?.isMarked = true
            return true
        }
        return false
    }

    var hasWon: Bool {
        guard isInitialized else { return false }
        return hasCompleteRow || hasCompleteColumn
    }

    private var hasCompleteRow: Bool {
        (0..<size).contains { row in
            (0..<size).allSatisfy { col in cells[Coordinate(row: row, col: col)]?.isMarked == true }
        }
    }

    private var hasCompleteColumn: Bool {
        (0..<size).contains { col in
            (0..<size).allSatisfy { row in cells[Coordinate(row: row, col: col)]?.isMarked == true }
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
    let board = BingoBoard(size: 2)  // 2×2 for easy testing

    // Not initialized until all cells assigned
    assertEqual(board.isInitialized, false, "not initialized at start")
    assertEqual(board.mark(value: 1),  false, "cannot mark before init")

    // Assign all 4 cells of 2×2 board
    board.assign(value: 1, at: Coordinate(row: 0, col: 0))
    board.assign(value: 2, at: Coordinate(row: 0, col: 1))
    board.assign(value: 3, at: Coordinate(row: 1, col: 0))
    board.assign(value: 4, at: Coordinate(row: 1, col: 1))

    assertEqual(board.isInitialized, true, "initialized after all cells assigned")

    // Duplicate value rejected
    let result = board.assign(value: 1, at: Coordinate(row: 0, col: 0))
    assertEqual(result, false, "duplicate value rejected")

    // No win yet
    assertEqual(board.hasWon, false, "no win before marks")

    // Mark a full row → win
    board.mark(value: 1)
    board.mark(value: 2)
    assertEqual(board.hasWon, true, "win after completing row")
}

runTests()
