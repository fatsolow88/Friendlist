//
//  AppServerClient.swift
//  Friendlist
//
//  Created by Low Wai Hong on 10/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import Foundation
import Alamofire

class AppServerClient {
    
    enum GetFriendsFailureReason: Int, Error { //confront to error protocol
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias GetFriendsResult = Result<[Friend], GetFriendsFailureReason> 
    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void
    
    func getFriends(completion: @escaping GetFriendsCompletion){
        Alamofire.request("http://friendservice.herokuapp.com/listFriends")
        .validate() //to see if the request successful (status code 200 ~ 299)
        .responseJSON { response in
            switch response.result { //result of the response
            case .success: //if response = success
                guard let jsonArray = response.result.value as? [JSON] else{ //see if the return value is a form of valid JSON Array
                    completion(.failure(nil)) //if not, fail
                    return
                }
                completion(.success(payload: jsonArray.compactMap({Friend(json: $0)}))) //else pass back the array
                    
            case .failure(_): //if response = failure
                if let statusCode = response.response?.statusCode, //get statusCode
                    let reason = GetFriendsFailureReason(rawValue: statusCode){
                    completion(.failure(reason))
                }
                completion(.failure(nil))
            }
        }
    }
    
    // MARK: - PostFriend
    enum PostFriendFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias PostFriendResult = EmptyResult<PostFriendFailureReason>
    typealias PostFriendCompletion = (_ result: PostFriendResult) -> Void
    
    func postFriend(firstname: String, lastname: String, phonenumber: String, completion: @escaping PostFriendCompletion) {
        let param = ["firstname": firstname,
                     "lastname": lastname,
                     "phonenumber": phonenumber]
        Alamofire.request("https://friendservice.herokuapp.com/addFriend", method: .post, parameters: param, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(.success)
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = PostFriendFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    // MARK: - PatchFriend
    enum PatchFriendFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias PatchFriendResult = Result<Friend, PatchFriendFailureReason>
    typealias PatchFriendCompletion = (_ result: PatchFriendResult) -> Void
    
    func patchFriend(firstname: String, lastname: String, phonenumber: String, id: Int, completion: @escaping PatchFriendCompletion) {
        let param = ["firstname": firstname,
                     "lastname": lastname,
                     "phonenumber": phonenumber]
        Alamofire.request("https://friendservice.herokuapp.com/editFriend/\(id)", method: .patch, parameters: param, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let friendJSON = response.result.value as? JSON,
                        let friend = Friend(json: friendJSON) else {
                            completion(.failure(nil))
                            return
                    }
                    completion(.success(payload: friend))
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = PatchFriendFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    // MARK: - DeleteFriend
    enum DeleteFriendFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias DeleteFriendResult = EmptyResult<DeleteFriendFailureReason>
    typealias DeleteFriendCompletion = (_ result: DeleteFriendResult) -> Void
    
    func deleteFriend(id: Int, completion: @escaping DeleteFriendCompletion) {
        Alamofire.request("https://friendservice.herokuapp.com/editFriend/\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(.success)
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = DeleteFriendFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
}

