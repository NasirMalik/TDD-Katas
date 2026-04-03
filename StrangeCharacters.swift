// Strange Characters Kata
// https://sammancoaching.org/kata_descriptions/strange_characters.html
//
// Rules:
//   A Character has: firstName, optional familyName, isMonster,
//                    optional nemesis, optional parent, children, siblings.
//   Implement: findByFirstName, findParent, findAllMonsters, findByFamilyName.

struct StrangeCharacter {
    let firstName:  String
    let familyName: String?
    let isMonster:  Bool
    var nemesis:    StrangeCharacter?
    var parent:     StrangeCharacter?
    var children:   [StrangeCharacter]
    var siblings:   [StrangeCharacter]

    init(firstName: String,
         familyName: String? = nil,
         isMonster: Bool = false) {
        self.firstName  = firstName
        self.familyName = familyName
        self.isMonster  = isMonster
        self.nemesis    = nil
        self.parent     = nil
        self.children   = []
        self.siblings   = []
    }
}

struct CharacterCatalog {
    private let characters: [StrangeCharacter]

    init(_ characters: [StrangeCharacter]) {
        self.characters = characters
    }

    func findByFirstName(_ name: String) -> StrangeCharacter? {
        characters.first { $0.firstName == name }
    }

    func findAllMonsters() -> [StrangeCharacter] {
        characters.filter { $0.isMonster }
    }

    func findByFamilyName(_ name: String) -> [StrangeCharacter] {
        characters.filter { $0.familyName == name }
    }

    func findParent(of firstName: String) -> StrangeCharacter? {
        guard let character = findByFirstName(firstName) else { return nil }
        return character.parent
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
    var dracula = StrangeCharacter(firstName: "Dracula", familyName: "Tepes", isMonster: true)
    var jonathan = StrangeCharacter(firstName: "Jonathan", familyName: "Harker", isMonster: false)
    var mina = StrangeCharacter(firstName: "Mina", familyName: "Harker", isMonster: false)
    var renfield = StrangeCharacter(firstName: "Renfield", isMonster: true)

    jonathan.parent = StrangeCharacter(firstName: "Thomas", familyName: "Harker")
    jonathan.siblings = [mina]
    dracula.nemesis   = jonathan

    let catalog = CharacterCatalog([dracula, jonathan, mina, renfield])

    // findByFirstName
    assertEqual(catalog.findByFirstName("Dracula")?.firstName, "Dracula", "find by first name")
    assertEqual(catalog.findByFirstName("Unknown"), nil, "not found returns nil")

    // findAllMonsters
    let monsters = catalog.findAllMonsters()
    assertEqual(monsters.count, 2, "two monsters found")
    assertEqual(monsters.map(\.firstName).contains("Dracula"),  true, "Dracula is a monster")
    assertEqual(monsters.map(\.firstName).contains("Renfield"), true, "Renfield is a monster")

    // findByFamilyName
    let harkers = catalog.findByFamilyName("Harker")
    assertEqual(harkers.count, 2, "two Harkers found")

    // findParent
    let jonathanParent = catalog.findParent(of: "Jonathan")
    assertEqual(jonathanParent?.firstName, "Thomas", "Jonathan's parent is Thomas")
    assertEqual(catalog.findParent(of: "Dracula"), nil, "Dracula has no recorded parent")
}

runTests()
