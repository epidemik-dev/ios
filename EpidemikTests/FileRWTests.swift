//
//  FileRWTests.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 4/18/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest

class FileRWTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testFileRW() {
		FileRW.deleteFile(fileName: "test.txt");
		XCTAssertEqual(FileRW.fileExists(fileName: "test.txt"), false)
		FileRW.writeFile(fileName: "test.txt", contents: "this is a test")
		XCTAssertEqual(FileRW.readFile(fileName: "test.txt"), "this is a test")
		FileRW.writeFile(fileName: "test.txt", contents: "this is a testssssss")
		XCTAssertEqual(FileRW.readFile(fileName: "test.txt"), "this is a testssssss")
		XCTAssertEqual(FileRW.fileExists(fileName: "test.txt"), true)
		FileRW.deleteFile(fileName: "test.txt");
		XCTAssertEqual(FileRW.fileExists(fileName: "test.txt"), false)
	}
    
}
