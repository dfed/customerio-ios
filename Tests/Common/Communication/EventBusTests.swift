@testable import CioInternalCommon
import SharedTests
import XCTest

class EventBusTests: UnitTest {
    var eventBus: SharedEventBus!

    override func setUp() {
        super.setUp()
        eventBus = SharedEventBus()
    }

    override func tearDown() {
        eventBus = nil
        super.tearDown()
    }

    func testPostEventWithObserver() async throws {
        let exp = XCTestExpectation(description: "Event received")
        var notificationReceived = false
        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            notificationReceived = true
            exp.fulfill()
        }

        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        await fulfillment(of: [exp], timeout: 1)
        XCTAssertTrue(notificationReceived)
    }

    func testPostEventWithoutObserver() async {
        let event = ProfileIdentifiedEvent(identifier: "123")
        let hasObservers = await eventBus.post(event)
        XCTAssertFalse(hasObservers)
    }

    func testMultipleObserversForSameEvent() async {
        let exp1 = XCTestExpectation(description: "First observer received event")
        let exp2 = XCTestExpectation(description: "Second observer received event")

        var firstObserverNotified = false
        var secondObserverNotified = false

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            firstObserverNotified = true
            exp1.fulfill()
        }

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            secondObserverNotified = true
            exp2.fulfill()
        }

        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        await fulfillment(of: [exp1, exp2], timeout: 1)
        XCTAssertTrue(firstObserverNotified, "First observer should receive the event")
        XCTAssertTrue(secondObserverNotified, "Second observer should receive the event")
    }

    func testObserversForDifferentEventTypes() async {
        let exp1 = XCTestExpectation(description: "Observer for event type 1 receives event")
        let exp2 = XCTestExpectation(description: "Observer for event type 2 receives event")

        var observer1Notified = false
        var observer2Notified = false

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            observer1Notified = true
            exp1.fulfill()
        }

        await eventBus.addObserver(ScreenViewedEvent.key) { _ in
            observer2Notified = true
            exp2.fulfill()
        }

        let event1 = ProfileIdentifiedEvent(identifier: "123")
        let event2 = ScreenViewedEvent(name: "ABC")
        await eventBus.post(event1)
        await eventBus.post(event2)

        await fulfillment(of: [exp1, exp2], timeout: 1)
        XCTAssertTrue(observer1Notified, "Observer for ProfileIdentifiedEvent should be notified")
        XCTAssertTrue(observer2Notified, "Observer for ScreenViewedEvent should be notified")
    }

    func testMultipleObserversForSameEventType() async {
        let exp1 = XCTestExpectation(description: "First observer receives event")
        let exp2 = XCTestExpectation(description: "Second observer receives event")

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in exp1.fulfill() }
        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in exp2.fulfill() }

        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        await fulfillment(of: [exp1, exp2], timeout: 1)
    }

    func testRemovingSpecificObserver() async {
        let exp = XCTestExpectation(description: "Event received")
        exp.isInverted = true

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            exp.fulfill()
        }
        await eventBus.removeObserver(for: ProfileIdentifiedEvent.key)

        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        await fulfillment(of: [exp], timeout: 1)
    }

    func testObserverReceivingMultipleNotifications() async {
        let exp = XCTestExpectation(description: "Observer receives multiple events")
        exp.expectedFulfillmentCount = 2

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in exp.fulfill() }

        let event1 = ProfileIdentifiedEvent(identifier: "123")
        let event2 = ProfileIdentifiedEvent(identifier: "456")
        await eventBus.post(event1)
        await eventBus.post(event2)

        await fulfillment(of: [exp], timeout: 1)
    }

    func testRemovingAllObservers() async {
        let exp = XCTestExpectation(description: "Event received")
        exp.isInverted = true

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            exp.fulfill()
        }

        await eventBus.removeAllObservers()
        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        await fulfillment(of: [exp], timeout: 1)
    }

    func testObserverNotNotifiedAfterRemoval() async {
        let exp = XCTestExpectation(description: "Observer should not receive event")
        exp.isInverted = true

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            exp.fulfill()
        }
        await eventBus.removeObserver(for: ProfileIdentifiedEvent.key)

        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        await fulfillment(of: [exp], timeout: 1)
    }

    func testObserverOrderPreservation() async throws {
        var receivedEventsOrder: [String] = []

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            receivedEventsOrder.append("FirstObserver")
        }

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            receivedEventsOrder.append("SecondObserver")
        }

        let event = ProfileIdentifiedEvent(identifier: "123")
        await eventBus.post(event)

        XCTAssertEqual(receivedEventsOrder, ["FirstObserver", "SecondObserver"], "Observers should receive events in the order they were added")
    }

    func testAsynchronousEventPosting() async throws {
        let expectationCount = 10
        var expectations: [XCTestExpectation] = []

        for i in 1 ... expectationCount {
            let exp = XCTestExpectation(description: "Event \(i) received")
            expectations.append(exp)
            await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
                exp.fulfill()
            }
        }

        await withTaskGroup(of: Void.self) { group in
            for _ in 1 ... expectationCount {
                group.addTask {
                    let event = ProfileIdentifiedEvent(identifier: String.random)
                    await self.eventBus.post(event)
                }
            }
        }

        await fulfillment(of: expectations, timeout: 5)
    }

    func testThreadSafetyOfEventBus() async throws {
        let concurrentQueue = DispatchQueue(label: "test.concurrentQueue", attributes: .concurrent)
        let iterationCount = 100
        let resultHolder = ResultHolder(count: iterationCount)

        await eventBus.addObserver(ProfileIdentifiedEvent.key) { _ in
            // Observer action
        }

        DispatchQueue.concurrentPerform(iterations: iterationCount) { index in
            concurrentQueue.async {
                Task {
                    let event = ProfileIdentifiedEvent(identifier: "\(index)")
                    let postResult = await self.eventBus.post(event)
                    await resultHolder.updateResult(at: index, with: postResult)
                }
            }
        }

        // Give some time for all async tasks to complete
        try await Task.sleep(nanoseconds: 2000000000)

        // Verify results
        for index in 0 ..< iterationCount {
            let result = await resultHolder.results[index]
            XCTAssertTrue(result, "All events should be posted successfully in a thread-safe manner")
        }
    }
}
