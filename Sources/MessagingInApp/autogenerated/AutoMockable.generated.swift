// Generated using Sourcery 2.0.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(UserNotifications)
import UserNotifications
#endif
import CioInternalCommon
import UIKit

/**
 ######################################################
 Documentation
 ######################################################

 This automatically generated file you are viewing contains mock classes that you can use in your test suite.

 * How do you generate a new mock class?

 1. Mocks are generated from Swift protocols. So, you must make one.

 ```
 protocol FriendsRepository {
     func acceptFriendRequest<Attributes: Encodable>(attributes: Attributes, _ onComplete: @escaping () -> Void)
 }

 class AppFriendsRepository: FriendsRepository {
     ...
 }
 ```

 2. Have your new protocol extend `AutoMockable`:

 ```
 protocol FriendsRepository: AutoMockable {
     func acceptFriendRequest<Attributes: Encodable>(
         // sourcery:Type=Encodable
         attributes: Attributes,
         _ onComplete: @escaping () -> Void)
 }
 ```

 > Notice the use of `// sourcery:Type=Encodable` for the generic type parameter. Without this, the mock would
 fail to compile: `functionNameReceiveArguments = (Attributes)` because `Attributes` is unknown to this `var`.
 Instead, we give the parameter a different type to use for the mock. `Encodable` works in this case.
 It will require a cast in the test function code, however.

 3. Run the command `make generate` on your machine. The new mock should be added to this file.

 * How do you use the mocks in your test class?

 ```
 class ExampleViewModelTest: XCTestCase {
     var viewModel: ExampleViewModel!
     var exampleRepositoryMock: ExampleRepositoryMock!
     override func setUp() {
         exampleRepositoryMock = ExampleRepositoryMock()
         viewModel = AppExampleViewModel(exampleRepository: exampleRepositoryMock)
     }
 }
 ```

 Or, you may need to inject the mock in a different way using the DI.shared graph:

 ```
 class ExampleTest: XCTestCase {
     var exampleViewModelMock: ExampleViewModelMock!
     var example: Example!
     override func setUp() {
         exampleViewModelMock = ExampleViewModelMock()
         DI.shared.override(.exampleViewModel, value: exampleViewModelMock, forType: ExampleViewModel.self)
         example = Example()
     }
 }

 ```

 */

/**
 Class to easily create a mocked version of the `EngineWebInstance` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
class EngineWebInstanceMock: EngineWebInstance, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    var mockCalled: Bool = false //

    init() {
        Mocks.shared.add(mock: self)
    }

    /**
     When setter of the property called, the value given to setter is set here.
     When the getter of the property called, the value set here will be returned. Your chance to mock the property.
     */
    var underlyingDelegate: EngineWebDelegate? = nil
    /// `true` if the getter or setter of property is called at least once.
    var delegateCalled: Bool {
        delegateGetCalled || delegateSetCalled
    }

    /// `true` if the getter called on the property at least once.
    var delegateGetCalled: Bool {
        delegateGetCallsCount > 0
    }

    var delegateGetCallsCount = 0
    /// `true` if the setter called on the property at least once.
    var delegateSetCalled: Bool {
        delegateSetCallsCount > 0
    }

    var delegateSetCallsCount = 0
    /// The mocked property with a getter and setter.
    var delegate: EngineWebDelegate? {
        get {
            mockCalled = true
            delegateGetCallsCount += 1
            return underlyingDelegate
        }
        set(value) {
            mockCalled = true
            delegateSetCallsCount += 1
            underlyingDelegate = value
        }
    }

    /**
     When setter of the property called, the value given to setter is set here.
     When the getter of the property called, the value set here will be returned. Your chance to mock the property.
     */
    var underlyingView: UIView!
    /// `true` if the getter or setter of property is called at least once.
    var viewCalled: Bool {
        viewGetCalled || viewSetCalled
    }

    /// `true` if the getter called on the property at least once.
    var viewGetCalled: Bool {
        viewGetCallsCount > 0
    }

    var viewGetCallsCount = 0
    /// `true` if the setter called on the property at least once.
    var viewSetCalled: Bool {
        viewSetCallsCount > 0
    }

    var viewSetCallsCount = 0
    /// The mocked property with a getter and setter.
    var view: UIView {
        get {
            mockCalled = true
            viewGetCallsCount += 1
            return underlyingView
        }
        set(value) {
            mockCalled = true
            viewSetCallsCount += 1
            underlyingView = value
        }
    }

    public func resetMock() {
        delegate = nil
        delegateGetCallsCount = 0
        delegateSetCallsCount = 0
        viewGetCallsCount = 0
        viewSetCallsCount = 0
        cleanEngineWebCallsCount = 0

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - cleanEngineWeb

    /// Number of times the function was called.
    @Atomic private(set) var cleanEngineWebCallsCount = 0
    /// `true` if the function was ever called.
    var cleanEngineWebCalled: Bool {
        cleanEngineWebCallsCount > 0
    }

    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var cleanEngineWebClosure: (() -> Void)?

    /// Mocked function for `cleanEngineWeb()`. Your opportunity to return a mocked value and check result of mock in test code.
    func cleanEngineWeb() {
        mockCalled = true
        cleanEngineWebCallsCount += 1
        cleanEngineWebClosure?()
    }
}

