//
//  inventoryappUITests.swift
//  inventoryappUITests
//
//  Created by Brett Romero on 4/20/17.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest

class inventoryappUITests: XCTestCase {
    
    var topLevelApp:XCUIApplication? = nil
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        topLevelApp = XCUIApplication()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        topLevelApp = nil
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testClickToDetailView(){
        
        topLevelApp?.tables.staticTexts["Highlander"].tap()
        topLevelApp?.navigationBars["inventoryapp.DetailView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
    }
    
    func testClickToViewAndBack(){
        
        let table = topLevelApp?.tables["mainTable"]
        table?.cells.staticTexts["Toyota"].tap()
        topLevelApp?.navigationBars["inventoryapp.DetailView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
    }
    
    func testAddOneItem(){
        addOne()
        XCTAssertEqual(topLevelApp?.tables["mainTable"].cells.count, 5)
    }
    
    func addOne() {
        XCUIApplication().navigationBars["inventoryapp.View"].buttons["Add"].tap()
        
        let modelTextField = topLevelApp?.textFields["model"]
        modelTextField?.tap()
        modelTextField?.typeText("Tundra")
        
        let unitsTextField = topLevelApp?.textFields["units"]
        unitsTextField?.tap()
        unitsTextField?.typeText("10")
        
        let makeTextField = topLevelApp?.textFields["make"]
        makeTextField?.tap()
        makeTextField?.typeText("Toyota")
        
        topLevelApp?.buttons["Add"].tap()
        topLevelApp?.navigationBars["inventoryapp.AddView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
    }
    
    func testAddOneDelete() {
        addOne()
        XCTAssertEqual(topLevelApp?.tables.cells.count, 5)
        testDeleteOne(rowCount: 4)
        
    }
    
    func testDeleteOne(rowCount:Int? = 3) {
        let maintableTable = topLevelApp?.tables["mainTable"]
        maintableTable?.staticTexts["Highlander"].swipeLeft()
        maintableTable?.buttons["Delete"].tap()
        
        XCTAssertEqual(maintableTable?.cells.count, rowCount)
        
    }
}
