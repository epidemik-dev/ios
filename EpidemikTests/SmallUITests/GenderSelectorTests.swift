//
//  GenderSelectorTests.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 5/12/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest

class GenderSelectorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	// Tests that the single selected functionality of the gender selector works
	func testGenderSelector() {
		let selector = GenderSelector(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		XCTAssertEqual(selector.getGender(), "Did Not Choose")
		selector.genderChanged(selector.maleSelector)
		XCTAssert(selector.maleSelector.isChecked)
		XCTAssertFalse(selector.femaleSelector.isChecked)
		XCTAssertEqual(selector.getGender(), "Male")
		selector.genderChanged(selector.femaleSelector)
		XCTAssert(selector.femaleSelector.isChecked)
		XCTAssertFalse(selector.maleSelector.isChecked)
		XCTAssertEqual(selector.getGender(), "Female")
		selector.genderChanged(selector.maleSelector)
		XCTAssert(selector.maleSelector.isChecked)
		XCTAssertFalse(selector.femaleSelector.isChecked)
		XCTAssertFalse(selector.otherSelector.isChecked)
		XCTAssertEqual(selector.getGender(), "Male")
		selector.genderChanged(selector.otherSelector)
		XCTAssertEqual(selector.getGender(), "Other")
		XCTAssert(selector.otherSelector.isChecked)

	}
    
}
