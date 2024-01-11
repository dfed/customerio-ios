import CioInternalCommon
import Segment

class DataPipelineImplementation: DataPipelineInstance {
    private let moduleConfig: DataPipelineConfigOptions
    private let logger: Logger
    let analytics: Analytics
    let eventBusHandler: EventBusHandler

    private var globalDataStore: GlobalDataStore
    private let deviceAttributesProvider: DeviceAttributesProvider
    private let dateUtil: DateUtil
    private let deviceInfo: DeviceInfo

    init(diGraph: DIGraphShared, moduleConfig: DataPipelineConfigOptions) {
        self.moduleConfig = moduleConfig
        self.logger = diGraph.logger
        self.analytics = .init(configuration: moduleConfig.toSegmentConfiguration())

        self.eventBusHandler = diGraph.eventBusHandler
        self.globalDataStore = diGraph.globalDataStore
        self.deviceAttributesProvider = diGraph.deviceAttributesProvider
        self.dateUtil = diGraph.dateUtil
        self.deviceInfo = diGraph.deviceInfo

        initialize(diGraph: diGraph)
    }

    private func initialize(diGraph: DIGraphShared) {
        // add CustomerIO destination plugin
        if moduleConfig.autoAddCustomerIODestination {
            let customerIODestination = CustomerIODestination()
            customerIODestination.analytics = analytics
            analytics.add(plugin: customerIODestination)
        }

        if let existingDeviceToken = globalDataStore.pushDeviceToken {
            // if the device token exists, pass it to the plugin and ensure device attributes are updated
            addDeviceAttributes(token: existingDeviceToken)
        }

        // plugin to publish data pipeline events
        analytics.add(plugin: DataPipelinePublishedEvents(diGraph: diGraph))

        // subscribe to journey events emmitted from push/in-app module to send them via datapipelines
        subscribeToJourneyEvents()
    }

    private func subscribeToJourneyEvents() {
        eventBusHandler.addObserver(TrackMetricEvent.self) { metric in
            self.trackPushMetric(deliveryID: metric.deliveryID, event: metric.event, deviceToken: metric.deviceToken)
        }

        eventBusHandler.addObserver(TrackInAppMetricEvent.self) { metric in
            self.trackInAppMetric(deliveryID: metric.deliveryID, event: metric.event, metaData: metric.params)
        }

        eventBusHandler.addObserver(RegisterDeviceTokenEvent.self) { event in
            self.registerDeviceToken(event.token)
        }
    }

    // Code below this line will be updated in later PRs
    // FIXME: [CDP] Implement CustomerIOInstance

    var siteId: String?

    var config: CioInternalCommon.SdkConfig?

    func identify(identifier: String, body: [String: Any]) {
        commonIdentifyProfile(userId: identifier, attributesDict: body)
    }

    func identify<RequestBody: Codable>(identifier: String, body: RequestBody) {
        commonIdentifyProfile(userId: identifier, attributesCodable: body)
    }

    /// Associate a user with their unique ID and record traits about them.
    /// - Parameters:
    ///   - traits: A dictionary of traits you know about the user. Things like: email, name, plan, etc.
    func identify(body: Codable) {
        analytics.identify(traits: body)
    }

    var registeredDeviceToken: String? {
        deviceAttributesPlugin.token
    }

    func clearIdentify() {
        logger.info("clearing identified profile")
        commonClearIdentify()
    }

    func track(name: String, data: [String: Any]) {
        analytics.track(name: name, properties: data)
    }

    func track<RequestBody: Codable>(name: String, data: RequestBody?) {
        analytics.track(name: name, properties: data)
    }

    func screen(name: String, data: [String: Any]) {
        analytics.screen(title: name, properties: data)
    }

    func screen<RequestBody: Codable>(name: String, data: RequestBody?) {
        analytics.screen(title: name, properties: data)
    }

    var profileAttributes: [String: Any] {
        get { analytics.traits() ?? [:] }
        set {
            let userId = registeredUserId
            guard let userId = userId else {
                logger.error("No user identified. If you don't have a userId but want to record traits, please pass traits using identify(body: Codable)")
                return
            }
            commonIdentifyProfile(userId: userId, attributesDict: newValue)
        }
    }

