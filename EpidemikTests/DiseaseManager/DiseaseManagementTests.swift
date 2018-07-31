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
		ex1.addDisease(lat: 1, long: 1, diseaseName: "")
	}
	
	func testChunks1() {
		initChunk1()
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: -200, curLatMax: 200, curLongMin: -200, curLongMax: 200, diseaseName: nil), 1)
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: 0, curLatMax: 3, curLongMin: 0, curLongMax: 3, diseaseName: ""), 1)
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: 3, curLatMax: 4, curLongMin: 0, curLongMax: 3, diseaseName: "a"), 0)
		XCTAssertEqual(ex1.getWeightForRange(curLatMin: 3, curLatMax: 4, curLongMin: 0, curLongMax: 3, diseaseName: nil), 0)
		
	}
	
	func initChunk2() {
		ex2 = DiseaseManager()
		ex2.addDisease(lat: 1, long: 1, diseaseName: "a")
		ex2.addDisease(lat: 1.2, long: 1.2, diseaseName: "a")
		ex2.addDisease(lat: 3, long: 3, diseaseName: "b")
		ex2.addDisease(lat: 55, long: 55, diseaseName: "a")
		ex2.addDisease(lat: 0, long: 0, diseaseName: "c")
	}
	
	func testChunks2() {
		initChunk2()
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: -200, curLatMax: 200, curLongMin: -200, curLongMax: 200, diseaseName: nil), 5)
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: 0, curLatMax: 3, curLongMin: 0, curLongMax: 3, diseaseName: nil), 4)
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: 0, curLatMax: 2, curLongMin: 0, curLongMax: 2, diseaseName: nil), 3)
		XCTAssertEqual(ex2.getWeightForRange(curLatMin: 99, curLatMax: 101, curLongMin: 1, curLongMax: 100, diseaseName: nil
		), 0)
	}
	
	func initChunk3() {
		ex3 = DiseaseManager()
		// Bottom Left
		ex3.addDisease(lat: -10, long: -10, diseaseName: "")
		ex3.addDisease(lat: -12, long: 0, diseaseName: "")
		ex3.addDisease(lat: 0, long: -10, diseaseName: "")
		ex3.addDisease(lat: -10, long: 0, diseaseName: "")
		ex3.addDisease(lat: 0, long: 0, diseaseName: "")
		ex3.addDisease(lat: 0, long: 0, diseaseName: "")
		// Bottom Right
		ex3.addDisease(lat: -10, long: 10, diseaseName: "")
		ex3.addDisease(lat: 0, long: 10, diseaseName: "")
		// Top Left
		ex3.addDisease(lat: 50, long: -10, diseaseName: "")
		ex3.addDisease(lat: 10, long: 0, diseaseName: "")
		ex3.addDisease(lat: 1.1, long: 0, diseaseName: "")
		ex3.addDisease(lat: 1.11, long: 0, diseaseName: "")
		//Top Right
		ex3.addDisease(lat: 10, long: 10, diseaseName: "")
		ex3.addDisease(lat: 50, long: 10, diseaseName: "")
		
		//Bottom Left
		ex3.addDisease(lat: -10, long: -10, diseaseName: "")
		ex3.addDisease(lat: -10.5, long: -9, diseaseName: "")
		// Top Left
		ex3.addDisease(lat: 30.3, long: -10, diseaseName: "")
		ex3.addDisease(lat: 1, long: 9, diseaseName: "")
		ex3.addDisease(lat: 20, long: 0, diseaseName: "")
		ex3.addDisease(lat: 3, long: 1, diseaseName: "")
	}
	
	func testChunk3() {
		initChunk3()
		XCTAssertEqual(ex3.getAll(), 20)
		
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -200, curLatMax: 200, curLongMin: -200, curLongMax: 200, diseaseName: ""), 20)
		
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -0.1, curLatMax: 0.1, curLongMin: -0.1, curLongMax: 0.1, diseaseName: ""), 2)
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: 10, curLatMax: 20, curLongMin: 10, curLongMax: 20, diseaseName: ""), 1)
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -20, curLatMax: -10, curLongMin: -20, curLongMax: -10, diseaseName: ""), 2)
		
		XCTAssertEqual(ex3.getWeightForRange(curLatMin: -20, curLatMax: 0, curLongMin: -20, curLongMax: 20, diseaseName: ""), 10)


	}
	
	func initEdgeCase() {
		self.edgeCaseTester = DiseaseManager()
		self.edgeCaseTester.addDisease(lat: 0, long: 0, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: 0, long: 0, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: 0, long: 1, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: -1, long: 1, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: 1, long: -1, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: 50, long: -1, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: -1, long: -1, diseaseName: "")
		self.edgeCaseTester.addDisease(lat: 0, long: -1, diseaseName: "")
	}
	
	func testEdgeCase() {
		initEdgeCase()
		XCTAssertEqual(self.edgeCaseTester.getAll(), 8)
	}

}
