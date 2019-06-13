//
//  FriendViewModel.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation

protocol FriendViewModel {
    var title: String {get}
    var firstName: String? {get set} //the VM has no default initializer, the value could be nil by default 
    var lastName: String? {get set}
    var phoneNumber: String? {get set}
    var showLoadingHud: Bindable<Bool> { get }

    var updateSubmitButtonState: ((Bool) -> ())? {get set}
    var navigateBack: (() -> ())? {get set}
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)? {get set}
    
    func submitFriend()
}
