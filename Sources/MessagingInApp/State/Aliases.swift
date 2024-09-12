import CioInternalCommon
import Foundation
import ReSwift

// This file contains typealias for InAppMessage module which are used to decouple the module from ReSwift library
// by leveraging custom types. This allows for easier testing and swapping out the ReSwift library in the future.

// MARK: - Reducer

// Reducer function alias for InAppMessage store with custom defined types
typealias InAppMessageReducer = Reducer<InAppMessageState>

// MARK: - Middleware

// Middleware function alias for InAppMessage store with custom defined types
typealias InAppMessageMiddleware = Middleware<InAppMessageState>
/// Middleware completion closure
/// - Parameters:
///   - dispatch: Dispatch function to dispatch actions
///   - getState: Get the current state of the InAppMessage module from store, or return a default state
///   - next: Next middleware in the chain
///   - action: The action that is being dispatched
typealias MiddlewareCompletion = (
    @escaping (InAppMessageAction) -> Void,
    @escaping () -> InAppMessageState,
    @escaping (InAppMessageAction) -> Void,
    InAppMessageAction
) -> Void

/// Helper function to create middleware for InAppMessage module
/// - Parameter completion: A closure that takes in the necessary parameters to perform the middleware logic
/// - Returns: Middleware function with given completion closure
func middleware(
    completion: @escaping MiddlewareCompletion
) -> Middleware<InAppMessageState> {
    { dispatch, getState in { next in { action in
        guard let inAppAction = action as? InAppMessageAction else {
            DIGraphShared.shared.logger.logWithModuleTag("Invalid action type: \(action), skipping middleware", level: .debug)
            return next(action)
        }

        let getStateOrDefault = { getState() ?? InAppMessageState() }
        completion(dispatch, getStateOrDefault, next, inAppAction)
    }
    }
    }
}

// MARK: - StoreSubscriber

/// StoreSubscriber implementation for InAppMessage store with custom defined types
/// - Parameter stateHandler: Closure to handle new state
/// - Returns: InAppMessageStoreSubscriber instance
class InAppMessageStoreSubscriber: StoreSubscriber {
    typealias StoreSubscriberStateType = InAppMessageState

    private let stateHandler: (InAppMessageState) -> Void

    init(stateHandler: @escaping (InAppMessageState) -> Void) {
        self.stateHandler = stateHandler
    }

    func newState(state: InAppMessageState) {
        stateHandler(state)
    }
}