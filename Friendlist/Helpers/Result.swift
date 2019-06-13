//
//  Result.swift
//  Friendlist
//
//  Created by Low Wai Hong on 10/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation

enum Result<T,U> where U: Error {
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U> where U: Error {
    case success
    case failure(U?)
}

//<T,U>
//use of generic Type to construct this enum
//where - explicitly define the type for U
