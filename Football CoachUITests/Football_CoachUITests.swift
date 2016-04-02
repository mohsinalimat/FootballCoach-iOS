//
//  Football_CoachUITests.swift
//  Football CoachUITests
//
//  Created by Akshay Easwaran on 4/2/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

import XCTest

class Football_CoachUITests: XCTestCase {
        
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testExample()
    {
        XCUIApplication().tabBars.buttons["Schedule"].tap()
        snapshot("schedule")
        XCUIApplication().tabBars.buttons["Latest News"].tap()
        snapshot("home")
        XCUIApplication().tabBars.buttons["Depth Chart"].tap()
        snapshot("roster")
        XCUIApplication().tabBars.buttons["My Team"].tap()
        snapshot("myteam")
    }
    
    
}
