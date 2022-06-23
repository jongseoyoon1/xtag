//
//  HTTPSession.swift
//  OrderOne
//
//  Created by Yoon on 2021/11/03.
//
//
import Alamofire
import PKHUD
import Foundation
import SwiftyUserDefaults

let BASE_URL_DEV = "http://dev.xlab.io:8080/v1/"
let BASE_URL = "https://api.xlab.io/v1/"

class HTTPSession {

    static let shared = HTTPSession()
        
    private var configuration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        //URLSessionConfiguration.background(withIdentifier: "com.sazapalza.www.sazapalza.brint.background")
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 600
        
        return configuration
    }
    
    private lazy var sessionManager: Session = Alamofire.Session(configuration: configuration)
    
    @discardableResult
    func request(request: URLRequestConvertible, isProgress:Bool = true) -> DataRequest {
        let dataRequest = sessionManager.request(request)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json", "application/x-www-form-urlencoded", "text/json", "text/plain", "text/html"])
        if NetworkReachabilityManager()?.isReachable ?? false {
            if isProgress {
                //SVProgressHUD.show()
                
            }
            dataRequest.validate { (urlRequest, response, data) -> Request.ValidationResult in
                //SVProgressHUD.dismiss()
                let statusCode = response.statusCode
                if statusCode == 200 || statusCode == 201 {
                    //return .success(data)
                    return .success(Void())
                } else {
                    // 기본 http response 에러
                    let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    return .failure(NSError(domain: NSURLErrorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message]))
                }
            }
        } else {
            //SVProgressHUD.dismiss()
            //UIAlertController.showAlert(title: "네트워크", message: "네트워크가 불안정합니다.\nWIFI/LTE 상태를 확인해주세요.", cancelTitle: nil, defaultTitle: "확인", handler: nil)
        }
        
        return dataRequest
    }
    
    @discardableResult
    func requestWithOutLoading(request: URLRequestConvertible, isProgress:Bool = true) -> DataRequest {
        let dataRequest = sessionManager.request(request)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json", "text/json", "text/plain", "text/html"])
        if NetworkReachabilityManager()?.isReachable ?? false {
            if isProgress {
                
            }
            dataRequest.validate { (urlRequest, response, data) -> Request.ValidationResult in
                PKHUD.sharedHUD.hide()
                let statusCode = response.statusCode
                if statusCode == 200 || statusCode == 201 {
                    //return .success(data)
                    return .success(Void())
                } else {
                    // 기본 http response 에러
                    let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    return .failure(NSError(domain: NSURLErrorDomain, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message]))
                }
            }
        } else {
            //SVProgressHUD.dismiss()
            //UIAlertController.showAlert(title: "네트워크", message: "네트워크가 불안정합니다.\nWIFI/LTE 상태를 확인해주세요.", cancelTitle: nil, defaultTitle: "확인", handler: nil)
        }
        
        return dataRequest
    }
    
    

}

protocol Router: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var paramaters: [String: Any]? { get }
    
}

extension Router {
    private var baseURL: String {
        return BASE_URL
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.appending(path).asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(Defaults[\.jwt], forHTTPHeaderField: "X-ACCESS-TOKEN")
        //request.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4NCIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNjU1OTAwNjIxLCJleHAiOjE2NTY3NjQ2MjF9.kGxiZVH-Krx4_z_LMuzGXbauJFt9Jw00bxo03BH4FAc", forHTTPHeaderField: "X-ACCESS-TOKEN")
        
        print("httpMethod = \(request.httpMethod)")
        
        if request.httpMethod == "POST" {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: paramaters,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                           encoding: .ascii)
                print("JSON string = \(theJSONText!)")
                request.httpBody = theJSONData
            }
        }
        
        
        
        return try URLEncoding().encode(request, with: nil)
            //URLEncoding.methodDependent.encode(request, with: paramaters)
    }
}
