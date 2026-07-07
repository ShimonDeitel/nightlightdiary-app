import XCTest
@testable import Nightlightdiary

@MainActor
final class NightlightdiaryTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let before = store.entries.count
        let added = store.add(Entry(date: Date(), rating: 4, conditions: ["A"], note: "test"))
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddRespectsFreeLimit() {
        for _ in 0..<(Store.freeLimit + 5) {
            _ = store.add(Entry(date: Date(), rating: 4, conditions: ["A"], note: "test"))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testIsAtLimitBecomesTrue() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Entry(date: Date(), rating: 4, conditions: ["A"], note: "test"))
        }
        XCTAssertTrue(store.isAtLimit)
    }

    func testDeleteRemovesItem() {
        _ = store.add(Entry(date: Date(), rating: 4, conditions: ["A"], note: "test"))
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testAddBeyondLimitReturnsFalse() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Entry(date: Date(), rating: 4, conditions: ["A"], note: "test"))
        }
        let result = store.add(Entry(date: Date(), rating: 4, conditions: ["A"], note: "test"))
        XCTAssertFalse(result)
    }

    func testDeleteSpecificItem() {
        let item = Entry(date: Date(), rating: 4, conditions: ["A"], note: "test")
        _ = store.add(item)
        let before = store.entries.count
        store.delete(item)
        XCTAssertEqual(store.entries.count, before - 1)
    }
}
