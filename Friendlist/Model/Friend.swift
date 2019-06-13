//
//  Friend.swift
//  Friendlist
//
//  Created by Low Wai Hong on 10/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

struct Friend{
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let id: Int
}

extension Friend{
    init?(json: JSON){
        guard let id = json["id"] as? Int,
            let firstName = json["firstname"] as? String,
            let lastName = json["lastname"] as? String,
            let phoneNumber = json["phonenumber"] as? String else {
                return nil
        }
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}
