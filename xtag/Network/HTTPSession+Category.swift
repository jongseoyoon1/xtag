//
//  HTTPSession+Category.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import Alamofire

extension HTTPSession {
    private enum Category: Router {
        case categoryLarge
        case categorySmall(largeCategoryId: String)
        case categorySearch(keyword: String)
        case getUserCategory(userId: String)
        
        case getFollowCategoryAll
        
        var path: String {
            switch self {
            case .categoryLarge:
                return "category"
            case .categorySmall(let largeCategoryId):
                return "category/\(largeCategoryId)/small"
            case .categorySearch(let keyword):
                return "category/small/search?keyword=\(keyword)"
            case .getUserCategory(let userId):
                return "category/user/\(userId)/all"
            case .getFollowCategoryAll:
                return "category/user/follow/all"
            default:
                return ""
            }
        }
        
        var method: HTTPMethod {
            switch self {
            default:
                return .get
            }
        }
        
        var paramaters: Parameters? {
            var param = Parameters()
            
            switch self {
            default: break
            }
            
            return param
        }
        
    }
    
    func getFollowCategoryAll(completion: @escaping([SmallCategoryModel]?, Error?) -> Void) {
        request(request: Category.getFollowCategoryAll).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    
                    
                    
                    if let data = dict["result"] as? [Dictionary<String, Any>] {
                        var result : [SmallCategoryModel] = []
                        for dt in data {
                            let rst = SmallCategoryModel(JSON: dt as! [String:Any])
                            result.append(rst!)
                        }
                        
                        completion(result,nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                completion(nil, error)
            }
        
        }
        
    }
    
    func categorySmall(largeCategoryId: String, completion: @escaping([SmallCategoryModel]?, Error?) -> Void) {
        request(request: Category.categorySmall(largeCategoryId: largeCategoryId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    
                    
                    
                    if let data = dict["result"] as? [Dictionary<String, Any>] {
                        var result : [SmallCategoryModel] = []
                        for dt in data {
                            let rst = SmallCategoryModel(JSON: dt as! [String:Any])
                            result.append(rst!)
                        }
                        
                        completion(result,nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                completion(nil, error)
            }
        
        }
        
    }
    
    func getUserCategory(userId: String, completion: @escaping([SmallCategoryModel]?, Error?) -> Void) {
        request(request: Category.getUserCategory(userId: userId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    
                    
                    
                    if let data = dict["result"] as? [Dictionary<String, Any>] {
                        var result : [SmallCategoryModel] = []
                        for dt in data {
                            let rst = SmallCategoryModel(JSON: dt as! [String:Any])
                            result.append(rst!)
                        }
                        
                        completion(result,nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                completion(nil, error)
            }
        
        }
        
    }
    
    func categoryLarge(completion: @escaping([LargeCategoryModel]?, Error?) -> Void) {
        
        request(request: Category.categoryLarge).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    
                    
                    
                    if let data = dict["result"] as? [Dictionary<String, Any>] {
                        var result : [LargeCategoryModel] = []
                        for dt in data {
                            let rst = LargeCategoryModel(JSON: dt as! [String:Any])
                            result.append(rst!)
                        }
                        
                        completion(result,nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                completion(nil, error)
            }
        
        }
    }
    
    
}
