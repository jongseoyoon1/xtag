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
            default: break
            }
            
            return param
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

