// Birthday Greetings Kata
// https://sammancoaching.org/kata_descriptions/birthday_greetings.html
//
// Rules:
//   - Load friends from a data source (name, dob, email).
//   - On their birthday, send a greeting email.
//   - Feb 29 birthdays are greeted on Feb 28 in non-leap years.
//   - Data source and email sender are injected (protocol) for testability.

import Foundation

// MARK: - Domain

struct Friend {
    let firstName:  String
    let lastName:   String
    let dateOfBirth: DateComponents  // year/month/day
    let email:      String
}

struct Email {
    let to:      String
    let subject: String
    let body:    String
}

// MARK: - Ports (protocols for dependency injection)

protocol FriendRepository {
    func all() -> [Friend]
}

protocol EmailSender {
    func send(_ email: Email)
}

// MARK: - Use Case

struct BirthdayGreetings {
    private let repository: FriendRepository
    private let sender:     EmailSender

    init(repository: FriendRepository, sender: EmailSender) {
        self.repository = repository
        self.sender     = sender
    }

    func sendGreetings(on date: DateComponents) {
        let month = date.month!
        let day   = date.day!

        for friend in repository.all() {
            let dob = friend.dateOfBirth
            let birthdayMonth = dob.month!
            var birthdayDay   = dob.day!

            // Feb 29 → greet on Feb 28 in non-leap years
            if birthdayMonth == 2 && birthdayDay == 29 && !isLeapYear(date.year!) {
                birthdayDay = 28
            }

            if birthdayMonth == month && birthdayDay == day {
                sender.send(Email(
                    to:      friend.email,
                    subject: "Happy birthday!",
                    body:    "Happy birthday, dear \(friend.firstName)!"
                ))
            }
        }
    }

    private func isLeapYear(_ year: Int) -> Bool {
        (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)
    }
}

// MARK: - Stubs

class InMemoryFriendRepository: FriendRepository {
    private let friends: [Friend]
    init(_ friends: [Friend]) { self.friends = friends }
    func all() -> [Friend] { friends }
}

class SpyEmailSender: EmailSender {
    private(set) var sent: [Email] = []
    func send(_ email: Email) { sent.append(email) }
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
    let alice = Friend(firstName: "Alice", lastName: "Smith",
                       dateOfBirth: DateComponents(year: 1990, month: 4, day: 3),
                       email: "alice@example.com")
    let bob   = Friend(firstName: "Bob", lastName: "Jones",
                       dateOfBirth: DateComponents(year: 1985, month: 6, day: 15),
                       email: "bob@example.com")
    let carol = Friend(firstName: "Carol", lastName: "Lee",
                       dateOfBirth: DateComponents(year: 1992, month: 2, day: 29),
                       email: "carol@example.com")

    let repo   = InMemoryFriendRepository([alice, bob, carol])
    let mailer = SpyEmailSender()
    let service = BirthdayGreetings(repository: repo, sender: mailer)

    // Alice's birthday: April 3
    service.sendGreetings(on: DateComponents(year: 2026, month: 4, day: 3))
    assertEqual(mailer.sent.count, 1, "one greeting sent on Alice's birthday")
    assertEqual(mailer.sent[0].to, "alice@example.com", "sent to Alice")
    assertEqual(mailer.sent[0].subject, "Happy birthday!", "correct subject")
    assertEqual(mailer.sent[0].body.contains("Alice"), true, "body contains first name")

    // No birthdays on a random day
    let mailer2 = SpyEmailSender()
    let service2 = BirthdayGreetings(repository: repo, sender: mailer2)
    service2.sendGreetings(on: DateComponents(year: 2026, month: 1, day: 1))
    assertEqual(mailer2.sent.count, 0, "no greetings on a day with no birthdays")

    // Feb 29 birthday → greeted on Feb 28 in non-leap year (2026)
    let mailer3 = SpyEmailSender()
    let service3 = BirthdayGreetings(repository: repo, sender: mailer3)
    service3.sendGreetings(on: DateComponents(year: 2026, month: 2, day: 28))
    assertEqual(mailer3.sent.count, 1, "Carol greeted on Feb 28 in non-leap year")
    assertEqual(mailer3.sent[0].to, "carol@example.com", "sent to Carol")

    // In a leap year, Carol is greeted on Feb 29 (not Feb 28)
    let mailer4 = SpyEmailSender()
    let service4 = BirthdayGreetings(repository: repo, sender: mailer4)
    service4.sendGreetings(on: DateComponents(year: 2028, month: 2, day: 28))
    assertEqual(mailer4.sent.count, 0, "Carol NOT greeted on Feb 28 in leap year")

    service4.sendGreetings(on: DateComponents(year: 2028, month: 2, day: 29))
    assertEqual(mailer4.sent.count, 1, "Carol greeted on Feb 29 in leap year")
}

runTests()
