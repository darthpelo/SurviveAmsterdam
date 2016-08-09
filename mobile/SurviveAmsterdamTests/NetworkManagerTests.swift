//
//  NetworkManagerTests.swift
//  SurviveAmsterdam
//
//  Created by Alessio Roberto on 23/06/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    let networkManager = NetworkManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveProduct() {
        let expectation = self.expectation(description: "Waiting to respond")
        let product = Product(id: nil, name: "pippero", place: "place", productImage: nil, productThumbnail: nil)
        
        networkManager.save(product, userid: getUserID(), onCompletition: { (result) in
            XCTAssertTrue(result)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 30.0, handler:nil)
    }
    
    func testTotalProducts() {
        let expectation = self.expectation(description: "Waiting to respond")
        
        networkManager.getCount({ (count) in
            XCTAssertNotNil(count)
            XCTAssertTrue(count > 0)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler:nil)
    }
    
    func testGetProductsForUser() {
        let expectation = self.expectation(description: "Waiting to respond")
        
        networkManager.getProducts(userid: getUserID()) { (result) in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler:nil)
    }
    
    func testGetProductsForAllUser() {
        let expectation = self.expectation(description: "Waiting to respond")
        
        networkManager.getProducts(userid: nil) { (result) in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler:nil)
    }
    
    func testDeteleProduct() {
        let expectation = self.expectation(description: "Waiting to respond")
        
        let product = Product(id: nil, name: "test", place: "place", productImage: nil, productThumbnail: nil)
        
        networkManager.save(product, userid: getUserID(), onCompletition: { [weak self] (result) in
            XCTAssertTrue(result)
            
            self!.networkManager.delete(product, userid: getUserID()) { (result) in
                XCTAssertTrue(result)
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: 10.0, handler:nil)
    }
    
}
