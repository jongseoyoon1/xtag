//
//  HTTPSession+User.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import Foundation
import Alamofire

extension HTTPSession {
    private enum User: Router {
        case login(providerId: String, fcmToken: String)
        case getUser
        case getUserProfile(userId: String)
        case signUp
        case getUserSetting
        case getUserCategory(userId: String)
        case getNotification(status: String)
        case updateUserCategory(removeSmallCategoryIdList: [String], addSmallCategoryIdList: [String])
        case userFollow(removeSmallCategoryIdList: [String], addSmallCategoryIdList: [String], userId: String)
        case updateNotification(type: String)
        case getBlockUser(page: String, size: String)
        case deleteBlockUser(userId: String)
        case getFollowingUser(smallCategoryId: String, page: String, size: String)
        
        var path: String {
            switch self {
            case .login:
                return "user/sign-in"
            case .getUser:
                return "user/jwt"
            case .getUserProfile(let userId):
                return "user/profile/\(userId)"
            case .signUp:
                return "user/sign-up"
            case .getUserSetting:
                return "user/jwt"
            case .getUserCategory(let userId):
                return "category/user/\(userId)"
            case .getNotification(let status):
                return "user/notification?status=\(status)"
            case .updateUserCategory:
                return "category/user"
            case .userFollow(let removeSmallCategoryIdList ,let addSmallCategoryIdList, let userId):
                return "category/user/follow/\(userId)"
            case .updateNotification(let type):
                return "user/alarm?type=\(type)"
            case .getBlockUser(let page,let size):
                return "user/block?page=\(page)&size=\(size)"
            case .deleteBlockUser(let userId):
                return "user/block/\(userId)"
            case .getFollowingUser(let smallCategoryId,let  page,let  size):
                print("user/followings/smallCategoryId=\(smallCategoryId)&page=\(page)&size=\(size)")
                return "user/followings?smallCategoryId=\(smallCategoryId)&page=\(page)&size=\(size)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .login:
                return .post
            case .getUser:
                return .get
            case .getUserProfile:
                return .get
            case .signUp:
                return .post
            case .getUserSetting:
                return .get
            case .getUserCategory:
                return .get
            case .getNotification:
                return .get
            case .updateUserCategory:
                return .patch
            case .userFollow:
                return .patch
            case .updateNotification:
                return .patch
            case .getBlockUser:
                return .get
            case .deleteBlockUser:
                return .delete
            case .getFollowingUser:
                return .get
            }
        }
        
        var paramaters: Parameters? {
            var param = Parameters()
            
            switch self {
            case .login(let providerId, let fcmToken):
                param["providerId"] = providerId
                param["fcmToken"] = fcmToken
            case .signUp:
                param["providerId"] = SignUpManager.shared.userInfo.providerId!
                param["providerType"] = SignUpManager.shared.userInfo.providerType!
                param["email"] = SignUpManager.shared.userInfo.email!
                param["name"] = SignUpManager.shared.userInfo.name!
                param["fcmToken"] = SignUpManager.shared.userInfo.fcmToken!
            case .updateUserCategory(let removeSmallCategoryIdList, let addSmallCategoryIdList):
                param["removeSmallCategoryIdList"] = removeSmallCategoryIdList
                param["addSmallCategoryIdList"] = addSmallCategoryIdList
            case .userFollow(let removeSmallCategoryIdList ,let addSmallCategoryIdList, let userId):
                param["removeSmallCategoryIdList"] = removeSmallCategoryIdList
                param["addSmallCategoryIdList"] = addSmallCategoryIdList
            case .updateNotification:
                //param["type"] = type
                break
                
            default: break
            }
            
            return param
        }
        
        
    }
    
    func getFollowingUser(smallCategoryId: String, page: String, size: String, completion: @escaping([BlockUserModel]?, PagenationModel?,Error?) -> Void) {
        request(request: User.getFollowingUser(smallCategoryId: smallCategoryId,page: page, size: size)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>],
                    let pagenation = dict["pagination"] as? Dictionary<String, Any> {
                        let pagenation = PagenationModel(JSON: pagenation)
                        
                        var blockUserList : [BlockUserModel] = []
                        
                        for rst in result {
                            blockUserList.append(BlockUserModel(JSON: rst)!)
                        }
                        
                        completion(blockUserList, pagenation, nil)
                    }
                    
                } else {
                    completion(nil, nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, nil,error)
            }
        
        }
    }
    
    func deleteBlockUser(userId: String, completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: User.deleteBlockUser(userId: userId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        
                    }
                    
                    completion(dict,nil)
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getBlockUser(page: String, size: String, completion: @escaping([BlockUserModel]?, PagenationModel?,Error?) -> Void) {
        request(request: User.getBlockUser(page: page, size: size)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>],
                    let pagenation = dict["pagination"] as? Dictionary<String, Any> {
                        let pagenation = PagenationModel(JSON: pagenation)
                        
                        var blockUserList : [BlockUserModel] = []
                        
                        for rst in result {
                            blockUserList.append(BlockUserModel(JSON: rst)!)
                        }
                        
                        completion(blockUserList, pagenation, nil)
                    }
                    
                } else {
                    completion(nil, nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, nil,error)
            }
        
        }
    }
    
    func updateNotification(type: String, completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: User.updateNotification(type: type)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        
                    }
                    
                    completion(dict,nil)
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getNotification(status: String, completion: @escaping([NotificationModel]?, Error?) -> Void) {
        request(request: User.getNotification(status: status)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var list : [NotificationModel] = []
                        
                        for notification in result {
                            list.append(NotificationModel(JSON: notification)!)
                        }
                   
                        completion(list ,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func userFollow(removeSmallCategoryIdList: [String], addSmallCategoryIdList: [String], userId: String,completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: User.userFollow(removeSmallCategoryIdList: removeSmallCategoryIdList, addSmallCategoryIdList:addSmallCategoryIdList, userId: userId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        
                    }
                    
                    completion(dict,nil)
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func updateUserCategory(removeSmallCategoryIdList: [String], addSmallCategoryIdList: [String],completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: User.updateUserCategory(removeSmallCategoryIdList: removeSmallCategoryIdList, addSmallCategoryIdList:addSmallCategoryIdList)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        
                    }
                    
                    completion(dict,nil)
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    
    func getUserSetting(completion: @escaping(UserSettingInfo?, Error?) -> Void) {
        request(request: User.getUserSetting).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        completion(UserSettingInfo(JSON: result as! [String:Any]),nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func login(providerId: String, fcmToken: String,completion: @escaping(UserModel?, Error?) -> Void) {
        
        request(request: User.login(providerId: providerId, fcmToken: fcmToken)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        completion(UserModel(JSON: result as! [String:Any]),nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func signUp(completion: @escaping(UserModel?, Error?) -> Void) {
        request(request: User.signUp).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        completion(UserModel(JSON: result as! [String:Any]),nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getUser(completion: @escaping(UserModel?, Error?) -> Void) {
        request(request: User.getUser).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        completion(UserModel(JSON: result as! [String:Any]),nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getUserProfile(userId: String, completion: @escaping(UserInfo?, Error?) -> Void) {
        request(request: User.getUserProfile(userId: userId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        completion(UserInfo(JSON: result as! [String:Any]),nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
}

