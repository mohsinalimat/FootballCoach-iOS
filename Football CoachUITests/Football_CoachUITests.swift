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
        
        //let app = XCUIApplication()
        //let playWeekButton = app.tables.buttons[" Play Week"]
        //playWeekButton.tap()
        //playWeekButton.tap()
        //playWeekButton.tap()
        
        XCUIApplication().tabBars.buttons["Latest News"].tap()
        snapshot("1home")
        XCUIApplication().tabBars.buttons["Schedule"].tap()
        snapshot("2schedule")
        XCUIApplication().tabBars.buttons["Depth Chart"].tap()
        snapshot("3roster")
        XCUIApplication().tabBars.buttons["My Team"].tap()
        snapshot("4myteam")
    }
    
    
}
