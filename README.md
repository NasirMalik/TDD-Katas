# Swift Coding Katas — Interview Preparation

A collection of **37 coding katas** from [sammancoaching.org](https://sammancoaching.org/kata_descriptions/), all implemented in **pure Swift** with no dependencies on XCTest or the Objective-C runtime. Each file is self-contained and runnable with a single command.

Built for developers preparing for **technical interviews**, practising **Test-Driven Development (TDD)**, or building fluency in Swift fundamentals.

---

## How to Run Any Kata

```bash
swift FizzBuzz.swift
```

Every file follows the same structure:

```swift
// 1. Implementation struct / class
struct FizzBuzz {
    func execute(_ number: Int) -> String { ... }
}

// 2. Lightweight assertEqual helper (no XCTest needed)
func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ label: String = "") {
    if actual == expected { print("PASS [\(label)]") }
    else { print("FAIL [\(label)] — expected \"\(expected)\", got \"\(actual)\"") }
}

// 3. All tests live here — add new ones as you TDD
func runTests() {
    assertEqual(FizzBuzz().execute(15), "FizzBuzz", "multiple of 15")
}

runTests()
```

---

## TDD Cycle

Each kata is designed for the **Red → Green → Refactor** loop:

| Step | What to do |
|------|-----------|
| **Red** | Add a new `assertEqual` call in `runTests()` for behaviour you haven't implemented yet. Run the file — it should print `FAIL`. |
| **Green** | Write the minimum code to make it pass. Run again — it should print `PASS`. |
| **Refactor** | Clean up without changing behaviour. Run again to confirm all tests still pass. |

---

## Table of Contents

### Fundamentals
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [FizzBuzz](#-fizzbuzz) | Conditionals, modulo | [FizzBuzz.swift](FizzBuzz.swift) |
| [Leap Years](#-leap-years) | Boolean logic, edge cases | [LeapYears.swift](LeapYears.swift) |
| [Calculate Stats](#-calculate-stats) | Collections, error handling | [CalcStats.swift](CalcStats.swift) |
| [Closest to Zero](#-closest-to-zero) | Reduce, tie-breaking rules | [ClosestToZero.swift](ClosestToZero.swift) |
| [Fractions](#-fractions) | Value types, GCD, operator overloading | [Fractions.swift](Fractions.swift) |
| [String Calculator](#-string-calculator) | Parsing, recursion, precedence | [StringCalculator.swift](StringCalculator.swift) |

### Strings & Patterns
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Diamond](#-diamond) | String formatting, symmetry | [Diamond.swift](Diamond.swift) |
| [Word Wrap](#-word-wrap) | String manipulation, greedy algorithms | [WordWrap.swift](WordWrap.swift) |
| [Filename Range](#-filename-range) | String parsing, index arithmetic | [FilenameRange.swift](FilenameRange.swift) |
| [Parse Args](#-parse-args) | Tokenising, typed schemas, error handling | [ParseArgs.swift](ParseArgs.swift) |

### Songs & Generation
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Ten Green Bottles](#-ten-green-bottles) | Template logic, counting | [TenGreenBottles.swift](TenGreenBottles.swift) |
| [Twelve Days of Christmas](#-twelve-days-of-christmas) | Cumulative patterns, arrays | [ChristmasSong.swift](ChristmasSong.swift) |

### Data Structures
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Recently Used List](#-recently-used-list) | LIFO, uniqueness, capacity | [RecentlyUsedList.swift](RecentlyUsedList.swift) |
| [Phonebook](#-phonebook) | Dictionaries, prefix constraints | [Phonebook.swift](Phonebook.swift) |
| [Strange Characters](#-strange-characters) | Structs, search, optional relationships | [StrangeCharacters.swift](StrangeCharacters.swift) |

### Scoring & Games
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Tennis](#-tennis) | State machines, scoring rules | [Tennis.swift](Tennis.swift) |
| [Yatzy](#-yatzy) | Dice scoring, pattern matching | [Yatzy.swift](Yatzy.swift) |
| [Bingo](#-bingo-refactoring) | Value types, board state, refactoring | [Bingo.swift](Bingo.swift) |

### Simulations
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Mars Rover](#-mars-rover) | Enums, direction, command pattern | [MarsRover.swift](MarsRover.swift) |
| [Office Cleaning Robot](#-office-cleaning-robot) | Sets, coordinate tracking | [OfficeCleaner.swift](OfficeCleaner.swift) |
| [Monty Hall](#-monty-hall) | Probability, simulation, statistics | [MontyHall.swift](MontyHall.swift) |
| [Martian Message](#-martian-message) | Encoding, circular arithmetic | [MartianMessage.swift](MartianMessage.swift) |

### Domain Modelling
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Bank Account](#-bank-account) | Mutations, formatted output | [BankAccount.swift](BankAccount.swift) |
| [Shopping Basket](#-shopping-basket) | Discount tiers, pricing logic | [ShoppingBasket.swift](ShoppingBasket.swift) |
| [Supermarket Receipt](#-supermarket-receipt) | Promotions, receipts, protocols | [SupermarketReceipt.swift](SupermarketReceipt.swift) |
| [RPG Combat](#-rpg-combat) | Classes, factions, level scaling | [RPGCombat.swift](RPGCombat.swift) |
| [Vending Machine](#-vending-machine) | State machines, coins, inventory | [VendingMachine.swift](VendingMachine.swift) |
| [Lift](#-lift) | Multi-request scheduling, door state | [Lift.swift](Lift.swift) |
| [Lift Button](#-lift-button) | Finite state machine | [LiftButton.swift](LiftButton.swift) |

### Dependency Injection & Testability
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Tire Pressure](#-tire-pressure) | Protocol injection, sensor testing | [TirePressure.swift](TirePressure.swift) |
| [Birthday Greetings](#-birthday-greetings) | Ports & adapters, date logic | [BirthdayGreetings.swift](BirthdayGreetings.swift) |
| [Audit Everything](#-audit-everything) | File system abstraction, stub I/O | [Audit.swift](Audit.swift) |
| [INSTAVOICED](#-instavoiced) | Pipeline architecture, multi-port injection | [Instavoiced.swift](Instavoiced.swift) |
| [Log Parser](#-log-parser) | Testing existing code, characterisation tests | [LogParser.swift](LogParser.swift) |

### Refactoring Katas
| Kata | Key Concepts | Solution |
|------|-------------|---------|
| [Gilded Rose](#-gilded-rose-refactoring) | Legacy code, polymorphism, extend without breaking | [GildedRose.swift](GildedRose.swift) |
| [Theatrical Players](#-theatrical-players-refactoring) | Extract method, phase splitting, renaming | [TheatricalPlayers.swift](TheatricalPlayers.swift) |
| [Trip Service](#-trip-service-refactoring) | Extract & override, seams, legacy testing | [TripService.swift](TripService.swift) |

---

## Kata Details

---

### 🟢 FizzBuzz
**Source:** [sammancoaching.org/kata_descriptions/fizzbuzz.html](https://sammancoaching.org/kata_descriptions/fizzbuzz.html)
**Solution:** [FizzBuzz.swift](FizzBuzz.swift)

**Rules:**
- Print numbers 1–100
- Multiples of 3 → `"Fizz"`
- Multiples of 5 → `"Buzz"`
- Multiples of both → `"FizzBuzz"`

**What it teaches:**
The key insight interviewers are looking for is handling the **multiple-of-both edge case without a separate `% 15` check**. The cleanest solution uses `switch (bool, bool)`:

```swift
switch (number % 3 == 0, number % 5 == 0) {
case (true,  true):  return "FizzBuzz"
case (true,  false): return "Fizz"
case (false, true):  return "Buzz"
case (false, false): return "\(number)"
}
```

**Interview relevance:** Extremely common first-round screening question. Interviewers are watching for clean conditional logic, not just a working solution.

**TDD starting point:** Begin with `execute(1) == "1"`, then `execute(3) == "Fizz"`, then `execute(5) == "Buzz"`, then `execute(15) == "FizzBuzz"`.

---

### 🟢 Leap Years
**Source:** [sammancoaching.org/kata_descriptions/leap_years.html](https://sammancoaching.org/kata_descriptions/leap_years.html)
**Solution:** [LeapYears.swift](LeapYears.swift)

**Rules:**
- Divisible by 4 → leap year
- Divisible by 100 → NOT a leap year
- Divisible by 400 → IS a leap year (overrides the 100 rule)

**What it teaches:**
Handling **multiple overlapping conditions** in the right priority order. The common mistake is checking `% 4` first and forgetting `% 400` takes precedence over `% 100`.

**Interview relevance:** Tests whether you can translate business rules with exceptions-to-exceptions into clean, readable code. Also a classic TDD exercise because the edge cases (1900, 2000) are perfect for Red–Green cycles.

**TDD starting point:** 2001 (false) → 1996 (true) → 1900 (false) → 2000 (true).

---

### 🟢 Calculate Stats
**Source:** [sammancoaching.org/kata_descriptions/calc_stats.html](https://sammancoaching.org/kata_descriptions/calc_stats.html)
**Solution:** [CalcStats.swift](CalcStats.swift)

**Rules:**
- Given a list of integers, return min, max, count, and average.
- Empty list → throw an error with the message `"sequence is empty"`.

**What it teaches:**
Swift's **error handling** (`throws`/`try`), working with collections, and returning multiple values cleanly using a struct. The empty-input guard is a boundary condition that interviewers often probe.

**Interview relevance:** Tests defensive programming (what happens at the boundary?), and whether you can model a result type cleanly instead of returning magic numbers like `-1`.

---

### 🟢 Closest to Zero
**Source:** [sammancoaching.org/kata_descriptions/closest_to_zero.html](https://sammancoaching.org/kata_descriptions/closest_to_zero.html)
**Solution:** [ClosestToZero.swift](ClosestToZero.swift)

**Rules:**
- Return the integer closest to zero.
- Tie (e.g. `-5` and `5`) → return the **positive** value.
- Empty list → return `0`.

**What it teaches:**
Using `reduce` to walk a list while carrying state, and handling **tie-breaking rules** without nested if-else. Interviewers often follow up with Part 2 (strings), which adds multiple tiebreaker criteria.

---

### 🟢 Fractions
**Source:** [sammancoaching.org/kata_descriptions/fractions.html](https://sammancoaching.org/kata_descriptions/fractions.html)
**Solution:** [Fractions.swift](Fractions.swift)

**Rules:**
- `Fraction` is an **immutable value type** — once created it cannot change.
- Addition returns a new Fraction in **lowest terms** (reduced via GCD).
- e.g. `1/2 + 3/4 = 5/4`

**What it teaches:**
Swift's `struct` as a **value type**, operator overloading (`+`), and the Euclidean algorithm for GCD. Also covers normalising the sign (negative denominator).

**Interview relevance:** Demonstrates understanding of value semantics vs reference semantics, immutability, and mathematical algorithms.

---

### 🟢 String Calculator
**Source:** [sammancoaching.org/kata_descriptions/string_calculator.html](https://sammancoaching.org/kata_descriptions/string_calculator.html)
**Solution:** [StringCalculator.swift](StringCalculator.swift)

**Rules (incremental):**
1. Parse a single integer (including negatives)
2. Add two numbers: `"1 + 2"` → `3`
3. Subtract: `"10 - 4"` → `6`
4. Multiply, divide, parentheses — at your own pace
5. No use of `eval()`

**What it teaches:**
**Recursive descent parsing** — one of the most important algorithms for interviews at product companies. The kata teaches you to build it incrementally, one test at a time. Also covers operator precedence (`*` before `+`).

**Interview relevance:** Parsing expressions is a very common systems-design interview question. Building it from scratch (no `eval`) shows you understand how compilers work.

---

### 🔷 Diamond
**Source:** [sammancoaching.org/kata_descriptions/diamond.html](https://sammancoaching.org/kata_descriptions/diamond.html)
**Solution:** [Diamond.swift](Diamond.swift)

**Rules:**
- Input: a letter (e.g. `'C'`)
- Output: an ASCII diamond starting with `A` at the top, widening to the input letter at the middle, then mirroring back to `A`.

```
  A  
 B B 
C   C
 B B 
  A  
```

**What it teaches:**
Thinking about **symmetry as a property** rather than hardcoding strings. A great kata for practising property-based testing: every row has the same width; the pattern is vertically symmetric; the widest row contains the input letter.

**Interview relevance:** Spatial reasoning, string formatting, and the insight that `rows + rows.dropLast().reversed()` is more expressive than building both halves separately.

---

### 🔷 Word Wrap
**Source:** [sammancoaching.org/kata_descriptions/word_wrap.html](https://sammancoaching.org/kata_descriptions/word_wrap.html)
**Solution:** [WordWrap.swift](WordWrap.swift)

**Rules:**
- Given a string and a column width, insert `\n` so no line exceeds the width.
- Break at the last space within the column if possible.
- If no space exists, break mid-word.

**What it teaches:**
**Greedy string algorithms** and the discipline of handling edge cases (single long word, empty string, exact fit). Classic kata by Robert C. Martin used to demonstrate TDD step-by-step.

**Interview relevance:** Often appears as a "design a text editor" sub-problem. Tests your ability to work with string indices cleanly in Swift.

---

### 🔷 Filename Range
**Source:** [sammancoaching.org/kata_descriptions/filename_range.html](https://sammancoaching.org/kata_descriptions/filename_range.html)
**Solution:** [FilenameRange.swift](FilenameRange.swift)

**Rules:**
- Return the `(start, end)` index range of the **base name** in a file path.
- Strip: directory prefix, file extension, and test keywords (`test`, `tests`, `spec`, `step`) with their separators (`.`, `_`, `-`).
- e.g. `"test/FizzBuzz_test.exs"` → selects `"FizzBuzz"`

**What it teaches:**
Systematic string decomposition, dealing with **multiple overlapping rules**, and index arithmetic. A real-world kata that mimics IDE rename-refactoring behaviour.

---

### 🔷 Parse Args
**Source:** [sammancoaching.org/kata_descriptions/parse_args.html](https://sammancoaching.org/kata_descriptions/parse_args.html)
**Solution:** [ParseArgs.swift](ParseArgs.swift)

**Rules:**
- Parse `--flag value` pairs according to a typed schema.
- Support `string`, `int`, and `bool` (presence = true) types.
- Throw specific errors for: unknown flags, type mismatches, missing values.

**What it teaches:**
Building a **typed argument parser from scratch** — the kata explicitly forbids using existing libraries so you understand what those libraries do internally. Covers enums, pattern matching, and structured error types.

**Interview relevance:** Schema validation and type-safe parsing appear frequently in backend/systems interviews.

---

### 🎵 Ten Green Bottles
**Source:** [sammancoaching.org/kata_descriptions/ten_green_bottles.html](https://sammancoaching.org/kata_descriptions/ten_green_bottles.html)
**Solution:** [TenGreenBottles.swift](TenGreenBottles.swift)

**Rules:**
- Generate all 10 verses of the counting-down song programmatically.
- No hardcoded lyrics; the program must be "small".
- Handle singular/plural correctly (`"1 bottle"` vs `"2 bottles"`).

**What it teaches:**
**Templatised string generation** and handling number-to-word conversion. Good warm-up kata for TDD newcomers — the requirements are simple but the pluralisation and zero-case edge cases force you to think.

---

### 🎵 Twelve Days of Christmas
**Source:** [sammancoaching.org/kata_descriptions/christmas_song.html](https://sammancoaching.org/kata_descriptions/christmas_song.html)
**Solution:** [ChristmasSong.swift](ChristmasSong.swift)

**Rules:**
- Generate all 12 verses.
- Each verse is **cumulative**: Day N lists gifts N down to 1.
- No hardcoded full lyrics.

**What it teaches:**
Recognising and implementing a **cumulative pattern** — each verse is not independent, it builds on all previous verses. Tests your ability to avoid copy-paste with a clean loop.

---

### 📋 Recently Used List
**Source:** [sammancoaching.org/kata_descriptions/recently_used_list.html](https://sammancoaching.org/kata_descriptions/recently_used_list.html)
**Solution:** [RecentlyUsedList.swift](RecentlyUsedList.swift)

**Rules:**
- Most recently added item is at index 0 (LIFO order).
- Items are **unique**: adding a duplicate moves it to the front.
- Optional: reject empty strings; configurable max capacity.

**What it teaches:**
Designing a **custom data structure** on top of Swift's `Array`. The uniqueness + ordering constraint is the interesting part — you must remove-then-prepend. Also demonstrates subscript syntax and capacity enforcement.

**Interview relevance:** LRU cache is one of the most common data-structure interview questions. This kata is a simplified version that builds the intuition.

---

### 📋 Phonebook
**Source:** [sammancoaching.org/kata_descriptions/phonebook.html](https://sammancoaching.org/kata_descriptions/phonebook.html)
**Solution:** [Phonebook.swift](Phonebook.swift)

**Rules:**
- Support name → number lookup.
- **No number may be a prefix of another** number already stored.
- Skip conflicting entries and record them in a `skipped` list.

**What it teaches:**
Trie-like **prefix constraint** logic using a dictionary, and the difference between validation (check on add) vs enforcement (reject with record).

---

### 📋 Strange Characters
**Source:** [sammancoaching.org/kata_descriptions/strange_characters.html](https://sammancoaching.org/kata_descriptions/strange_characters.html)
**Solution:** [StrangeCharacters.swift](StrangeCharacters.swift)

**Rules:**
- Characters have: first name, optional family name, `isMonster`, optional nemesis/parent, children, siblings.
- Implement: `findByFirstName`, `findParent`, `findAllMonsters`, `findByFamilyName`.

**What it teaches:**
Modelling **graph-like relationships** with structs in Swift (optional references), and implementing flexible search over a collection. Good introduction to how ORM-style querying works.

---

### 🎮 Tennis
**Source:** [sammancoaching.org/kata_descriptions/tennis.html](https://sammancoaching.org/kata_descriptions/tennis.html)
**Solution:** [Tennis.swift](Tennis.swift)

**Rules:**
- Points: 0→Love, 1→Fifteen, 2→Thirty, 3→Forty
- Both at ≥3 and equal → `"Deuce"`
- Deuce +1 → `"Advantage <player>"`
- Deuce +2 → `"<player> wins"`

**What it teaches:**
Encoding **complex, layered business rules** cleanly. The Deuce/Advantage system is a natural state machine. A great kata for practising refactoring because naive if-else solutions grow complex fast.

**Interview relevance:** State machine design is a core pattern in iOS development (UIKit lifecycle, networking states). Tennis demonstrates it in a domain-neutral context.

---

### 🎮 Yatzy
**Source:** [sammancoaching.org/kata_descriptions/yatzy.html](https://sammancoaching.org/kata_descriptions/yatzy.html)
**Solution:** [Yatzy.swift](Yatzy.swift)

**Rules:**
- Score a given roll of 5 dice in a given category (Ones–Sixes, Pair, Full House, Straight, Yatzy, etc.)
- Return 0 if the roll doesn't qualify for the category.

**What it teaches:**
**Enum-based dispatch** for category scoring, and building frequency histograms of dice values. Each category is an independent scoring function — good practice for keeping logic separated.

---

### 🎮 Bingo (Refactoring)
**Source:** [sammancoaching.org/kata_descriptions/bingo.html](https://sammancoaching.org/kata_descriptions/bingo.html)
**Solution:** [Bingo.swift](Bingo.swift)

**Rules:**
- A board must be fully initialised (all cells assigned) before play.
- No cell can share a value with another cell.
- Detect a winning row or column.

**What it teaches:**
**Refactoring**: eliminating primitive obsession (replacing raw `(Int, Int)` pairs with a `Coordinate` struct), and using value types to enforce domain invariants. The starting point is deliberately messy.

---

### 🚀 Mars Rover
**Source:** [sammancoaching.org/kata_descriptions/mars_rover.html](https://sammancoaching.org/kata_descriptions/mars_rover.html)
**Solution:** [MarsRover.swift](MarsRover.swift)

**Rules:**
- Rover starts at `(x, y)` facing `N/S/E/W`.
- `L` / `R` → turn 90° left/right without moving.
- `M` → move forward one grid point.
- North of `(x, y)` is `(x, y+1)`.

**What it teaches:**
The **Command pattern** — each character in the string is a command executed on the rover's state. Enums with computed properties (`turnLeft`, `turnRight`) keep the rotation logic clean and free of magic numbers.

**Interview relevance:** Frequently asked in iOS/backend interviews as a design question. Shows ability to model state + behaviour cleanly.

---

### 🚀 Office Cleaning Robot
**Source:** [sammancoaching.org/kata_descriptions/office_cleaner.html](https://sammancoaching.org/kata_descriptions/office_cleaner.html)
**Solution:** [OfficeCleaner.swift](OfficeCleaner.swift)

**Rules:**
- Robot starts at `(x, y)` and receives directional commands.
- The robot **cleans every position it passes through**, not just where it stops.
- Output: count of unique cleaned positions.

**What it teaches:**
Using a **Set** to track unique visited coordinates, and the difference between "end position" and "all positions along a path". A Swift `Set<String>` with `"x,y"` keys is the simplest approach.

---

### 🚀 Monty Hall
**Source:** [sammancoaching.org/kata_descriptions/monty_hall.html](https://sammancoaching.org/kata_descriptions/monty_hall.html)
**Solution:** [MontyHall.swift](MontyHall.swift)

**Rules:**
- Simulate 1000 games with two strategies: always switch, always stay.
- Switching wins ~2/3 of the time; staying wins ~1/3.

**What it teaches:**
**Statistical simulation** and how to use randomness in a way that's still testable (run enough iterations that results converge). Demonstrates that sometimes the best proof is empirical.

**Interview relevance:** Probability questions (especially counterintuitive ones like Monty Hall) come up regularly in data/ML interviews. Being able to write a quick simulation is a powerful skill.

---

### 🚀 Martian Message
**Source:** [sammancoaching.org/kata_descriptions/martian_message.html](https://sammancoaching.org/kata_descriptions/martian_message.html)
**Solution:** [MartianMessage.swift](MartianMessage.swift)

**Rules:**
- 17 positions in a circle (0x0–0xF + `?`).
- Each ASCII character is sent as two hex nibbles.
- Camera rotates to each position, choosing the **shortest path** (CW or CCW).

**What it teaches:**
**Circular arithmetic** — the modular distance between two positions in a circle of size 17. The key formula: `CW = (to - from + 17) % 17`, `CCW = (from - to + 17) % 17`. Take the minimum.

**Interview relevance:** Circular buffer / ring buffer problems are common in systems and embedded interviews.

---

### 🏦 Bank Account
**Source:** [sammancoaching.org/kata_descriptions/bank_account.html](https://sammancoaching.org/kata_descriptions/bank_account.html)
**Solution:** [BankAccount.swift](BankAccount.swift)

**Rules:**
- `deposit(amount)`, `withdraw(amount)`, `printStatement()`.
- Statement shows: Date | Amount | Balance, in chronological order.
- Withdrawals are shown as negative amounts.

**What it teaches:**
Managing **mutable state** in a class, recording a transaction log, and producing formatted tabular output. Uses `DateFormatter` for real-world date handling.

---

### 🛒 Shopping Basket
**Source:** [sammancoaching.org/kata_descriptions/shopping_basket.html](https://sammancoaching.org/kata_descriptions/shopping_basket.html)
**Solution:** [ShoppingBasket.swift](ShoppingBasket.swift)

**Rules:**
- Basket total `> $100` → 5% discount.
- Basket total `> $200` → 10% discount.
- Discount applied to the **basket total**, not individual items.

**What it teaches:**
**Tiered pricing logic** using a computed property and Swift's `switch` with `where` clauses. Separating `subtotal`, `discountRate`, and `total` as distinct computed properties makes the logic easy to test independently.

---

### 🧾 Supermarket Receipt
**Source:** [sammancoaching.org/kata_descriptions/supermarket_receipt.html](https://sammancoaching.org/kata_descriptions/supermarket_receipt.html)
**Solution:** [SupermarketReceipt.swift](SupermarketReceipt.swift)

**Rules:**
- Products have a unit price; cart holds quantities (including decimal for weight-based).
- Promotions: buy-N-get-one-free, percentage discount, bundle pricing.
- Receipt shows line items, discounts applied, and final total.

**What it teaches:**
**Polymorphic pricing** using Swift enums with associated values — each promotion type carries its own parameters. The `ShoppingCart` applies the right promotion without knowing which specific type it is.

**Interview relevance:** Discount engines are a canonical example of the **Strategy pattern** — frequently discussed in system design rounds.

---

### ⚔️ RPG Combat
**Source:** [sammancoaching.org/kata_descriptions/rpg_combat.html](https://sammancoaching.org/kata_descriptions/rpg_combat.html)
**Solution:** [RPGCombat.swift](RPGCombat.swift)

**Rules:**
- Characters start at 1000 health, level 1, alive.
- Damage is scaled by ±50% when there's a 5+ level difference.
- Characters cannot damage themselves.
- Joining a faction makes characters allies: allies cannot damage each other but can heal each other.

**What it teaches:**
**Object-oriented design** — `Character` as a class with encapsulated state. The faction system introduces many-to-many relationships. Level scaling is a business rule applied inside `attack()`, not outside, which tests encapsulation discipline.

---

### 🍬 Vending Machine
**Source:** [sammancoaching.org/kata_descriptions/vending_machine.html](https://sammancoaching.org/kata_descriptions/vending_machine.html)
**Solution:** [VendingMachine.swift](VendingMachine.swift)

**Rules:**
- Accepts nickels (5¢), dimes (10¢), quarters (25¢); rejects pennies.
- Products: cola ($1.00), chips ($0.50), candy ($0.65).
- Display cycles through: `"INSERT COIN"` → amount → `"THANK YOU"` → reset.
- `"SOLD OUT"` and `"EXACT CHANGE ONLY"` edge cases.

**What it teaches:**
A **multi-state machine** — the display changes based on recent events (purchase, insufficient funds, sold out). Using a `lastMessage` pattern with a one-shot `nil` reset models "show once then return to default" cleanly.

**Interview relevance:** State machine design comes up in UI, networking, and hardware control interviews. The vending machine is a classic teaching example.

---

### 🏗️ Lift
**Source:** [sammancoaching.org/kata_descriptions/lift.html](https://sammancoaching.org/kata_descriptions/lift.html)
**Solution:** [Lift.swift](Lift.swift)

**Rules:**
- A lift fulfils a request by moving to a floor and opening doors.
- A lift can only move when doors are closed.
- Handles both passenger requests (inside) and floor calls (outside).

**What it teaches:**
**Scheduling logic** — choosing which floor to go to next given multiple pending requests. The `step()` method models one tick of simulation time, making the behaviour deterministic and testable.

---

### 🔘 Lift Button
**Source:** [sammancoaching.org/kata_descriptions/lift_button.html](https://sammancoaching.org/kata_descriptions/lift_button.html)
**Solution:** [LiftButton.swift](LiftButton.swift)

**Rules (state machine):**
- Press → light ON
- Lift arrives (doors open) → light OFF
- Press while light already ON and doors closed → no change
- Press while doors open → no change

**What it teaches:**
A pure **finite state machine** — arguably the simplest possible one. Drawing the state diagram first and then translating each transition into a guard clause is the key technique.

**Interview relevance:** iOS developers model button/UI states constantly. Being able to reason about FSMs formally (not just with if-else) is a mark of a senior developer.

---

### 🔧 Tire Pressure
**Source:** [sammancoaching.org/kata_descriptions/tire_pressure.html](https://sammancoaching.org/kata_descriptions/tire_pressure.html)
**Solution:** [TirePressure.swift](TirePressure.swift)

**Rules:**
- Alarm activates when pressure is outside 17–21 PSI.
- The real sensor (`popNextValue()`) cannot be called in unit tests (it reads hardware).
- Solution: inject the sensor through a protocol.

**What it teaches:**
The canonical example of **dependency injection for testability**. The `PressureSensor` protocol lets tests pass a `StubSensor` with a fixed value, while production code uses `TireSensor`. This pattern is fundamental to iOS unit testing.

**Interview relevance:** "How would you test code that depends on an external system?" — this kata is the answer.

---

### 🎂 Birthday Greetings
**Source:** [sammancoaching.org/kata_descriptions/birthday_greetings.html](https://sammancoaching.org/kata_descriptions/birthday_greetings.html)
**Solution:** [BirthdayGreetings.swift](BirthdayGreetings.swift)

**Rules:**
- Load friends from a data source; send birthday greeting emails on their birthday.
- Feb 29 birthdays → greet on Feb 28 in non-leap years.
- Data source and email sender are **injected via protocols**.

**What it teaches:**
The **Ports & Adapters (Hexagonal Architecture)** pattern. The domain logic has zero knowledge of how data is stored or how emails are delivered — those are plugged in. A `SpyEmailSender` in tests records what would have been sent.

**Interview relevance:** Architecture questions ("how would you design a notification system?") expect this kind of thinking: separate the domain from I/O concerns.

---

### 📁 Audit Everything
**Source:** [sammancoaching.org/kata_descriptions/audit.html](https://sammancoaching.org/kata_descriptions/audit.html)
**Solution:** [Audit.swift](Audit.swift)

**Rules:**
- Visitor records are stored in flat text files with a configurable max entries per file.
- When a file is full, a new file with an incremented index is created.
- `AuditManager` receives a `AuditFileSystem` protocol — no real disk I/O in tests.

**What it teaches:**
From Vladimir Khorikov's *Unit Testing* book. Demonstrates how to **abstract file system I/O** behind a protocol, and how the `InMemoryAuditFileSystem` stub makes the whole thing deterministic and fast.

---

### 🌍 INSTAVOICED
**Source:** [sammancoaching.org/kata_descriptions/instavoiced.html](https://sammancoaching.org/kata_descriptions/instavoiced.html)
**Solution:** [Instavoiced.swift](Instavoiced.swift)

**Rules:**
- Receive PDF invoices from ~200 European suppliers.
- Extract fields with OCR, convert to English XML, deliver to FTP once per day.
- Archive for 10-year retrieval.

**What it teaches:**
A **pipeline architecture** where each stage (fetch → OCR → serialize → deliver → archive) is injected through a protocol. The `processDailyBatch()` function orchestrates the pipeline without knowing anything about the concrete implementations.

**Interview relevance:** System design interviews for senior roles often ask about ETL pipelines. This kata teaches how to reason about them at the code level, not just the whiteboard.

---

### 📋 Log Parser
**Source:** [sammancoaching.org/kata_descriptions/log_parser.html](https://sammancoaching.org/kata_descriptions/log_parser.html)
**Solution:** [LogParser.swift](LogParser.swift)

**Rules:**
- Parse log lines of the format: `"DATE TIME LEVEL message"`
- Expose fields: date, time, level, message.
- Support filtering by level, counting errors.

**What it teaches:**
Writing **characterisation tests** — tests that describe what existing code does, even before you understand it fully. The kata starts with legacy untested code; your job is to add tests. `String.split(separator:maxSplits:)` is key.

---

### 🌹 Gilded Rose (Refactoring)
**Source:** [sammancoaching.org/kata_descriptions/gilded_rose.html](https://sammancoaching.org/kata_descriptions/gilded_rose.html)
**Solution:** [GildedRose.swift](GildedRose.swift)

**Rules (original):**
- Items degrade in quality each day; after `sellIn` passes, degrade twice as fast.
- "Aged Brie" increases in quality. "Sulfuras" never changes.
- "Backstage passes" increase rapidly near the concert, then drop to 0.
- **New requirement:** "Conjured" items degrade twice as fast as normal items.
- Quality is always between 0 and 50 (except Sulfuras at 80).

**What it teaches:**
The most famous refactoring kata. The starting code is a single deeply-nested if-else block. The refactored solution uses a **`switch` on item name** (or polymorphism) with clearly separated logic per item type. Key lesson: you cannot add "Conjured" cleanly until you refactor first.

**Interview relevance:** "Walk me through how you'd refactor this legacy code" — Gilded Rose is often used verbatim in senior-level interviews.

**TDD starting point:** Write characterisation tests for existing behaviour before changing anything.

---

### 🎭 Theatrical Players (Refactoring)
**Source:** [sammancoaching.org/kata_descriptions/theatrical_players.html](https://sammancoaching.org/kata_descriptions/theatrical_players.html)
**Solution:** [TheatricalPlayers.swift](TheatricalPlayers.swift)

**Rules:**
- Calculate billing statements for theatrical performances.
- Tragedy and comedy have different pricing formulas.
- Award volume credits (more for large audiences; bonus for comedy).

**What it teaches:**
From Martin Fowler's *Refactoring* (2nd edition). The refactoring techniques practised here are: **Extract Method**, **Split Phase**, **Replace Conditional with Polymorphism**, and **Rename for Intent**. The solution here shows the end state.

**Interview relevance:** Martin Fowler's refactoring catalogue is standard vocabulary in senior engineering interviews. Knowing these moves by name — and being able to apply them — signals experience.

---

### 🚗 Trip Service (Refactoring)
**Source:** [sammancoaching.org/kata_descriptions/trip_service.html](https://sammancoaching.org/kata_descriptions/trip_service.html)
**Solution:** [TripService.swift](TripService.swift)

**Rules:**
- Return a user's trips if the logged-in user is their friend.
- Throw `NotLoggedInException` if no user is logged in.
- The original code has a hard dependency on a static `UserSession` — you must break it.

**What it teaches:**
The **Extract and Override** / **Seam** pattern from Michael Feathers' *Working Effectively with Legacy Code*. By injecting `UserSession` and `TripRepository` as protocols, the business logic becomes testable without a real session or database.

**Interview relevance:** Breaking dependencies in legacy code is a senior-level skill. This kata is the distilled version of the problem that every developer faces when inheriting a codebase.

---

## Interview Preparation Strategy

### Week 1 — Fundamentals
Work through these in order. Each builds on the last.

1. [FizzBuzz](FizzBuzz.swift) — warm up, practice the TDD rhythm
2. [Leap Years](LeapYears.swift) — layered boolean conditions
3. [Calculate Stats](CalcStats.swift) — collections + error handling
4. [Closest to Zero](ClosestToZero.swift) — reduce + tie-breaking
5. [Fractions](Fractions.swift) — value types + GCD algorithm
6. [String Calculator](StringCalculator.swift) — recursive descent parsing

### Week 2 — Design Patterns
7. [Mars Rover](MarsRover.swift) — command pattern
8. [Tennis](Tennis.swift) — state representation
9. [Vending Machine](VendingMachine.swift) — multi-state machine
10. [Lift Button](LiftButton.swift) — pure FSM
11. [RPG Combat](RPGCombat.swift) — OOP + encapsulation
12. [Yatzy](Yatzy.swift) — enum dispatch

### Week 3 — Testability & Architecture
13. [Tire Pressure](TirePressure.swift) — dependency injection basics
14. [Birthday Greetings](BirthdayGreetings.swift) — ports & adapters
15. [Audit Everything](Audit.swift) — file I/O abstraction
16. [Trip Service](TripService.swift) — seam extraction from legacy code
17. [INSTAVOICED](Instavoiced.swift) — pipeline architecture

### Week 4 — Refactoring
18. [Gilded Rose](GildedRose.swift) — the classic refactoring kata
19. [Theatrical Players](TheatricalPlayers.swift) — Fowler's refactoring moves
20. [Bingo](Bingo.swift) — primitive obsession → value types

---

## Key Swift Patterns Used Across Katas

| Pattern | Katas That Use It |
|---------|------------------|
| `switch (bool, bool)` | FizzBuzz, Leap Years |
| Protocol injection | Tire Pressure, Birthday Greetings, Audit, Trip Service |
| Enum with associated values | Parse Args, Supermarket Receipt, Vending Machine |
| Value types (`struct`) | Fractions, Recently Used List, Mars Rover |
| `throws` / `try` | Calc Stats, Parse Args, Trip Service |
| `reduce` | Closest to Zero, Shopping Basket, Yatzy |
| `Set` for uniqueness | Office Cleaner, Recently Used List |
| Computed properties | Shopping Basket, Lift Button, GildedRose |
| Recursive descent | String Calculator |
| Spy/Stub test doubles | Birthday Greetings, Tire Pressure, Audit, Instavoiced |

---

## Resources

- [Samman Technical Coaching — Kata Descriptions](https://sammancoaching.org/kata_descriptions/)
- [Emily Bache's Kata Catalogue](https://github.com/emilybache)
- [Martin Fowler — Refactoring (2nd Edition)](https://martinfowler.com/books/refactoring.html)
- [Vladimir Khorikov — Unit Testing: Principles, Practices, and Patterns](https://www.manning.com/books/unit-testing)
- [Michael Feathers — Working Effectively with Legacy Code](https://www.oreilly.com/library/view/working-effectively-with/0131177052/)
