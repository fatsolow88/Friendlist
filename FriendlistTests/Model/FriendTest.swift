//
//  FriendTest.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import XCTest
@testable import Friendlist

class FriendTest: XCTestCase {

    func testSuccessfulInit(){
        let testSuccessfulJSON: JSON = ["id" : 1, "firstname": "Jimmy", "lastname": "Swifty", "phonenumber" : "1234567890"]
        XCTAssertNotNil(Friend(json: testSuccessfulJSON))
    }

}
