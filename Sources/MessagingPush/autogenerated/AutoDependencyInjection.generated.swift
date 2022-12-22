// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
import CioTracking
import Common

/**
######################################################
Documentation
######################################################

This automatically generated file you are viewing is a dependency injection graph for your app's source code.
You may be wondering a couple of questions. 

1. How did this file get generated? Answer --> https://github.com/levibostian/Sourcery-DI#how
2. Why use this dependency injection graph instead of X other solution/tool? Answer --> https://github.com/levibostian/Sourcery-DI#why-use-this-project
3. How do I add dependencies to this graph file? Follow one of the instructions below:
* Add a non singleton class: https://github.com/levibostian/Sourcery-DI#add-a-non-singleton-class
* Add a generic class: https://github.com/levibostian/Sourcery-DI#add-a-generic-class
* Add a singleton class: https://github.com/levibostian/Sourcery-DI#add-a-singleton-class
* Add a class from a 3rd party library/SDK: https://github.com/levibostian/Sourcery-DI#add-a-class-from-a-3rd-party
* Add a `typealias` https://github.com/levibostian/Sourcery-DI#add-a-typealias

4. How do I get dependencies from the graph in my code? 
```
// If you have a class like this:
class OffRoadWheels {}

class ViewController: UIViewController {
    // Call the property getter to get your dependency from the graph: 
    let wheels = DIGraph.getInstance(siteId: "").offRoadWheels
    // note the name of the property is name of the class with the first letter lowercase. 
}
```

5. How do I use this graph in my test suite? 
```
let mockOffRoadWheels = // make a mock of OffRoadWheels class 
DIGraph().override(mockOffRoadWheels, OffRoadWheels.self) 
```

Then, when your test function finishes, reset the graph:
```
DIGraph().reset()
```

*/


extension DIGraph {
    // call in automated test suite to confirm that all dependnecies able to resolve and not cause runtime exceptions. 
    // internal scope so each module can provide their own version of the function with the same name. 
    internal func testDependenciesAbleToResolve() {
        _ = self.moduleHookProvider    
        _ = self.queueRunnerHook    
        _ = self.deviceAttributesProvider    
    }

    // ModuleHookProvider
    internal var moduleHookProvider: ModuleHookProvider {  
        if let overridenDep = self.overrides[String(describing: ModuleHookProvider.self)] {
            return overridenDep as! ModuleHookProvider
        }
        return self.newModuleHookProvider
    }
    private var newModuleHookProvider: ModuleHookProvider {    
        return MessagingPushModuleHookProvider(siteId: self.siteId)
    }
    // QueueRunnerHook
    public var queueRunnerHook: QueueRunnerHook {  
        if let overridenDep = self.overrides[String(describing: QueueRunnerHook.self)] {
            return overridenDep as! QueueRunnerHook
        }
        return self.newQueueRunnerHook
    }
    private var newQueueRunnerHook: QueueRunnerHook {    
        return MessagingPushQueueRunner(siteId: self.siteId, jsonAdapter: self.jsonAdapter, logger: self.logger, httpClient: self.httpClient)
    }
    // DeviceAttributesProvider
    internal var deviceAttributesProvider: DeviceAttributesProvider {  
        if let overridenDep = self.overrides[String(describing: DeviceAttributesProvider.self)] {
            return overridenDep as! DeviceAttributesProvider
        }
        return self.newDeviceAttributesProvider
    }
    private var newDeviceAttributesProvider: DeviceAttributesProvider {    
        return SdkDeviceAttributesProvider(sdkConfigStore: self.sdkConfigStore, deviceInfo: self.deviceInfo)
    }
}
