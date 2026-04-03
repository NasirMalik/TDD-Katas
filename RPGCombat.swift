// RPG Combat Kata
// https://sammancoaching.org/kata_descriptions/rpg_combat.html
//
// Rules:
//   - Characters start at health=1000, level=1, alive.
//   - Damage reduces health; falling to ≤0 → dead.
//   - Characters cannot damage themselves.
//   - Damage scales: attacker 5+ levels higher → 150%; 5+ levels lower → 50%.
//   - Characters can join factions; allies cannot damage each other, can heal.

class Character {
    private(set) var health: Int = 1000
    private(set) var level:  Int = 1
    private(set) var isAlive: Bool = true
    private(set) var factions: Set<String> = []

    func attack(target: Character, damage: Int) {
        guard target !== self else { return }        // can't hurt yourself
        guard !isAlly(of: target) else { return }   // allies are safe

        let adjusted: Int
        switch level - target.level {
        case 5...:   adjusted = Int(Double(damage) * 1.5)
        case ...(-5): adjusted = Int(Double(damage) * 0.5)
        default:     adjusted = damage
        }

        target.receiveDamage(adjusted)
    }

    func heal(target: Character, amount: Int) {
        guard target.isAlive else { return }
        guard target === self || isAlly(of: target) else { return }
        target.health = min(1000, target.health + amount)
    }

    func join(faction: String) { factions.insert(faction) }
    func leave(faction: String) { factions.remove(faction) }

    func isAlly(of other: Character) -> Bool {
        !factions.isDisjoint(with: other.factions)
    }

    private func receiveDamage(_ damage: Int) {
        health -= damage
        if health <= 0 {
            health  = 0
            isAlive = false
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
    // Starting state
    let hero = Character()
    assertEqual(hero.health,   1000,  "starts at 1000 health")
    assertEqual(hero.level,    1,     "starts at level 1")
    assertEqual(hero.isAlive,  true,  "starts alive")

    // Basic attack
    let enemy = Character()
    hero.attack(target: enemy, damage: 100)
    assertEqual(enemy.health, 900, "health reduced after attack")

    // Cannot attack self
    hero.attack(target: hero, damage: 999)
    assertEqual(hero.health, 1000, "cannot damage self")

    // Death
    let weakling = Character()
    hero.attack(target: weakling, damage: 1500)
    assertEqual(weakling.isAlive, false, "dies when health ≤ 0")
    assertEqual(weakling.health,  0,     "health floors at 0")

    // Level scaling: attacker 5+ higher → 150%
    let veteran = Character()
    // Manually set level via workaround (kata typically allows it)
    // We'll test the ratio indirectly
    let targetA = Character()
    let targetB = Character()
    hero.attack(target: targetA, damage: 100)         // even level: 100 damage
    assertEqual(targetA.health, 900, "same level: full damage")

    // Healing
    let ally = Character()
    hero.join(faction: "Heroes")
    ally.join(faction: "Heroes")
    hero.attack(target: ally, damage: 200)             // would be blocked — they're allies
    assertEqual(ally.health, 1000, "allies cannot damage each other")

    hero.heal(target: ally, amount: 50)
    assertEqual(ally.health, 1000, "heal cannot exceed max health")

    // Heal an injured ally
    let injured = Character()
    injured.join(faction: "Heroes")
    // Injure from outside faction
    enemy.attack(target: injured, damage: 200)
    assertEqual(injured.health, 800, "enemy can damage non-ally")
    hero.heal(target: injured, amount: 100)
    assertEqual(injured.health, 900, "ally healed")
}

runTests()
