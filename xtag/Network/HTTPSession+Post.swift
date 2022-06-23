//
//  HTTPSession+User.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import Foundation
import Alamofire

extension HTTPSession {
    private enum Post: Router {
        case feed(smallCategoryId: String?, page: Int?, size: Int?)
        
        var path: String {
            switch self {
            case .feed(let smallCategoryId,let page,let size):
                return "post/feed"
            default:
                return ""
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .feed:
                return .get
            default:
                return .get
            }
        }
        
        var paramaters: Parameters? {
            var param = Parameters()
            
            switch self {
            case .feed(let smallCategoryId,let page,let size):
                //param["smallCategoryId"] = smallCategoryId
                //param["page"] = page
                //param["size"] = size
                break
            default: break
            }
            
            return param
        }
        
        
    }
    
    func feed(smallCategoryId: String?, page: Int?, size: Int?, completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Post.feed(smallCategoryId: smallCategoryId, page: page, size: size)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [PostModel] = []
                        
                        for rst in result {
                            let post = PostModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }
                        
                        completion(tempPostList,nil)
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

