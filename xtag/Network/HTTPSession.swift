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


struct FileData {
    enum MimeType {
        case image
        case video
        
        var getMime:String {
            switch self {
            case .image: return "image/png"
            case .video: return "video/mp4"
            }
        }
    }
    
    var data:Data
    var name:String
    var filename:String
    var mimeType:MimeType
}

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
    
    func upload(_ request: URLRequestConvertible,
                filedata:[FileData],
                param:[String:Any]?,
                uploadProgress:@escaping(Progress, UploadRequest)->Void,
                complete:@escaping([String: Any]?, Error?)->Void) -> Void {
        let jwt = Defaults[\.jwt]!
        
        print(jwt)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "X-ACCESS-TOKEN": "\(jwt)"
        ]
        
        
        AF.upload(multipartFormData: { multiPart in
            
            
            for data in filedata {
                multiPart.append(data.data, withName: "imageFileList", fileName: "imageFileList.png", mimeType: "image/jpeg")
            }
            
            for (key, value) in param! {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                
                
                if let temp = value as? NSArray {
                    var index1 = 0
                    temp.forEach({ element in
                        let keyObj = key + "[\(index1)]"
                        index1 += 1
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let temp2 = value as? NSArray {
                            
                            
                            
                            var index2 = 0
                            temp2.forEach({ element2 in
                                
                                (element2 as! NSArray).forEach({ element3 in
                                    let keyObj2 = keyObj + ".userProductInfoList[\(index2)]."
                                    index2 += 1
                                    if let temp3 = element3 as? NSDictionary {
                                        
                                        for (key2, value2) in temp3 {
                                            let keyObj3 = keyObj2 + (key2 as! String)
                                            
                                            if let string2 = value2 as? String {
                                                multiPart.append(string2.data(using: .utf8)!, withName: keyObj3)
                                            } else
                                            if let num2 = value2 as? Int {
                                                let value2 = "\(num2)"
                                                multiPart.append(value2.data(using: .utf8)!, withName: keyObj3)
                                            }
                                        }
                                    }
                                })
                                
                            })
                            
                        }
                    })
                }
            }
            
            
            let mp = multiPart

            print("multiPart = \(mp)")
        }, to: request.urlRequest?.url?.absoluteString ?? ""
                  , headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                switch data.result{
                    
                case .success(_):
                    print("data.result: \(data.result)")
                    do {
                        
                    }catch{
                        
                        print(data.description)
                        print("error")
                    }
                    
                case .failure(let error):
                            print("data.result: \(data.result)")
                    print(error.errorDescription ?? "error")
                }
                //Do what ever you want to do with response
            })
        
    }
    

}

protocol Router: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var paramaters: [String: Any]? { get }
    
}

extension Router {
    private var baseURL: String {
        return BASE_URL_DEV
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.appending(path).asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(Defaults[\.jwt], forHTTPHeaderField: "X-ACCESS-TOKEN")
        //request.setValue("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4NCIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNjU1OTAwNjIxLCJleHAiOjE2NTY3NjQ2MjF9.kGxiZVH-Krx4_z_LMuzGXbauJFt9Jw00bxo03BH4FAc", forHTTPHeaderField: "X-ACCESS-TOKEN")
        
        print("httpMethod = \(request.httpMethod)")
        print("jwt = \(Defaults[\.jwt])")
        
        if request.httpMethod == "POST" {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: paramaters,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                           encoding: .ascii)
                print("JSON string = \(theJSONText!)")
                request.httpBody = theJSONData
            }
        } else if request.httpMethod == "PATCH" {
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
