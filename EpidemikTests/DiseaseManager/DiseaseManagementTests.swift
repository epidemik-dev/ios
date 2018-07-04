//
//  EpidemikTests.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 9/15/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import XCTest

class DiseaseManagementTests: XCTestCase {
	
	var ex1: DiseaseManager!
	var ex2: DiseaseManager!
	var ex3: DiseaseManager!
	var edgeCaseTester: DiseaseManager!

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func initChunk1() {
		ex1 = DiseaseManager()
		ex1.addDisease(lat: 1, long: 1)
	}
	
	func testChunks1() {
		initChunk1()
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: -200, curLatMax: 200, curLongMin: -200, curLongMax: 200), 1)
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: 0, curLatMax: 3, curLongMin: 0, curLongMax: 3), 1)
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: 3, curLatMax: 4, curLongMin: 0, curLongMax: 3), 0)
		
	}
	
	func initChunk2() {
		ex2 = DiseaseManager()
		ex2.addDisease(lat: 1, long: 1)
		ex2.addDisease(lat: 1.2, long: 1.2)
		ex2.addDisease(lat: 3, long: 3)
		ex2.addDisease(lat: 55, long: 55)
		ex2.addDisease(lat: 0, long: 0)
	}
	
	func testChunks2() {
		initChunk2()
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: -200, curLatMax: 200, curLongMin: -200, curLongMax: 200), 5)
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: 0, curLatMax: 3, curLongMin: 0, curLongMax: 3), 4)
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: 0, curLatMax: 2, curLongMin: 0, curLongMax: 2), 3)
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: 99, curLatMax: 101, curLongMin: 1, curLongMax: 100), 0)
	}
	
	func initChunk3() {
		ex3 = DiseaseManager()
		// Bottom Left
		ex3.addDisease(lat: -10, long: -10)
		ex3.addDisease(lat: -12, long: 0)
		ex3.addDisease(lat: 0, long: -10)
		ex3.addDisease(lat: -10, long: 0)
		ex3.addDisease(lat: 0, long: 0)
		ex3.addDisease(lat: 0, long: 0)
		// Bottom Right
		ex3.addDisease(lat: -10, long: 10)
		ex3.addDisease(lat: 0, long: 10)
		// Top Left
		ex3.addDisease(lat: 50, long: -10)
		ex3.addDisease(lat: 10, long: 0)
		ex3.addDisease(lat: 1.1, long: 0)
		ex3.addDisease(lat: 1.11, long: 0)
		//Top Right
		ex3.addDisease(lat: 10, long: 10)
		ex3.addDisease(lat: 50, long: 10)
		
		//Bottom Left
		ex3.addDisease(lat: -10, long: -10)
		ex3.addDisease(lat: -10.5, long: -9)
		// Top Left
		ex3.addDisease(lat: 30.3, long: -10)
		ex3.addDisease(lat: 1, long: 9)
		ex3.addDisease(lat: 20, long: 0)
		ex3.addDisease(lat: 3, long: 1)
	}
	
	func testChunk3() {
		initChunk3()
		XCTAssertEqual(ex3.getAll(), 20)
		
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -200, curLatMax: 200, curLongMin: -200, curLongMax: 200), 20)
		
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -0.1, curLatMax: 0.1, curLongMin: -0.1, curLongMax: 0.1), 2)
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: 10, curLatMax: 20, curLongMin: 10, curLongMax: 20), 1)
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -20, curLatMax: -10, curLongMin: -20, curLongMax: -10), 2)
		
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -20, curLatMax: 0, curLongMin: -20, curLongMax: 20), 10)


	}
	
	func initEdgeCase() {
		self.edgeCaseTester = DiseaseManager()
		self.edgeCaseTester.addDisease(lat: 0, long: 0)
		self.edgeCaseTester.addDisease(lat: 0, long: 0)
		self.edgeCaseTester.addDisease(lat: 0, long: 1)
		self.edgeCaseTester.addDisease(lat: -1, long: 1)
		self.edgeCaseTester.addDisease(lat: 1, long: -1)
		self.edgeCaseTester.addDisease(lat: 50, long: -1)
		self.edgeCaseTester.addDisease(lat: -1, long: -1)
		self.edgeCaseTester.addDisease(lat: 0, long: -1)
	}
	
	func testEdgeCase() {
		initEdgeCase()
		XCTAssertEqual(self.edgeCaseTester.getAll(), 8)
	}

}
