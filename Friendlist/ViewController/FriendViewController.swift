//
//  FriendViewController.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

final class FriendViewController: UIViewController {
    @IBOutlet weak var textFieldFirstname: UITextField! {
        didSet {
            textFieldFirstname.delegate = self
            textFieldFirstname.addTarget(self, action:
                #selector(firstnameTextFieldDidChange),
                                         for: .editingChanged)
        }
    }
    @IBOutlet weak var textFieldLastname: UITextField! {
        didSet {
            textFieldLastname.delegate = self
            textFieldLastname.addTarget(self, action:
                #selector(lastnameTextFieldDidChange),
                                        for: .editingChanged)
        }
    }
    @IBOutlet weak var textFieldPhoneNumber: UITextField! {
        didSet {
            textFieldPhoneNumber.delegate = self
            textFieldPhoneNumber.addTarget(self, action:
                #selector(phoneNumberTextFieldDidChange),
                                           for: .editingChanged)
        }
    }
    
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var updateFriends: (() -> Void)?
    var viewModel: FriendViewModel?
    
    fileprivate var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    @objc func firstnameTextFieldDidChange(textField: UITextField){
        viewModel?.firstName = textField.text ?? ""
    }
    
    @objc func lastnameTextFieldDidChange(textField: UITextField){
        viewModel?.lastName = textField.text ?? ""
    }
    
    @objc func phoneNumberTextFieldDidChange(textField: UITextField){
        viewModel?.phoneNumber = textField.text ?? ""
    }
    
    func bindViewModel() {
        title = viewModel?.title
        textFieldFirstname?.text = viewModel?.firstName ?? ""
        textFieldLastname?.text = viewModel?.lastName ?? ""
        textFieldPhoneNumber?.text = viewModel?.phoneNumber ?? ""
        
        viewModel?.showLoadingHud.bind {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            $0 ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
        }
        
        viewModel?.updateSubmitButtonState = { [weak self] state in
            self?.buttonSubmit?.isEnabled = state
        }
        
        viewModel?.navigateBack = { [weak self] in
            self?.updateFriends?()
            let _ = self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel?.onShowError = { [weak self] alert in
            let alertController = UIAlertController(title: alert.title,
                                                    message: alert.message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                    style: .default,
                                                    handler: { _ in alert.action.handler?() }))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Actions
extension FriendViewController {
    @IBAction func rootViewTapped(_ sender: Any) {
        activeTextField?.resignFirstResponder()
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        viewModel?.submitFriend()
    }
}

// MARK: - UITextFieldDelegate
extension FriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
