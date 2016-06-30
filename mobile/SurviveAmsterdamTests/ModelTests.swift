//
//  ModelTests.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 29/06/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest

class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUser() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let user = getUserID()
        XCTAssertNotNil(user)
        let userTwo = getUserID()
        XCTAssertTrue(user == userTwo)
    }
}