    private func commonIdentifyProfile(userId: String, attributesDict: [String: Any]? = nil, attributesCodable: Codable? = nil) {
        let currentlyIdentifiedProfile = registeredUserId
        let isChangingIdentifiedProfile = currentlyIdentifiedProfile != nil && currentlyIdentifiedProfile != userId
        let isFirstTimeIdentifying = currentlyIdentifiedProfile == nil

        if let attributes = attributesCodable {
            analytics.identify(userId: userId, traits: attributes)
        } else {
            analytics.identify(userId: userId, traits: attributesDict)
        }

        if isFirstTimeIdentifying || isChangingIdentifiedProfile {
            if let existingDeviceToken = registeredDeviceToken {
                logger.debug("registering existing device token to newly identified profile: \(userId)")
                // register device to newly identified profile
                addDeviceAttributes(token: existingDeviceToken)
            }

            // logger.debug("running hooks profile identified \(userId)")
            // FIXME: [CDP] Request Journeys to invoke profile identify hooks
            // hooks.profileIdentifyHooks.forEach { hook in
            //     hook.profileIdentified(identifier: userId)
            // }
        }
    }

    private func commonClearIdentify() {
        let currentlyIdentifiedProfile = registeredUserId ?? "anonymous"
        logger.debug("deleting device info from \(currentlyIdentifiedProfile) to stop sending push to a profile that is no longer identified")
        deleteDeviceToken()

        // logger.debug("running hooks: profile stopped being identified \(currentlyIdentifiedProfile)")
        // FIXME: [CDP] Request Journeys to invoke profile clearing hooks
        // hooks.profileIdentifyHooks.forEach { hook in
        //     hook.beforeProfileStoppedBeingIdentified(oldIdentifier: currentlyIdentifiedProfileIdentifier)
        // }

        // reset all to default state
        logger.debug("resetting user profile")
        analytics.reset()
    }

    func deleteDeviceToken() {
        logger.info("deleting device token request made")

        // Do not delete push token from device storage. The token is valid
        // once given to SDK. We need it for future profile identifications.

        // send delete device event to remove it from current profile
        analytics.track(name: "Device Deleted")
    }

    var deviceAttributes: [String: Any] {
        get { [:] }
        set {
            logger.info("updating device attributes")
            addDeviceAttributes(token: deviceAttributesPlugin.token, attributes: newValue)
        }
    }

    /// Internal method for passing device token to the plugin and updating device attributes
    private func addDeviceAttributes(token deviceToken: String?, attributes customAttributes: [String: Any] = [:]) {
        if let existingDeviceToken = deviceAttributesPlugin.token, existingDeviceToken != deviceToken {
            // token has been refreshed, delete old token to avoid registering same device multiple times
            deleteDeviceToken()
        }
        deviceAttributesPlugin.token = deviceToken

        // Consolidate all Apple platforms under iOS
        deviceAttributesProvider.getDefaultDeviceAttributes { defaultDeviceAttributes in
            let deviceAttributes: [String: Any] = defaultDeviceAttributes
                .mergeWith([
                    "last_used": self.dateUtil.now
                ])
                .mergeWith(customAttributes)
            self.deviceAttributesPlugin.attributes = deviceAttributes

            guard self.deviceAttributesPlugin.token != nil else {
                self.logger.debug("no device token found, ignoring device attributes request")
                return
            }
            guard self.registeredUserId != nil else {
                self.logger.info("no profile identified, so not registering device token to a profile")
                return
            }

            // TODO: [CDP] Reverify event name before going live
            self.analytics.track(name: "Device Created or Updated", properties: deviceAttributes)
        }
    }

    func registerDeviceToken(_ deviceToken: String) {
        logger.debug("storing device token to device storage \(deviceToken)")
        // save the device token for later use.
        // segment plugin doesn't store token anywhere so we need to pass token to it every time
        // storing it so we can reference the token and update device plugin app relaunch
        globalDataStore.pushDeviceToken = deviceToken

        logger.info("registering device token \(deviceToken)")
        addDeviceAttributes(token: deviceToken)
    }

    func trackMetric(deliveryID: String, event: Metric, deviceToken: String) {
        trackPushMetric(deliveryID: deliveryID, event: event.rawValue, deviceToken: deviceToken)
    }

    func trackPushMetric(deliveryID: String, event: String, deviceToken: String) {
        logger.info("push metric \(event)")

        logger.debug("delivery id \(deliveryID) device token \(deviceToken)")

        trackMetricEvent(deliveryID: deliveryID, event: event, deviceToken: deviceToken)
    }

    func trackInAppMetric(deliveryID: String, event: String, metaData: [String: String]) {
        logger.info("in-app metric \(event)")

        logger.debug("delivery id \(deliveryID) metaData \(metaData)")

        trackMetricEvent(deliveryID: deliveryID, event: event, metaData: metaData)
    }

