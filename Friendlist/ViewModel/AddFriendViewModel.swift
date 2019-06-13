//
//  AddFriendViewModel.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation
final class AddFriendViewModel: FriendViewModel {
    
    var title: String{
        return "Add Friend"
    }
    
    var firstName: String?{
        didSet{
            validateInput()
        }
    }
    
    var lastName: String?{
        didSet{
            validateInput()
        }
    }
    
    var phoneNumber: String?{
        didSet{
            validateInput()
        }
    }
    
    let showLoadingHud: Bindable = Bindable(false)
    
    var updateSubmitButtonState: ((Bool) -> ())?
    var navigateBack: (() -> ())?
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
//    private let appServerClient = AppServerClient()
    
    let appServerClient: AppServerClient
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    
    private var validInputData: Bool = false {
        didSet {
            if oldValue != validInputData {
                updateSubmitButtonState?(validInputData)
            }
        }
    }
    
    func submitFriend() {
        guard let firstName = firstName,
            let lastName = lastName,
            let phoneNumber = phoneNumber else {
                return
        }
        
        updateSubmitButtonState?(false)
        showLoadingHud.value = true
        
        appServerClient.postFriend(firstname: firstName, lastname: lastName, phonenumber: phoneNumber) { [weak self] result in
            self?.showLoadingHud.value = false
            self?.updateSubmitButtonState?(true)
            switch result {
            case .success:
                self?.navigateBack?()
            case .failure(let error):
                let okAlert = SingleButtonAlert(
                    title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                    message: "Could not add \(firstName) \(lastName).",
                    action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                )
                self?.onShowError?(okAlert)
            }
        }
    }
    
    func validateInput() {
        let validData = [firstName, lastName, phoneNumber].filter {
            ($0?.count ?? 0) < 1
        }
        validInputData = (validData.count == 0) ? true : false
    }
}

private extension AppServerClient.PostFriendFailureReason { func getErrorMessage() -> String? {
    switch self {
    case .unAuthorized:
        return "Please login to add friends friends."
    case .notFound:
        return "Failed to add friend. Please try again."
    }
    }
}
