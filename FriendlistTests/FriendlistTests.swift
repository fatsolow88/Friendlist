//
//  FriendlistTests.swift
//  FriendlistTests
//
//  Created by Low Wai Hong on 10/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import XCTest
@testable import Friendlist

class FriendlistTests: XCTestCase {

    func testSuccessfulInit(){
        let testSuccessfulJSON: JSON = ["id" : 1, "firstname": "Jimmy", "lastname": "Swifty", "phonenumber" : "1234567890"]
        XCTAssertNotNil(Friend(json: testSuccessfulJSON))
    }
}
