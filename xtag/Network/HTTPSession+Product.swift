//
//  HTTPSession+User.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import Foundation
import Alamofire

extension HTTPSession {
    private enum Product: Router {
        case productInfo(url: String)
        case getProductReview(userProductId: String)
        case getProductWithTag(userProductId: String)
        case getUserProduct(userId: String, smallCategoryId: String)
        case getUserProductWithReview(userId: String, smallCategoryId: String)
        //case getProductDetail(userProductId: String)
        case makeProduct(title: String, imageUri: String, link: String, satisfied: String, smallCategoryList: [String], type: String, content: String)
        case updateProductStatus(userProductId: String)
        case getProductDetail(userProductId: String)
        case deleteProduct(userProductId: String)
        
        var path: String {
            switch self {
            case .productInfo(let url):
                return "product/url/info?url=\(url)"
            case .getProductReview(let userProductId):
                return "product/review/\(userProductId)"
            case .getProductWithTag(let userProductId):
                return "post/product/\(userProductId)"
            case .getUserProduct(let userId, let smallCategoryId):
                return "product/user/\(userId)?smallCategoryId=\(smallCategoryId)"
            case .getUserProductWithReview(let userId, let smallCategoryId):
                return "product/user/\(userId)?smallCategoryId=\(smallCategoryId)&status=reviewed"
            case .makeProduct:
                return "product"
            case .updateProductStatus(let userProductId):
                return "product/user/\(userProductId)/status"
            case .getProductDetail(let userProductId):
                return "product/user/\(userProductId)/detail"
            case .deleteProduct(let userProductId):
                return "product/user/\(userProductId)"
            default:
                return ""
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .productInfo:
                return .get
            case .makeProduct:
                return .post
            case .updateProductStatus:
                return .patch
            case .getProductDetail:
                return .get
            case .deleteProduct:
                return .delete
            default:
                return .get
            }
        }
        
        var paramaters: Parameters? {
            var param = Parameters()
            
            switch self {
            case .productInfo(let url):
                break;
            case .makeProduct(let title,let  imageUri,let  link,let  satisfied, let smallCategoryList,let  type,let  content):
                
                var userProduct : [String: Any] = [:]
                userProduct["title"] = title
                userProduct["s3ImageUri"] = ""
                userProduct["cdnImageUri"] = ""
                
                param["userProduct"] = userProduct
                
                var product : [String: Any] = [:]
                
                product["title"] = title
                product["imageUri"] = imageUri
                product["link"] = link
                
                param["product"] = product
                
                param["smallCategoryIdList"] = smallCategoryList
                
                var review : [String: Any] = [:]
                var keywords: [String] = []
                review["satisfied"] = satisfied
                //review["type"] = type
                review["content"] = content
                review["keywords"] = keywords
                
                param["review"] = review
                
            default: break
            }
            
            return param
        }
        
        
    }
    
    func getProductDetail(userProductId: String, completion: @escaping(ProductModel?, Error?) -> Void) {
        
        request(request: Product.getProductDetail(userProductId: userProductId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        completion(ProductModel(JSON: result), nil)
                        
                    }
                    
                    completion(nil,nil)
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func deleteProduct(userProductId: String, completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Product.deleteProduct(userProductId: userProductId)).responseJSON { response in
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
    
    func updateProductStatus(userProductId: String, completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Product.updateProductStatus(userProductId: userProductId)).responseJSON { response in
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
    
    func makeProduct(title: String, imageUri: String, link: String, satisfied: String, smallCategoryList: [String], type: String, content: String,completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Product.makeProduct(title: title, imageUri: imageUri, link: link, satisfied: satisfied, smallCategoryList: smallCategoryList, type: type, content: content)).responseJSON { response in
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
    
    
    func getUserProductWithReview(userId: String, smallCategoryId: String, completion: @escaping([ProductModel]?, Error?) -> Void) {
        
        request(request: Product.getUserProductWithReview(userId:userId, smallCategoryId: smallCategoryId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [ProductModel] = []
                        
                        for rst in result {
                            let post = ProductModel(JSON: rst as! [String:Any])
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
    
    func getUserProduct(userId: String, smallCategoryId: String, completion: @escaping([ProductModel]?, Error?) -> Void) {
        
        request(request: Product.getUserProduct(userId:userId, smallCategoryId: smallCategoryId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [ProductModel] = []
                        
                        for rst in result {
                            let post = ProductModel(JSON: rst as! [String:Any])
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
    
    func getProductWithTag(userProductId: String, completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Product.getProductWithTag(userProductId: userProductId)).responseJSON { response in
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
    
    func getProductReview(userProductId: String, completion: @escaping(ProductReviewModel?, Error?) -> Void) {
        request(request: Product.getProductReview(userProductId: userProductId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        
                        completion(ProductReviewModel(JSON: result),nil)
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
    
    func productInfo(url: String, completion: @escaping(ProductInfoModel?, Error?) -> Void) {
        
        request(request: Product.productInfo(url: url)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        
                        completion(ProductInfoModel(JSON: result),nil)
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

