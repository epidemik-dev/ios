//
//  AddOverlaysTest.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 5/12/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest

class AddOverlaysTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetOverlays() {
		let d1 = Disease(lat: 1, long: 1, diseaseName: "Common Cold", date: Date(), date_healthy: Date())

		let d2 = Disease(lat: 2, long: 1, diseaseName: "Common Cold", date: Date(), date_healthy: Date())
		let d3 = Disease(lat: 3, long: 1, diseaseName: "Common Cold", date: Date(), date_healthy: Date())
		let d4 = Disease(lat: 90, long: 1, diseaseName: "Common Cold", date: Date(), date_healthy: Date())
		let d5 = Disease(lat: 100, long: -1, diseaseName: "Common Cold", date: Date(), date_healthy: Date())

		let map = Map(frame: CGRect(x: 0, y: 0, width: 100, height: 100), settingsButton: UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        let creator = MapOverlayCreator(data: [d1, d2, d3, d4, d5])
		XCTAssertEqual(creator.manager.getAll(), 5)
		XCTAssertEqual(creator.createOverlays(longWidth: 400, latWidth: 400, startLong: -200, startLat: -200, diseaseName: "Common Cold").count, 3)
    }
    
    func testAddOverlaysPreformance() {
		var toUse: Array<Disease> = []
		for _ in 0...100000 {
			toUse.append(Disease(lat: 14*drand48() + 30, long: 14*drand48() + 30, diseaseName: "Common Cold", date: Date(), date_healthy: Date()))
		}
		let creator = MapOverlayCreator(data: toUse)

        self.measure {
			creator.createOverlays(longWidth: 400, latWidth: 400, startLong: -200, startLat: -200, diseaseName: "")
		}
    }
    
}
