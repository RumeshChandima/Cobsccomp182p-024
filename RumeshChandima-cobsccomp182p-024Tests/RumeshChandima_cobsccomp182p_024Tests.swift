//
//  RumeshChandima_cobsccomp182p_024Tests.swift
//  RumeshChandima-cobsccomp182p-024Tests
//
//  Created by Geeth Rangana on 2/10/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import XCTest
@testable import RumeshChandima_cobsccomp182p_024

class RumeshChandima_cobsccomp182p_024Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEmail(){
        
       XCTAssert(Validation.isValidInput("user@mail.com"), "Success")
        
    }
    
    func testPassword()
    {
         XCTAssert(Validation.isValidInput("123456"), "Success")
    }
    

}