/**
 Class to easily create a mocked version of the `GistProvider` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
class GistProviderMock: GistProvider, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    var mockCalled: Bool = false //

    init() {
        Mocks.shared.add(mock: self)
    }

    public func resetMock() {
        setUserTokenCallsCount = 0
        setUserTokenReceivedArguments = nil
        setUserTokenReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        setCurrentRouteCallsCount = 0
        setCurrentRouteReceivedArguments = nil
        setCurrentRouteReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        resetStateCallsCount = 0

        mockCalled = false // do last as resetting properties above can make this true
        setEventListenerCallsCount = 0
        setEventListenerReceivedArguments = nil
        setEventListenerReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        dismissMessageCallsCount = 0

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - setUserToken

    /// Number of times the function was called.
    @Atomic private(set) var setUserTokenCallsCount = 0
    /// `true` if the function was ever called.
    var setUserTokenCalled: Bool {
        setUserTokenCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var setUserTokenReceivedArguments: String?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var setUserTokenReceivedInvocations: [String] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var setUserTokenClosure: ((String) -> Void)?

    /// Mocked function for `setUserToken(_ userToken: String)`. Your opportunity to return a mocked value and check result of mock in test code.
    func setUserToken(_ userToken: String) {
        mockCalled = true
        setUserTokenCallsCount += 1
        setUserTokenReceivedArguments = userToken
        setUserTokenReceivedInvocations.append(userToken)
        setUserTokenClosure?(userToken)
    }

    // MARK: - setCurrentRoute

    /// Number of times the function was called.
    @Atomic private(set) var setCurrentRouteCallsCount = 0
    /// `true` if the function was ever called.
    var setCurrentRouteCalled: Bool {
        setCurrentRouteCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var setCurrentRouteReceivedArguments: String?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var setCurrentRouteReceivedInvocations: [String] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var setCurrentRouteClosure: ((String) -> Void)?

    /// Mocked function for `setCurrentRoute(_ currentRoute: String)`. Your opportunity to return a mocked value and check result of mock in test code.
    func setCurrentRoute(_ currentRoute: String) {
        mockCalled = true
        setCurrentRouteCallsCount += 1
        setCurrentRouteReceivedArguments = currentRoute
        setCurrentRouteReceivedInvocations.append(currentRoute)
        setCurrentRouteClosure?(currentRoute)
    }

    // MARK: - resetState

    /// Number of times the function was called.
    @Atomic private(set) var resetStateCallsCount = 0
    /// `true` if the function was ever called.
    var resetStateCalled: Bool {
        resetStateCallsCount > 0
    }

    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var resetStateClosure: (() -> Void)?

    /// Mocked function for `resetState()`. Your opportunity to return a mocked value and check result of mock in test code.
    func resetState() {
        mockCalled = true
        resetStateCallsCount += 1
        resetStateClosure?()
    }

    // MARK: - setEventListener

    /// Number of times the function was called.
    @Atomic private(set) var setEventListenerCallsCount = 0
    /// `true` if the function was ever called.
    var setEventListenerCalled: Bool {
        setEventListenerCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var setEventListenerReceivedArguments: InAppEventListener??
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var setEventListenerReceivedInvocations: [InAppEventListener?] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var setEventListenerClosure: ((InAppEventListener?) -> Void)?

    /// Mocked function for `setEventListener(_ eventListener: InAppEventListener?)`. Your opportunity to return a mocked value and check result of mock in test code.
    func setEventListener(_ eventListener: InAppEventListener?) {
        mockCalled = true
        setEventListenerCallsCount += 1
        setEventListenerReceivedArguments = eventListener
        setEventListenerReceivedInvocations.append(eventListener)
        setEventListenerClosure?(eventListener)
    }

    // MARK: - dismissMessage

    /// Number of times the function was called.
    @Atomic private(set) var dismissMessageCallsCount = 0
    /// `true` if the function was ever called.
    var dismissMessageCalled: Bool {
        dismissMessageCallsCount > 0
    }

    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var dismissMessageClosure: (() -> Void)?

    /// Mocked function for `dismissMessage()`. Your opportunity to return a mocked value and check result of mock in test code.
    func dismissMessage() {
        mockCalled = true
        dismissMessageCallsCount += 1
        dismissMessageClosure?()
    }
}

/**
 Class to easily create a mocked version of the `GistQueueNetwork` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
class GistQueueNetworkMock: GistQueueNetwork, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    var mockCalled: Bool = false //

    init() {
        Mocks.shared.add(mock: self)
    }

    public func resetMock() {
        requestCallsCount = 0
        requestReceivedArguments = nil
        requestReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - request

    var requestThrowableError: Error?
    /// Number of times the function was called.
    @Atomic private(set) var requestCallsCount = 0
    /// `true` if the function was ever called.
    var requestCalled: Bool {
        requestCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var requestReceivedArguments: (state: InAppMessageState, request: GistNetworkRequest, completionHandler: (Result<GistNetworkResponse, Error>) -> Void)?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var requestReceivedInvocations: [(state: InAppMessageState, request: GistNetworkRequest, completionHandler: (Result<GistNetworkResponse, Error>) -> Void)] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var requestClosure: ((InAppMessageState, GistNetworkRequest, @escaping (Result<GistNetworkResponse, Error>) -> Void) throws -> Void)?

    /// Mocked function for `request(state: InAppMessageState, request: GistNetworkRequest, completionHandler: @escaping (Result<GistNetworkResponse, Error>) -> Void)`. Your opportunity to return a mocked value and check result of mock in test code.
    func request(state: InAppMessageState, request: GistNetworkRequest, completionHandler: @escaping (Result<GistNetworkResponse, Error>) -> Void) throws {
        if let error = requestThrowableError {
            throw error
        }
        mockCalled = true
        requestCallsCount += 1
        requestReceivedArguments = (state: state, request: request, completionHandler: completionHandler)
        requestReceivedInvocations.append((state: state, request: request, completionHandler: completionHandler))
        try requestClosure?(state, request, completionHandler)
    }
}

/**
 Class to easily create a mocked version of the `InAppEventListener` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
public class InAppEventListenerMock: InAppEventListener, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    public var mockCalled: Bool = false //

    public init() {
        Mocks.shared.add(mock: self)
    }

    public func resetMock() {
        messageShownCallsCount = 0
        messageShownReceivedArguments = nil
        messageShownReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        messageDismissedCallsCount = 0
        messageDismissedReceivedArguments = nil
        messageDismissedReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        errorWithMessageCallsCount = 0
        errorWithMessageReceivedArguments = nil
        errorWithMessageReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        messageActionTakenCallsCount = 0
        messageActionTakenReceivedArguments = nil
        messageActionTakenReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - messageShown

    /// Number of times the function was called.
    @Atomic public private(set) var messageShownCallsCount = 0
    /// `true` if the function was ever called.
    public var messageShownCalled: Bool {
        messageShownCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic public private(set) var messageShownReceivedArguments: InAppMessage?
    /// Arguments from *all* of the times that the function was called.
    @Atomic public private(set) var messageShownReceivedInvocations: [InAppMessage] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    public var messageShownClosure: ((InAppMessage) -> Void)?

    /// Mocked function for `messageShown(message: InAppMessage)`. Your opportunity to return a mocked value and check result of mock in test code.
    public func messageShown(message: InAppMessage) {
        mockCalled = true
        messageShownCallsCount += 1
        messageShownReceivedArguments = message
        messageShownReceivedInvocations.append(message)
        messageShownClosure?(message)
    }

    // MARK: - messageDismissed

    /// Number of times the function was called.
    @Atomic public private(set) var messageDismissedCallsCount = 0
    /// `true` if the function was ever called.
    public var messageDismissedCalled: Bool {
        messageDismissedCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic public private(set) var messageDismissedReceivedArguments: InAppMessage?
    /// Arguments from *all* of the times that the function was called.
    @Atomic public private(set) var messageDismissedReceivedInvocations: [InAppMessage] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    public var messageDismissedClosure: ((InAppMessage) -> Void)?

    /// Mocked function for `messageDismissed(message: InAppMessage)`. Your opportunity to return a mocked value and check result of mock in test code.
    public func messageDismissed(message: InAppMessage) {
        mockCalled = true
        messageDismissedCallsCount += 1
        messageDismissedReceivedArguments = message
        messageDismissedReceivedInvocations.append(message)
        messageDismissedClosure?(message)
    }

    // MARK: - errorWithMessage

    /// Number of times the function was called.
    @Atomic public private(set) var errorWithMessageCallsCount = 0
    /// `true` if the function was ever called.
    public var errorWithMessageCalled: Bool {
        errorWithMessageCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic public private(set) var errorWithMessageReceivedArguments: InAppMessage?
    /// Arguments from *all* of the times that the function was called.
    @Atomic public private(set) var errorWithMessageReceivedInvocations: [InAppMessage] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    public var errorWithMessageClosure: ((InAppMessage) -> Void)?

    /// Mocked function for `errorWithMessage(message: InAppMessage)`. Your opportunity to return a mocked value and check result of mock in test code.
    public func errorWithMessage(message: InAppMessage) {
        mockCalled = true
        errorWithMessageCallsCount += 1
        errorWithMessageReceivedArguments = message
        errorWithMessageReceivedInvocations.append(message)
        errorWithMessageClosure?(message)
    }

    // MARK: - messageActionTaken

    /// Number of times the function was called.
    @Atomic public private(set) var messageActionTakenCallsCount = 0
    /// `true` if the function was ever called.
    public var messageActionTakenCalled: Bool {
        messageActionTakenCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic public private(set) var messageActionTakenReceivedArguments: (message: InAppMessage, actionValue: String, actionName: String)?
    /// Arguments from *all* of the times that the function was called.
    @Atomic public private(set) var messageActionTakenReceivedInvocations: [(message: InAppMessage, actionValue: String, actionName: String)] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    public var messageActionTakenClosure: ((InAppMessage, String, String) -> Void)?

    /// Mocked function for `messageActionTaken(message: InAppMessage, actionValue: String, actionName: String)`. Your opportunity to return a mocked value and check result of mock in test code.
    public func messageActionTaken(message: InAppMessage, actionValue: String, actionName: String) {
        mockCalled = true
        messageActionTakenCallsCount += 1
        messageActionTakenReceivedArguments = (message: message, actionValue: actionValue, actionName: actionName)
        messageActionTakenReceivedInvocations.append((message: message, actionValue: actionValue, actionName: actionName))
        messageActionTakenClosure?(message, actionValue, actionName)
    }
}

/**
 Class to easily create a mocked version of the `InAppMessageManager` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
class InAppMessageManagerMock: InAppMessageManager, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    var mockCalled: Bool = false //

    init() {
        Mocks.shared.add(mock: self)
    }

    /**
     When setter of the property called, the value given to setter is set here.
     When the getter of the property called, the value set here will be returned. Your chance to mock the property.
     */
    var underlyingState: InAppMessageState!
    /// `true` if the getter or setter of property is called at least once.
    var stateCalled: Bool {
        stateGetCalled || stateSetCalled
    }

    /// `true` if the getter called on the property at least once.
    var stateGetCalled: Bool {
        stateGetCallsCount > 0
    }

    var stateGetCallsCount = 0
    /// `true` if the setter called on the property at least once.
    var stateSetCalled: Bool {
        stateSetCallsCount > 0
    }

    var stateSetCallsCount = 0
    /// The mocked property with a getter and setter.
    var state: InAppMessageState {
        get {
            mockCalled = true
            stateGetCallsCount += 1
            return underlyingState
        }
        set(value) {
            mockCalled = true
            stateSetCallsCount += 1
            underlyingState = value
        }
    }

    public func resetMock() {
        stateGetCallsCount = 0
        stateSetCallsCount = 0
        fetchStateCallsCount = 0
        fetchStateReceivedArguments = nil
        fetchStateReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        dispatchCallsCount = 0
        dispatchReceivedArguments = nil
        dispatchReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        unsubscribeCallsCount = 0
        unsubscribeReceivedArguments = nil
        unsubscribeReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        subscribeCallsCount = 0
        subscribeReceivedArguments = nil
        subscribeReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - fetchState

    /// Number of times the function was called.
    @Atomic private(set) var fetchStateCallsCount = 0
    /// `true` if the function was ever called.
    var fetchStateCalled: Bool {
        fetchStateCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var fetchStateReceivedArguments: ((InAppMessageState) -> Void)?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var fetchStateReceivedInvocations: [(InAppMessageState) -> Void] = []
    /// Value to return from the mocked function.
    var fetchStateReturnValue: Task<InAppMessageState, Never>!
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     The closure has first priority to return a value for the mocked function. If the closure returns `nil`,
     then the mock will attempt to return the value for `fetchStateReturnValue`
     */
    var fetchStateClosure: ((@escaping (InAppMessageState) -> Void) -> Task<InAppMessageState, Never>)?

    /// Mocked function for `fetchState(_ completion: @escaping (InAppMessageState) -> Void)`. Your opportunity to return a mocked value and check result of mock in test code.
    @discardableResult
    func fetchState(_ completion: @escaping (InAppMessageState) -> Void) -> Task<InAppMessageState, Never> {
        mockCalled = true
        fetchStateCallsCount += 1
        fetchStateReceivedArguments = completion
        fetchStateReceivedInvocations.append(completion)
        return fetchStateClosure.map { $0(completion) } ?? fetchStateReturnValue
    }

    // MARK: - dispatch

    /// Number of times the function was called.
    @Atomic private(set) var dispatchCallsCount = 0
    /// `true` if the function was ever called.
    var dispatchCalled: Bool {
        dispatchCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var dispatchReceivedArguments: (action: InAppMessageAction, completion: (() -> Void)?)?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var dispatchReceivedInvocations: [(action: InAppMessageAction, completion: (() -> Void)?)] = []
    /// Value to return from the mocked function.
    var dispatchReturnValue: Task<Void, Never>!
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     The closure has first priority to return a value for the mocked function. If the closure returns `nil`,
     then the mock will attempt to return the value for `dispatchReturnValue`
     */
    var dispatchClosure: ((InAppMessageAction, (() -> Void)?) -> Task<Void, Never>)?

    /// Mocked function for `dispatch(action: InAppMessageAction, completion: (() -> Void)?)`. Your opportunity to return a mocked value and check result of mock in test code.
    @discardableResult
    func dispatch(action: InAppMessageAction, completion: (() -> Void)?) -> Task<Void, Never> {
        mockCalled = true
        dispatchCallsCount += 1
        dispatchReceivedArguments = (action: action, completion: completion)
        dispatchReceivedInvocations.append((action: action, completion: completion))
        return dispatchClosure.map { $0(action, completion) } ?? dispatchReturnValue
    }

    // MARK: - unsubscribe

    /// Number of times the function was called.
    @Atomic private(set) var unsubscribeCallsCount = 0
    /// `true` if the function was ever called.
    var unsubscribeCalled: Bool {
        unsubscribeCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var unsubscribeReceivedArguments: InAppMessageStoreSubscriber?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var unsubscribeReceivedInvocations: [InAppMessageStoreSubscriber] = []
    /// Value to return from the mocked function.
    var unsubscribeReturnValue: Task<Void, Never>!
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     The closure has first priority to return a value for the mocked function. If the closure returns `nil`,
     then the mock will attempt to return the value for `unsubscribeReturnValue`
     */
    var unsubscribeClosure: ((InAppMessageStoreSubscriber) -> Task<Void, Never>)?

    /// Mocked function for `unsubscribe(subscriber: InAppMessageStoreSubscriber)`. Your opportunity to return a mocked value and check result of mock in test code.
    @discardableResult
    func unsubscribe(subscriber: InAppMessageStoreSubscriber) -> Task<Void, Never> {
        mockCalled = true
        unsubscribeCallsCount += 1
        unsubscribeReceivedArguments = subscriber
        unsubscribeReceivedInvocations.append(subscriber)
        return unsubscribeClosure.map { $0(subscriber) } ?? unsubscribeReturnValue
    }

    // MARK: - subscribe

    /// Number of times the function was called.
    @Atomic private(set) var subscribeCallsCount = 0
    /// `true` if the function was ever called.
    var subscribeCalled: Bool {
        subscribeCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var subscribeReceivedArguments: (comparator: (InAppMessageState, InAppMessageState) -> Bool, subscriber: InAppMessageStoreSubscriber)?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var subscribeReceivedInvocations: [(comparator: (InAppMessageState, InAppMessageState) -> Bool, subscriber: InAppMessageStoreSubscriber)] = []
    /// Value to return from the mocked function.
    var subscribeReturnValue: Task<Void, Never>!
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     The closure has first priority to return a value for the mocked function. If the closure returns `nil`,
     then the mock will attempt to return the value for `subscribeReturnValue`
     */
    var subscribeClosure: ((@escaping (InAppMessageState, InAppMessageState) -> Bool, InAppMessageStoreSubscriber) -> Task<Void, Never>)?

    /// Mocked function for `subscribe(comparator: @escaping (InAppMessageState, InAppMessageState) -> Bool, subscriber: InAppMessageStoreSubscriber)`. Your opportunity to return a mocked value and check result of mock in test code.
    @discardableResult
    func subscribe(comparator: @escaping (InAppMessageState, InAppMessageState) -> Bool, subscriber: InAppMessageStoreSubscriber) -> Task<Void, Never> {
        mockCalled = true
        subscribeCallsCount += 1
        subscribeReceivedArguments = (comparator: comparator, subscriber: subscriber)
        subscribeReceivedInvocations.append((comparator: comparator, subscriber: subscriber))
        return subscribeClosure.map { $0(comparator, subscriber) } ?? subscribeReturnValue
    }
}

/**
 Class to easily create a mocked version of the `MessagingInAppInstance` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
public class MessagingInAppInstanceMock: MessagingInAppInstance, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    public var mockCalled: Bool = false //

    public init() {
        Mocks.shared.add(mock: self)
    }

    public func resetMock() {
        setEventListenerCallsCount = 0
        setEventListenerReceivedArguments = nil
        setEventListenerReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
        dismissMessageCallsCount = 0

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - setEventListener

    /// Number of times the function was called.
    @Atomic public private(set) var setEventListenerCallsCount = 0
    /// `true` if the function was ever called.
    public var setEventListenerCalled: Bool {
        setEventListenerCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic public private(set) var setEventListenerReceivedArguments: InAppEventListener??
    /// Arguments from *all* of the times that the function was called.
    @Atomic public private(set) var setEventListenerReceivedInvocations: [InAppEventListener?] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    public var setEventListenerClosure: ((InAppEventListener?) -> Void)?

    /// Mocked function for `setEventListener(_ eventListener: InAppEventListener?)`. Your opportunity to return a mocked value and check result of mock in test code.
    public func setEventListener(_ eventListener: InAppEventListener?) {
        mockCalled = true
        setEventListenerCallsCount += 1
        setEventListenerReceivedArguments = eventListener
        setEventListenerReceivedInvocations.append(eventListener)
        setEventListenerClosure?(eventListener)
    }

    // MARK: - dismissMessage

    /// Number of times the function was called.
    @Atomic public private(set) var dismissMessageCallsCount = 0
    /// `true` if the function was ever called.
    public var dismissMessageCalled: Bool {
        dismissMessageCallsCount > 0
    }

    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    public var dismissMessageClosure: (() -> Void)?

    /// Mocked function for `dismissMessage()`. Your opportunity to return a mocked value and check result of mock in test code.
    public func dismissMessage() {
        mockCalled = true
        dismissMessageCallsCount += 1
        dismissMessageClosure?()
    }
}

// swiftlint:enable all
