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

class PostDetailModel: Mappable {
    var userId: String?
    var userName: String?
    var userS3ImageUri: String?
    var userCdnImageUri: String?
    var postId: String?
    
    var postImageRatio: String?
    var postType: String?
    var postRegisterDate: String?
    var postRegisterDateEn: String?
    var isMyPost: String?
    
    var isLiked: String?
    var likes: String?
    var comments: String?
    var postCategoryList: [SmallCategoryModel] = []
    var postBodyList: [PostBodyModel] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["userId"]
        userName <- map["userName"]
        userS3ImageUri <- map["userS3ImageUri"]
        userCdnImageUri <- map["userCdnImageUri"]
        postId <- map["postId"]
        
        postType <- map["postType"]
        postImageRatio <- map["postImageRatio"]
        postRegisterDate <- map["postRegisterDate"]
        postRegisterDateEn <- map["postRegisterDateEn"]
        isMyPost <- map["isMyPost"]
        
        isLiked <- map["isLiked"]
        likes <- map["likes"]
        comments <- map["comments"]
        postCategoryList <- map["postCategoryList"]
        postBodyList <- map["postBodyList"]
    }
}

class PostBodyModel: Mappable {
    var postBodyContent: String?
    var postBodyCdnImageUri: String?
    var postBodyS3ImageUri: String?
    var postBodyProductList: [PostBodyProductModel] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        postBodyContent <- map["postBodyContent"]
        postBodyCdnImageUri <- map["postBodyCdnImageUri"]
        postBodyS3ImageUri <- map["postBodyS3ImageUri"]
        postBodyProductList <- map["postBodyProductList"]
    }
}

class PostBodyProductModel: Mappable {
    var product: ProductModel?
    var productXRatio: String?
    var productYRatio: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        product <- map["product"]
        productXRatio <- map["productXRatio"]
        productYRatio <- map["productYRatio"]
    }
}
 
class CommentModel: Mappable {
    var postCommentId: String?
    var postCommentUserId: String?
    var postCommentUserName: String?
    var postCommentUserS3ImageUri: String?
    var postCommentUserCdnImageUri: String?
    var postCommentRegisterDate: String?
    var postCommentRegisterDateEn: String?
    var comment: String?
    var isMyComment: String?
    var hasComentReply: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        postCommentId <- map["postCommentId"]
        postCommentUserId <- map["postCommentUserId"]
        postCommentUserName <- map["postCommentUserName"]
        postCommentUserS3ImageUri <- map["postCommentUserS3ImageUri"]
        postCommentUserCdnImageUri <- map["postCommentUserCdnImageUri"]
        
        postCommentRegisterDate <- map["postCommentRegisterDate"]
        postCommentRegisterDateEn <- map["postCommentRegisterDateEn"]
        comment <- map["comment"]
        isMyComment <- map["isMyComment"]
        hasComentReply <- map["hasComentReply"]
    }
}

class ReplytModel: Mappable {
    var postCommentReplyId: String?
    var postCommentReplyUserId: String?
    var postCommentReplyUserName: String?
    var postCommentReplyUserS3ImageUri: String?
    var postCommentReplyUserCdnImageUri: String?
    var postCommentReplyRegisterDate: String?
    var postCommentRegisterDateEn: String?
    var comment: String?
    var isMyComment: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        postCommentReplyId <- map["postCommentReplyId"]
        postCommentReplyUserId <- map["postCommentReplyUserId"]
        postCommentReplyUserName <- map["postCommentReplyUserName"]
        postCommentReplyUserS3ImageUri <- map["postCommentReplyUserS3ImageUri"]
        postCommentReplyUserCdnImageUri <- map["postCommentReplyUserCdnImageUri"]
        
        postCommentReplyRegisterDate <- map["postCommentReplyRegisterDate"]
        comment <- map["comment"]
        isMyComment <- map["isMyComment"]
    }
}
