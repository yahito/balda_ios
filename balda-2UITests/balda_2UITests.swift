//
//  balda_2UITests.swift
//  balda-2UITests
//
//  Created by Andrey on 22/09/2023.
//

import XCTest
@testable import Balda

final class balda_2UITests: XCTestCase {
    var notificationObserver: NSObjectProtocol?

    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

       
        
        

        
    }
    
    public class UITestObserver: NSObject, XCTestObservation {
        public func testCase(_ testCase: XCTestCase,
                               didFailWithDescription description: String,
                               inFile filePath: String?,
                               atLine lineNumber: Int) {
            print("failure description: \(description)")
            print("failed test case: \(testCase)")
            if let filePath = filePath {
                print("failure at file path: \(filePath)")
            }
            print("failure at line: \(lineNumber)")
        }
    }

    override func tearDownWithError() throws {
        // Remove the observer when the test completes
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func setUp() async throws {
        try await super.setUp()  // Call the superclass setup in async context
        
        let app = await XCUIApplication()
        await setupSnapshot(app)  // Await setupSnapshot to meet main actor isolation
        await app.launch()
    }
/*
    func testExample() throws {
 
        let app = XCUIApplication()
        app.launch()
        XCTestObservationCenter.shared.addTestObserver(UITestObserver())
        let skipButton = app.buttons["skipButton"]
 
      
                
        if skipButton.waitForExistence(timeout: 10) {
        skipButton.tap()
    } else {
        XCTFail("Failed to find skipButton")
    }
        
        
     
        
   
    }
    

    
    func testExample2() throws {
 
        let app = XCUIApplication()
        XCTestObservationCenter.shared.addTestObserver(UITestObserver())
        app.launchArguments.append("UI_TEST_TRIGGER_GENERIC_EVENT")
               
        app.launch()
        
        DispatchQueue.main.async {
            setupSnapshot(app)
            
            let skipButton = app.buttons["skipButton"]

            if skipButton.waitForExistence(timeout: 2) {
                
                let title = app.staticTexts["title"]
                
                if title.waitForExistence(timeout: 2) {
                   
                    var j = 0
                    for i in 1...4 {
  
                        let expectedValue = "Ваш ход"

                        let predicate = NSPredicate(format: "label == %@", expectedValue)
                                                
                        let customPredicate = NSPredicate { evaluatedObject, _ in
                            j += 1
                            snapshot("Launch 5_" + String(j))
                            return predicate.evaluate(with: evaluatedObject)
                        }
                        
                        
                        let expectation = XCTNSPredicateExpectation(predicate: customPredicate, object: title)
                        
                        
                        let result = XCTWaiter().wait(for: [expectation], timeout: 10.0)
                        XCTAssertEqual(result, .completed, "Failed to find the button in time \(i) Current value: '\(title.label)'")
                        if result != .completed {
                            XCTFail("Failed to find expected text '\(expectedValue)' in the label. Current value: '\(title.label)'")
                        }
                        
                        snapshot("Launch 5_" + String(i))
                        print("result: ")
                        print(result)
                    }
                        
                }
                
            } else {
                XCTFail("Failed to find skipButton")
            }
            
        }
 
    }
    */
    let periodicAction = PeriodicAction()
    
    func testExample3() throws {
 
        let app = XCUIApplication()
        
        app.launchArguments.append("UI_TEST_TRIGGER_GENERIC_EVENT")
        app.launchArguments.append("UI_TEST_ЫУМУТ")
               
        app.launch()
        
        let atomicInt = AtomicInteger(0)
        
        DispatchQueue.main.async {
                        
            setupSnapshot(app)
        }
          
        
        DispatchQueue.main.async{
            for j: Int in 1...20 {
                DispatchQueue.main.async {
                    let n = atomicInt.incrementAndGet()
                    snapshot("Launch 7_" + String(n))
                }
            }
        }
        
       
            
/*
        DispatchQueue.main.async {
            
            let skipButton = app.buttons["skipButton"]

            if skipButton.waitForExistence(timeout: 2) {
                
                let title = app.staticTexts["title"]
                
                if title.waitForExistence(timeout: 2) {
                   
                    for i in 1...4 {
                     
  
                        let expectedValue = "Ваш ход"

                        let predicate = NSPredicate(format: "label == %@", expectedValue)
                        
                        
                        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: title)
                        
                        
                        let result = XCTWaiter().wait(for: [expectation], timeout: 10.0)
                        XCTAssertEqual(result, .completed, "Failed to find the button in time \(i) Current value: '\(title.label)'")
                        if result != .completed {
                            XCTFail("Failed to find expected text '\(expectedValue)' in the label. Current value: '\(title.label)'")
                        }
                        
                        
                        snapshot("Launch 9_" + String(i))
                        print("result: ")
                        print(result)
                    }
                        
                }
                self.periodicAction.stop()
            } else {
                XCTFail("Failed to find skipButton")
            }
            
            
            
        }
 */
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}


class PeriodicAction {
    private var isRunning = false
    private let queue = DispatchQueue(label: "PeriodicActionQueue", qos: .background)


    func start(interval: TimeInterval, action: @escaping () -> Void) {
        isRunning = true

        func executeAction() {
            guard isRunning else { return }

            do {
                // Try to execute the action, and catch any errors.
                print("start action")
                try action()
                print("end action")
            } catch {
                // Handle the error here, e.g., log it or print it.
                print("Error occurred during periodic action: \(error)")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                executeAction()
            }
            
        }

        executeAction()
    }

    func stop() {
        isRunning = false
    }
}




class AtomicInteger {
    private var value: Int
    private let queue = DispatchQueue(label: "AtomicIntegerQueue")

    init(_ initialValue: Int = 0) {
        self.value = initialValue
    }

    func get() -> Int {
        return queue.sync { value }
    }

    func set(_ newValue: Int) {
        queue.sync {
            value = newValue
        }
    }

    func incrementAndGet() -> Int {
        return queue.sync {
            value += 1
            return value
        }
    }

    func decrementAndGet() -> Int {
        return queue.sync {
            value -= 1
            return value
        }
    }
}
