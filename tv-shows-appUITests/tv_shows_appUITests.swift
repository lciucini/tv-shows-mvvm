//
//  tv_shows_appUITests.swift
//  tv-shows-appUITests
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import XCTest

class tv_shows_appUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDetailView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element(boundBy: 0).children(matching: .cell).element(boundBy: 0).twoFingerTap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.staticTexts["Description"].twoFingerTap()
        app.staticTexts["Game of Thrones"].twoFingerTap()
        app.staticTexts["2011"].twoFingerTap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).twoFingerTap()

        app/*@START_MENU_TOKEN@*/.staticTexts["Subscribed"]/*[[".buttons[\"Subscribed\"].staticTexts[\"Subscribed\"]",".staticTexts[\"Subscribed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        app.buttons["Subscribe"].twoFingerTap()
        app.buttons["back icon"].twoFingerTap()
    }
    
    func testDetailViewScroll() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element(boundBy: 0).children(matching: .cell).element(boundBy: 0).twoFingerTap()
        
        let descriptionElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Description").element
        descriptionElement.swipeUp()
        descriptionElement.swipeDown()
        descriptionElement.swipeDown()
        app.buttons["back icon"].twoFingerTap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
