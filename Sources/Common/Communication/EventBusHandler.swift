import Combine
import Foundation

/// `EventBusHandler` acts as a central hub for managing events in the application.
/// It interfaces with both an event bus for real-time event handling and an event storage system for persisting events.
// sourcery: InjectRegisterShared = "EventBusHandler"
// sourcery: InjectSingleton
public class EventBusHandler {
    private let eventBus: EventBus
    private let eventCache: EventCache
    private let eventStorage: EventStorage
    private let logger: Logger

    /// Initializes the EventBusHandler with dependencies for event bus and storage.
    /// - Parameters:
    ///   - eventBus: An instance of EventBus to handle event posting and observer management.
    ///   - eventStorage: An instance of EventStorage to manage event persistence.
    ///   - logger: A logger for logging information and errors.
    /// Automatically loads events from file-based storage into in-memory storage upon initialization.
    public init(
        eventBus: EventBus,
        eventCache: EventCache,
        eventStorage: EventStorage,
        logger: Logger
    ) {
        self.eventBus = eventBus
        self.eventCache = eventCache
        self.eventStorage = eventStorage
        self.logger = logger
        Task { await loadEventsFromStorage() }
    }

    /// Loads events from persistent storage into in-memory storage for quick access and event replay.
    public func loadEventsFromStorage() async {
        for eventType in EventTypesRegistry.allEventTypes() {
            do {
                let key = eventType.key
                let events: [AnyEventRepresentable] = try await eventStorage.loadEvents(ofType: key)
                await eventCache.storeEvents(events, forKey: key)
            } catch {
                logger.debug("Error loading events for \(eventType): \(error)")
            }
        }
    }

    /// Adds an observer for a specific event type and replays any stored events of that type to the new observer.
    /// - Parameters:
    ///   - eventType: The event type to observe.
    ///   - action: The action to execute when the event is observed.
    public func addObserver<E: EventRepresentable>(_ eventType: E.Type, action: @escaping (E) -> Void) {
        logger.debug("EventBusHandler: Adding observer for event type - \(eventType)")

        let adaptedAction: (AnyEventRepresentable) -> Void = { event in
            if let specificEvent = event as? E {
                action(specificEvent)
            } else {
                self.logger.debug("Error: Event type did not match")
            }
        }

        Task {
            await eventBus.addObserver(eventType.key, action: adaptedAction)
            await replayEvents(forType: eventType, action: adaptedAction)
        }
    }

    /// Removes an observer for a specific event type.
    /// - Parameter eventType: The event type for which to remove the observer.
    public func removeObserver<E: EventRepresentable>(for eventType: E.Type) {
        Task { await eventBus.removeObserver(for: E.key) }
    }

    /// Replays events of a specific type to any new observers, ensuring they receive past events.
    /// - Parameter eventType: The event type for which to replay events.
    private func replayEvents<E: EventRepresentable>(forType eventType: E.Type, action: @escaping (AnyEventRepresentable) -> Void) async {
        let key = eventType.key
        logger.debug("Replaying events for key: \(key)")
        let storedEvents = await eventCache.getEvent(key)

        for event in storedEvents {
            logger.debug("Found stored events for key: \(key)")
            if let specificEvent = event as? E {
                logger.debug("EventBusHandler: Replaying event type - \(specificEvent)")
                action(specificEvent)
                await removeFromStorage(specificEvent)
            }
        }
    }

    /// Posts an event to the EventBus and stores it if there are no observers.
    /// - Parameter event: The event to post.
    public func postEvent<E: EventRepresentable>(_ event: E) {
        logger.debug("EventBusHandler: Posting event - \(event)")
        Task {
            let hasObservers = await eventBus.post(event)
            await eventCache.addEvent(event: event)
            if !hasObservers {
                logger.debug("EventBusHandler: Storing event in memory - \(event)")
                await storeEvent(event)
            }
        }
    }

    /// Stores an event in persistent storage.
    /// - Parameter event: The event to store.
    private func storeEvent<E: EventRepresentable>(_ event: E) async {
        do {
            try await eventStorage.store(event: event)
        } catch {
            logger.debug("Error storing event: \(error)")
        }
    }

    /// Removes an event from persistent storage.
    /// - Parameter event: The event to remove.
    public func removeFromStorage<E: EventRepresentable>(_ event: E) async {
        await eventStorage.remove(ofType: event.key, withStorageId: event.storageId)
    }
}