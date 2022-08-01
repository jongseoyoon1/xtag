//
//  UserModel.swift
//  xtag
//
//  Created by Yoon on 2022/06/13.
//

import Foundation
import Alamofire
import ObjectMapper

class BlockUserModel: Mappable {
    var userId: String?
    var userName: String?
    var userS3ImageUri: String?
    var userCdnImageUri: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]
        userName <- map["userName"]
        userS3ImageUri <- map["userS3ImageUri"]
        userCdnImageUri <- map["userCdnImageUri"]
    }
}

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

class UserSettingInfo: Mappable {
    required init?(map: Map) {
        
    }
    
    var userId: String?
    var providerType: String?
    var providerId: String?
    var email: String?
    var name: String?
    
    var isLikeAlarm: String?
    var isCommentAlarm: String?
    var isFollowerAlarm: String?
    
    func mapping(map: Map) {
        userId <- map["userId"]
        providerType <- map["providerType"]
        providerId <- map["providerId"]
        email <- map["email"]
        name <- map["name"]
        
        isLikeAlarm <- map["isLikeAlarm"]
        isCommentAlarm <- map["isCommentAlarm"]
        isFollowerAlarm <- map["isFollowerAlarm"]
        
    }
}

class SenderModel: Mappable {
    required init?(map: Map) {
        
    }
    
    var userId: String?
    var userName: String?
    var userS3ImageUri: String?
    var userCdnImageUri: String?
    
    func mapping(map: Map) {
        userId <- map["userId"]
        userName <- map["userName"]
        userS3ImageUri <- map["userS3ImageUri"]
        userCdnImageUri <- map["userCdnImageUri"]
        
    }
}

class NotificationPostModel: Mappable {
    required init?(map: Map) {
        
    }
    
    var postId: String?
    var postS3ImageUri: String?
    var postCdnImageUri: String?
    var postImageRatio: String?
    var isMyPost: String?
    
    func mapping(map: Map) {
        postId <- map["postId"]
        postS3ImageUri <- map["postS3ImageUri"]
        postCdnImageUri <- map["postCdnImageUri"]
        postImageRatio <- map["postImageRatio"]
        isMyPost <- map["isMyPost"]
        
    }
}

class NotificationModel: Mappable {
    required init?(map: Map) {
        
    }
    
    var id: String?
    var type: String?
    var sender: SenderModel?
    var post: NotificationPostModel?
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        sender <- map["sender"]
        post <- map["post"]
        
    }
}
