//
//  NetworkTests.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 4/20/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest
import SwiftyJSON

class NetworkTests: XCTestCase {
	
	var expectation1: XCTestExpectation!
	var expectation2: XCTestExpectation!
	var expectation3: XCTestExpectation!
	
	var today: String!
	
	var username = Float.random(in: 0 ..< 10000000)
	
	var authToken: String!

    override func setUp() {
        super.setUp()
		expectation1 = XCTestExpectation(description: "General Test")
		expectation1.expectedFulfillmentCount = 3
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		self.today = dateFormatter.string(from: Date())
	}
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testCreateAcc() {
		NetworkAPI.createAccount(username: String(username), password: "password1", latitude: 0, longitude: 0, deviceID: "", dob: Date(), gender: "Male", result: accountCreated)
		wait(for: [expectation1], timeout: 10)
	}
	
	func accountCreated(result: JSON?) {
		XCTAssert(result!.string != nil)
		expectation1.fulfill()
		login()
	}
	
	func login() {
		NetworkAPI.loginIsValid(username: String(username), password: "password1", result: loggedIn)
	}
	
	func loggedIn(result: JSON?) {
		XCTAssert(result!.string != nil)
		FileRW.writeFile(fileName: "auth_token.epi", contents: result!.string!)
		expectation1.fulfill()
		getDiseases()
	}
	
	func getDiseases() {
		NetworkAPI.loadAllDiseaseData(result: diseaseData)
	}
	
	func diseaseData(result: JSON?) {
		XCTAssert(result?.array != nil);
		expectation1.fulfill()
	}

}
