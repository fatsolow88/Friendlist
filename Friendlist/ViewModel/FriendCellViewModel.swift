//
//  FriendCellViewModel.swift
//  Friendlist
//
//  Created by Low Wai Hong on 10/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation

protocol FriendCellViewModel {
    var friendItem: Friend { get }
    var fullName: String { get }
    var phoneNumberText: String { get }
}

extension Friend: FriendCellViewModel {
    var friendItem: Friend {
        return self
    }
    var fullName: String {
        return firstName + " " + lastName
    }
    var phoneNumberText: String {
        return phoneNumber
    }
}
