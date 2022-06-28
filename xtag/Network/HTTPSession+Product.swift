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
        
        var path: String {
            switch self {
            case .productInfo(let url):
                return "product/url/info?url=\(url)"
            default:
                return ""
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .productInfo:
                return .get
            default:
                return .get
            }
        }
        
        var paramaters: Parameters? {
            var param = Parameters()
            
            switch self {
            case .productInfo(let url):
                break;
            default: break
            }
            
            return param
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