    /// Tracks metric events for push and in-app messages
    private func trackMetricEvent(deliveryID: String, event: String, deviceToken: String? = nil, metaData: [String: String] = [:]) {
        // property keys should be camelCase
        var properties: [String: String] = metaData

        properties["metric"] = event
        properties["deliveryId"] = deliveryID

        if let token = deviceToken {
            properties["recipient"] = token
        }

        analytics.track(name: "Report Delivery Event", properties: properties)
    }
}

// extension methods to simplify and reduce repetitive coding
extension DataPipelineImplementation {
    /// returns user id for currently identifier profile
    var registeredUserId: String? {
        analytics.userId
    }

    /// returns DeviceAttributes if attached; if not, attaches them and then returns the instance
    private var deviceAttributesPlugin: DeviceAttributes {
        let attributesPlugin: DeviceAttributes
        if let plugin = analytics.find(pluginType: DeviceAttributes.self) {
            attributesPlugin = plugin
        } else {
            attributesPlugin = DeviceAttributes()
            analytics.add(plugin: attributesPlugin)
        }
        return attributesPlugin
    }
}

// To process pending tasks in background queue
// BGQ in each of the following methods refer to background queue
extension DataPipelineImplementation {
    func processIdentifyFromBGQ(identifier: String, timestamp: String, body: [String: Any]?) {
        var identifyEvent = IdentifyEvent(userId: identifier, traits: nil)
        identifyEvent.timestamp = timestamp

        let contextDict = ["journeys": ["identifiers": ["id": identifier]]]
        if let context = try? JSON(contextDict) {
            identifyEvent.context = context
        }
        if let traits = body {
            let jsonTraits = try? JSON(traits)
            identifyEvent.traits = jsonTraits
        }
        analytics.process(event: identifyEvent)
    }

    func processScreenEventFromBGQ(identifier: String, name: String, timestamp: String?, properties: [String: Any]) {
        var screenEvent = ScreenEvent(title: name, category: nil)
        screenEvent.userId = identifier
        screenEvent.timestamp = timestamp
        if let jsonProperties = try? JSON(properties) {
            screenEvent.properties = jsonProperties
        }
        analytics.process(event: screenEvent)
    }

    func processEventFromBGQ(identifier: String, name: String, timestamp: String?, properties: [String: Any]) {
        var trackEvent = TrackEvent(event: name, properties: nil)
        trackEvent.userId = identifier
        trackEvent.timestamp = timestamp
        if let jsonProperties = try? JSON(properties) {
            trackEvent.properties = jsonProperties
        }
        analytics.process(event: trackEvent)
    }

    func processDeleteTokenFromBGQ(identifier: String, token: String, timestamp: String) {
        var trackDeleteEvent = TrackEvent(event: "Device Deleted", properties: nil)
        trackDeleteEvent.userId = identifier
        trackDeleteEvent.timestamp = timestamp
        let journeyDict: [String: Any] = ["journeys": ["identifiers": ["id": identifier]]]
        let deviceDict: [String: Any] = ["device": ["token": token, "type": "ios"]]
        if let context = try? JSON(deviceDict.mergeWith(journeyDict)) {
            trackDeleteEvent.context = context
        }
        analytics.process(event: trackDeleteEvent)
    }

    func processRegisterDeviceFromBGQ(identifier: String, token: String, timestamp: String, attributes: [String: Any]? = nil) {
        var trackRegisterTokenEvent = TrackEvent(event: "Device Created or Updated", properties: nil)
        trackRegisterTokenEvent.userId = identifier
        trackRegisterTokenEvent.timestamp = timestamp
        let journeyDict: [String: Any] = ["journeys": ["identifiers": ["id": identifier]]]
        var tokenDict: [String: Any] = ["token": token, "type": "ios"]

        if let attributes = attributes {
            tokenDict = tokenDict.mergeWith(attributes)
        }

        let deviceDict: [String: Any] = ["device": tokenDict]
        if let context = try? JSON(deviceDict.mergeWith(journeyDict)) {
            trackRegisterTokenEvent.context = context
        }
        analytics.process(event: trackRegisterTokenEvent)
    }

    func processPushMetricsFromBGQ(token: String, event: Metric, deliveryId: String, timestamp: String, metaData: [String: Any] = [:]) {
        let properties: [String: Any] = metaData.mergeWith([
            "metric": event.rawValue,
            "deliveryId": deliveryId,
            "recipient": token
        ])
        var trackPushMetricEvent = TrackEvent(event: "Report Delivery Event", properties: try? JSON(properties))
        trackPushMetricEvent.timestamp = timestamp
        analytics.process(event: trackPushMetricEvent)
    }
}