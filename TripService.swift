// Trip Service Kata
// https://sammancoaching.org/kata_descriptions/trip_service.html
//
// This is a REFACTORING kata by Sandro Mancuso.
// The original TripService has a hard dependency on a static UserSession,
// making it untestable. The goal: extract and override / inject dependencies
// so the logic can be tested without a real session.
//
// Rules:
//   - Return trips of a user IF the logged-in user is a friend of that user.
//   - If no user is logged in, throw NotLoggedInException.

// MARK: - Exceptions

struct NotLoggedInException: Error {}

// MARK: - Domain

struct User {
    let name:    String
    var friends: [User]  = []
    var trips:   [Trip]  = []

    mutating func addFriend(_ friend: User) { friends.append(friend) }
    mutating func addTrip(_ trip: Trip)     { trips.append(trip) }
}

struct Trip {
    let destination: String
}

// MARK: - Ports

protocol UserSession {
    func loggedInUser() throws -> User
}

protocol TripRepository {
    func findTripsBy(user: User) -> [Trip]
}

// MARK: - Service (refactored — dependencies injected)

struct TripService {
    private let session:    UserSession
    private let repository: TripRepository

    init(session: UserSession, repository: TripRepository) {
        self.session    = session
        self.repository = repository
    }

    func getFriendTrips(of user: User) throws -> [Trip] {
        let loggedInUser = try session.loggedInUser()

        guard user.friends.map(\.name).contains(loggedInUser.name) else {
            return []
        }

        return repository.findTripsBy(user: user)
    }
}

// MARK: - Stubs

struct StubUserSession: UserSession {
    private let user: User?
    init(loggedIn user: User?) { self.user = user }
    func loggedInUser() throws -> User {
        guard let user else { throw NotLoggedInException() }
        return user
    }
}

struct StubTripRepository: TripRepository {
    private let trips: [Trip]
    init(trips: [Trip]) { self.trips = trips }
    func findTripsBy(user: User) -> [Trip] { trips }
}

// MARK: - Test Helpers

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ label: String = "") {
    if actual == expected {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected \"\(expected)\", got \"\(actual)\"")
    }
}

func assertThrowsNotLoggedIn(_ block: () throws -> Any, _ label: String = "") {
    do {
        _ = try block()
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected NotLoggedInException but none thrown")
    } catch is NotLoggedInException {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } catch {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — wrong error: \(error)")
    }
}

// MARK: - Tests

func runTests() {
    let alice = User(name: "Alice")
    var bob   = User(name: "Bob")
    bob.addFriend(alice)
    bob.addTrip(Trip(destination: "Paris"))
    bob.addTrip(Trip(destination: "Tokyo"))

    let trips = [Trip(destination: "Paris"), Trip(destination: "Tokyo")]

    // Not logged in → throws
    let notLoggedIn = TripService(
        session:    StubUserSession(loggedIn: nil),
        repository: StubTripRepository(trips: trips)
    )
    assertThrowsNotLoggedIn({ try notLoggedIn.getFriendTrips(of: bob) }, "throws when not logged in")

    // Logged in but not a friend → empty
    var charlie = User(name: "Charlie")
    let notFriend = TripService(
        session:    StubUserSession(loggedIn: charlie),
        repository: StubTripRepository(trips: trips)
    )
    let noTrips = try! notFriend.getFriendTrips(of: bob)
    assertEqual(noTrips.count, 0, "no trips for non-friend")

    // Logged in as friend → returns trips
    let friend = TripService(
        session:    StubUserSession(loggedIn: alice),
        repository: StubTripRepository(trips: trips)
    )
    let friendTrips = try! friend.getFriendTrips(of: bob)
    assertEqual(friendTrips.count, 2, "friend sees all trips")
    assertEqual(friendTrips[0].destination, "Paris", "first trip")
    assertEqual(friendTrips[1].destination, "Tokyo", "second trip")
}

runTests()
