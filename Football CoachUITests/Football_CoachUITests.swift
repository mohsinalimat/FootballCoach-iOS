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
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func schedule() {
        XCUIApplication().tabBars.buttons["Schedule"].tap()
        snapshot("schedule")
    }
    
    func home() {
        XCUIApplication().tabBars.buttons["Latest News"].tap()
        snapshot("home")
    }
    
    func roster() {
        XCUIApplication().tabBars.buttons["Depth Chart"].tap()
        snapshot("roster")
    }
    
    func myTeam() {
        XCUIApplication().tabBars.buttons["My Team"].tap()
        snapshot("myteam")
    }
    
}
