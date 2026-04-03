// Gilded Rose Refactoring Kata
// https://sammancoaching.org/kata_descriptions/gilded_rose.html
//
// This is a REFACTORING kata. The starting point is deliberately messy legacy code.
// Your goal: add the "Conjured" item type (degrades twice as fast) while
// refactoring the updateQuality() method to be clean and extensible.
//
// Original rules:
//   - All items have a sellIn (days to sell) and quality (0-50).
//   - Quality degrades by 1 per day; after sellIn passes, by 2.
//   - "Aged Brie" increases in quality as it ages.
//   - "Sulfuras" never changes (quality stays at 80, sellIn unchanged).
//   - "Backstage passes" increase in quality; drop to 0 after concert.
//   - "Conjured" items degrade twice as fast as normal items.

// MARK: - Domain (refactored)

struct Item {
    let name:    String
    var sellIn:  Int
    var quality: Int
}

struct GildedRose {
    var items: [Item]

    mutating func updateQuality() {
        items = items.map { updateItem($0) }
    }

    private func updateItem(_ item: Item) -> Item {
        var item = item

        switch item.name {
        case "Sulfuras, Hand of Ragnaros":
            return item  // legendary — never changes

        case "Aged Brie":
            item.sellIn  -= 1
            item.quality += item.sellIn < 0 ? 2 : 1

        case "Backstage passes to a TAFKAL80ETC concert":
            item.sellIn -= 1
            if item.sellIn < 0 {
                item.quality = 0
            } else if item.sellIn < 5 {
                item.quality += 3
            } else if item.sellIn < 10 {
                item.quality += 2
            } else {
                item.quality += 1
            }

        case let name where name.hasPrefix("Conjured"):
            item.sellIn  -= 1
            item.quality -= item.sellIn < 0 ? 4 : 2

        default:
            item.sellIn  -= 1
            item.quality -= item.sellIn < 0 ? 2 : 1
        }

        item.quality = max(0, min(50, item.quality))
        return item
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
    // Normal item
    var rose = GildedRose(items: [Item(name: "Dexterity Vest", sellIn: 10, quality: 20)])
    rose.updateQuality()
    assertEqual(rose.items[0].sellIn,  9,  "normal: sellIn decrements")
    assertEqual(rose.items[0].quality, 19, "normal: quality decrements")

    // Quality never negative
    var cheap = GildedRose(items: [Item(name: "Elixir", sellIn: 1, quality: 0)])
    cheap.updateQuality()
    assertEqual(cheap.items[0].quality, 0, "quality never negative")

    // Aged Brie increases in quality
    var brie = GildedRose(items: [Item(name: "Aged Brie", sellIn: 2, quality: 0)])
    brie.updateQuality()
    assertEqual(brie.items[0].quality, 1, "Aged Brie increases")

    // Quality never exceeds 50
    var maxBrie = GildedRose(items: [Item(name: "Aged Brie", sellIn: 2, quality: 50)])
    maxBrie.updateQuality()
    assertEqual(maxBrie.items[0].quality, 50, "quality max is 50")

    // Sulfuras — never changes
    var sulfuras = GildedRose(items: [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80)])
    sulfuras.updateQuality()
    assertEqual(sulfuras.items[0].quality, 80, "Sulfuras quality unchanged")
    assertEqual(sulfuras.items[0].sellIn,   0, "Sulfuras sellIn unchanged")

    // Backstage passes
    var pass = GildedRose(items: [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: 20)])
    pass.updateQuality()
    assertEqual(pass.items[0].quality, 21, "backstage: +1 more than 10 days out")

    var passNear = GildedRose(items: [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 6, quality: 20)])
    passNear.updateQuality()
    assertEqual(passNear.items[0].quality, 22, "backstage: +2 within 10 days")

    var passClose = GildedRose(items: [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 2, quality: 20)])
    passClose.updateQuality()
    assertEqual(passClose.items[0].quality, 23, "backstage: +3 within 5 days")

    var passExpired = GildedRose(items: [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 20)])
    passExpired.updateQuality()
    assertEqual(passExpired.items[0].quality, 0, "backstage: 0 after concert")

    // Conjured — degrades twice as fast
    var conjured = GildedRose(items: [Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6)])
    conjured.updateQuality()
    assertEqual(conjured.items[0].quality, 4, "Conjured degrades by 2")
}

runTests()
