//
//  FriendsTableViewViewModelTests.swift
//  FriendlistTests
//
//  Created by Low Wai Hong on 12/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import XCTest
@testable import Friendlist

class FriendsTableViewViewModelTests: XCTestCase {
    
    // MARK: - getFriend
    func testNormalFriendCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.getFriendsResult = .success(payload: [Friend.with()])
        //pre-load mock server with preset friend
        
        let viewModel = FriendsTableViewViewModel(appServerClient: appServerClient)
        viewModel.getFriends()
        //load friends to view model
        
        //wildcard pattern (_) , I don't care about the value of the cell, as long as it's an normal cell
        guard case .some(.normal(_)) = viewModel.friendCells.value.first else {
            XCTFail() //ensure returned friendCells all are valid normal cell or failed
            return
        }
    }

    func testEmptyFriendCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.getFriendsResult = .success(payload: [])
        
        let viewModel = FriendsTableViewViewModel(appServerClient: appServerClient)
        viewModel.getFriends()
        
        guard case .some(.empty) = viewModel.friendCells.value.first else {
            XCTFail() //ensure returned friendCells all are empty normal cell or failed
            return
        }
    }
    
    func testErrorFriendCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.getFriendsResult = .failure(AppServerClient.GetFriendsFailureReason.notFound)
        
        let viewModel = FriendsTableViewViewModel(appServerClient: appServerClient)
        viewModel.getFriends()
        
        //swift > pattern matching > wildcard pattern
        //wildcard pattern (_) , I don't care what kind of error, as long as it's an error type
        //.some , since value is an enum, .some ensure the value.first is not nil before checking if it's an error type cell, but if it's nil , it won't check for cell type, and immediately goes to the failure block
        guard case .some(.error(_)) = viewModel.friendCells.value.first else {
            XCTFail() //ensure returned friendCells all are valid error cell or failed
            return
        }
    }
    
    // MARK: - Delete friend
    func testDeleteFriendSuccess() {
        let appServerClient = MockAppServerClient()
        appServerClient.deleteFriendResult = .success
        appServerClient.getFriendsResult = .success(payload: [Friend.with()])
        //pre-load mock server with preset friend

        let viewModel = FriendsTableViewViewModel(appServerClient: appServerClient)
        viewModel.getFriends() //get friend
        //load friends to view model

        guard case .some(.normal(_)) = viewModel.friendCells.value.first else {
            XCTFail()//ensure returned friendCells all are valid normal cell or failed
            return
        }
        
        appServerClient.getFriendsResult = .success(payload: []) //empty pre-load friend from mock server
        viewModel.deleteFriend(at: 0) //remove friend from viewmodel
        
        guard case .some(.empty) = viewModel.friendCells.value.first else {
            XCTFail()
            return
        }
    }
    
    func testDeleteFriendFailure() {
        let appServerClient = MockAppServerClient()
        appServerClient.deleteFriendResult = .failure(AppServerClient.DeleteFriendFailureReason.notFound)
        
        let viewModel = FriendsTableViewViewModel(appServerClient: appServerClient)
        viewModel.friendCells.value = [Friend.with()].compactMap { .normal(cellViewModel: $0 as FriendCellViewModel)}
        
        let expectErrorShown = expectation(description: "Error note is shown")
        viewModel.onShowError = { _ in
            expectErrorShown.fulfill()
        }
        
        viewModel.deleteFriend(at: 0)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

private final class MockAppServerClient: AppServerClient {
    var getFriendsResult: AppServerClient.GetFriendsResult?
    var deleteFriendResult: AppServerClient.DeleteFriendResult?
    
    override func getFriends(completion: @escaping AppServerClient.GetFriendsCompletion) {
        completion(getFriendsResult!)
    }
    
    override func deleteFriend(id: Int, completion: @escaping AppServerClient.DeleteFriendCompletion) {
        completion(deleteFriendResult!)
    }
}
