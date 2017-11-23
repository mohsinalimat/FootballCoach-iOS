//
//  CFC_Screenshots.swift
//  CFC-Screenshots
//
//  Created by Akshay Easwaran on 11/7/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

import XCTest

class CFC_Screenshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        snapshot("0News")
        
        let tabBarsQuery = XCUIApplication().tabBars
        
        let scheduleButton = tabBarsQuery.buttons["Schedule"]
        scheduleButton.tap()
        snapshot("1Schedule")
        
        tabBarsQuery.buttons["Depth Chart"].tap()
        snapshot("2Roster")
        
        tabBarsQuery.buttons["Search"].tap()
        snapshot("3Search")
        
        tabBarsQuery.buttons["My Team"].tap()
        snapshot("4Team")
    }
    
}
