//
//  SPHTechMobileAssignmentUITests.swift
//  SPHTechMobileAssignmentUITests
//
//  Created by Jingmeng.Gan on 7/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import XCTest

class SPHTechMobileAssignmentUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    // NOTE: for UI tests to work the keyboard of simulator must be on.
    // Keyboard shortcut COMMAND + SHIFT + K while simulator has focus
    func testAlert_whenClickCellShowAlert_thenClickOKDismiss() {
        
        let app = XCUIApplication()

        app.tables/*@START_MENU_TOKEN@*/.staticTexts["2008-Q1    0.171586\n2008-Q2    0.248899\n2008-Q3    0.439655\n2008-Q4    0.683579"]/*[[".cells[\"Result row 5\"].staticTexts[\"2008-Q1    0.171586\\n2008-Q2    0.248899\\n2008-Q3    0.439655\\n2008-Q4    0.683579\"]",".staticTexts[\"2008-Q1    0.171586\\n2008-Q2    0.248899\\n2008-Q3    0.439655\\n2008-Q4    0.683579\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        
        //when
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["2011-Q1    3.466228\n2011-Q2    3.380723\n2011-Q3    3.713792\n2011-Q4    4.07796"]/*[[".cells[\"Result row 8\"].staticTexts[\"2011-Q1    3.466228\\n2011-Q2    3.380723\\n2011-Q3    3.713792\\n2011-Q4    4.07796\"]",".staticTexts[\"2011-Q1    3.466228\\n2011-Q2    3.380723\\n2011-Q3    3.713792\\n2011-Q4    4.07796\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Make sure alert show and dismiss
         XCTAssertTrue(app.alerts["2011 Mobile data useage"].waitForExistence(timeout: 5))
        
         app.alerts["2011 Mobile data useage"].buttons["OK"].tap()
        
         XCTAssertFalse(app.alerts["2011 Mobile data useage"].waitForExistence(timeout: 5))

    }

}
