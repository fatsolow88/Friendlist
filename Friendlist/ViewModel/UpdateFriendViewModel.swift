//
//  UpdateFriendViewModel.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation

final class UpdateFriendViewModel: FriendViewModel {
    var friend: Friend
    var title: String {
        return "Update Friend"
    }
    var firstName: String? {
        didSet {
            validateInput()
        }
    }
    var lastName: String? {
        didSet {
            validateInput()
        }
    }
    
    var phoneNumber: String? {
        didSet {
            validateInput()
        }
    }
    
    var validInputData: Bool = false {
        didSet {
            if oldValue != validInputData {
                updateSubmitButtonState?(validInputData)
            }
        }
    }
    
    var updateSubmitButtonState: ((Bool) -> ())?
    var navigateBack: (() -> ())?
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
    let showLoadingHud = Bindable(false)
//    let appServerClient = AppServerClient()
    
    let appServerClient: AppServerClient
    
    init(friend: Friend, appServerClient: AppServerClient = AppServerClient()) {
        self.friend = friend
        self.firstName = friend.firstName
        self.lastName = friend.lastName
        self.phoneNumber = friend.phoneNumber
        self.appServerClient = appServerClient
    }
    
    func submitFriend() {
        guard let firstName = firstName,
            let lastName = lastName,
            let phoneNumber = phoneNumber else {
                return
        }
        
        updateSubmitButtonState?(false)
        showLoadingHud.value = true
        
        appServerClient.patchFriend(firstname: firstName, lastname: lastName, phonenumber: phoneNumber, id: friend.id) { [weak self] result in
            
            self?.updateSubmitButtonState?(true)
            self?.showLoadingHud.value = false
            
            switch result {
            case .success(_):
                self?.navigateBack?()
            case .failure(let error):
                let okAlert = SingleButtonAlert(
                    title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                    message: "Failed to update information.",
                    action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                )
                self?.onShowError?(okAlert)
            }
        }
    }
    
    func validateInput() {
        let validData = [firstName, lastName, phoneNumber].filter {
            ($0?.count ?? 0) > 1 }
        validInputData = (validData.count == 0) ? true : false }
    }

    fileprivate extension AppServerClient.PatchFriendFailureReason {
        func getErrorMessage() -> String? {
            switch self {
            case .unAuthorized:
                return "Please login to update friends friends."
            case .notFound:
                return "Failed to update friend. Please try again."
        }
    }
}
