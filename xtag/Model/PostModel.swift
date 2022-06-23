//
//  PostModel.swift
//  xtag
//
//  Created by Yoon on 2022/06/14.
//

import Foundation
import Alamofire
import ObjectMapper

class PostModel: Mappable {
    var userId: String?
    var userName: String?
    var userS3ImageUri: String?
    var userCdnImageUri: String?
    var postId: String?
    
    var postType: String?
    var postImageRatio: String?
    var postS3ImageUri: String?
    var postCdnImageUri: String?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]
        userName <- map["userName"]
        userS3ImageUri <- map["userS3ImageUri"]
        userCdnImageUri <- map["userCdnImageUri"]
        postId <- map["postId"]
        
        postType <- map["postType"]
        postImageRatio <- map["postImageRatio"]
        postS3ImageUri <- map["postS3ImageUri"]
        postCdnImageUri <- map["postCdnImageUri"]
    }
    
}
