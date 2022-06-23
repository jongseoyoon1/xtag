//
//  UserModel.swift
//  xtag
//
//  Created by Yoon on 2022/06/13.
//

import Foundation
import Alamofire
import ObjectMapper

class UserModel: Mappable {
    var UserId: String?
    var name: String?
    var jwt: String?
    
    var providerId: String?
    var providerType: String?
    var email: String?
    var isLikeAlarm: String?
    var isCommentAlarm: String?
    var isFollowerAlarm: String?
    
    var fcmToken: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        UserId <- map["UserId"]
        name <- map["name"]
        jwt <- map["jwt"]
    }
    
    
    init() {
        UserId = nil
        name = nil
        jwt = nil
        
        providerId = nil
        providerType = nil
        email = ""
        isLikeAlarm = nil
        isCommentAlarm = nil
        isFollowerAlarm = nil
        
        fcmToken = ""
    }
}

class UserInfo: Mappable {
    required init?(map: Map) {
        
    }
    
    var userId: String?
    var providerType: String?
    var providerId: String?
    var email: String?
    var name: String?
    
    var s3ImageUri: String?
    var cdnImageUri: String?
    var introduction: String?
    var nameModifiedDate : String?
    var nameChangeableDate : String?
    
    var followers: String?
    var followings: String?
    var isFollowed: String?
    var isBlocked: String?
    var isAlarm: String?
    
    var isMyProfile: String?
    
    func mapping(map: Map) {
        userId <- map["userId"]
        providerType <- map["providerType"]
        providerId <- map["providerId"]
        email <- map["email"]
        name <- map["name"]
        
        s3ImageUri <- map["s3ImageUri"]
        cdnImageUri <- map["cdnImageUri"]
        introduction <- map["introduction"]
        nameModifiedDate <- map["nameModifiedDate"]
        nameChangeableDate <- map["nameChangeableDate"]
        
        followers <- map["followers"]
        followings <- map["followings"]
        isFollowed <- map["isFollowed"]
        isBlocked <- map["isBlocked"]
        isAlarm <- map["isAlarm"]
        
        
        isMyProfile <- map["isMyProfile"]
        
    }
}
