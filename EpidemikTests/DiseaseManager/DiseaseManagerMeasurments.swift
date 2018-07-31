//
//  EpidemikTests.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 9/15/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import XCTest

class DiseaseManagementMeasurments: XCTestCase {
	
	var chunk: DiseaseManager!
	var numPoints = 1000000
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	func initChunk() {
		chunk = DiseaseManager()
		for _ in 0...self.numPoints {
			chunk.addDisease(lat: 14*drand48() + 30, long: 60*drand48() - 123, diseaseName: "")
		}
	}
	
	func oneRange() {
		_ = chunk.getWeightForRange(curLatMin: 15, curLatMax: 15.1, curLongMin: -113, curLongMax: -113.1, diseaseName: "")
		
	}
	
	func allRange() {
		for x in 0...20 {
			for y in 0...20 {
				_ = chunk.getWeightForRange(curLatMin: Double(14/20*x+30), curLatMax: Double(14/20*(x+1)+30), curLongMin: Double(3*(y)-123), curLongMax: Double(3*(y+1)-123), diseaseName: "")
			}
		}
		
	}
	
	func testGettingAllSuperLotsOfData() {
		self.numPoints = 1000000
		self.initChunk()
		measure {
			self.allRange()
		}
	}
	
	func testGettingRangeSuperLotsOfData() {
		self.numPoints = 1000000
		self.initChunk()
		measure {
			self.oneRange()
		}
	}
	
	func testAddLotsData() {
		self.numPoints = 100000
		measure {
			self.initChunk()
		}
	}
	
	func testGettingAllLotsOfData() {
		self.numPoints = 100000
		self.initChunk()
		measure {
			self.allRange()
		}
	}
	
	func testGettingRangeLotsOfData() {
		self.numPoints = 100000
		self.initChunk()
		measure {
			self.oneRange()
		}
	}
	
	func testAddMediumData() {
		self.numPoints = 5000
		measure {
			self.initChunk()
		}
	}
	
	func testGettingAllMediumData() {
		self.numPoints = 5000
		self.initChunk()
		measure {
			self.allRange()
		}
	}
	
	func testGettingRangeMediumData() {
		self.numPoints = 5000
		self.initChunk()
		measure {
			self.oneRange()
		}
	}
	
	func testAddSmallData() {
		self.numPoints = 500
		measure {
			self.initChunk()
		}
	}
	
	func testGettingAllSmallData() {
		self.numPoints = 500
		self.initChunk()
		measure {
			self.allRange()
		}
	}
	
	func testGettingRangeSmallData() {
		self.numPoints = 500
		self.initChunk()
		measure {
			self.oneRange()
		}
	}
}
