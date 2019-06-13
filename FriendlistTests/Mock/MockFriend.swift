//
//  MockFriend.swift
//  FriendlistTests
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation

extension Friend {
    static func with(id: Int = 0, firstname: String = "Jimmy", lastname: String = "Swift", phonenumber: String = "123123123123123123") -> Friend{
        return Friend(firstName: firstname, lastName: lastname, phoneNumber: phonenumber, id: id)
    }
}
