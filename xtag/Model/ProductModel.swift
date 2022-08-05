//
//  ProductModel.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import Foundation
import ObjectMapper

class KeywordModel: Mappable {
    var keyword: String?
    var sindex: String?
    var eindex: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        keyword <- map["keyword"]
        sindex <- map["sindex"]
        eindex <- map["eindex"]
    }
    
}

class ProductReviewModel: Mappable {
    var satisfied: String?
    var content: String?
    var kewords: [KeywordModel] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        satisfied <- map["satisfied"]
        content <- map["content"]
        kewords <- map["kewords"]
    }
}

class ProductInfoModel: Mappable {
    var title: String?
    var imageUri: String?
    var link: String?
    var memo: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        imageUri <- map["imageUri"]
        link <- map["link"]
        memo <- map["memo"]
    }
}

class ProductModel: Mappable {
    required init?(map: Map) {
        
    }
    
    var productCdnImageUri: String?
    var isMyProduct: String?
    var isReviewed: String?
    var userProductCdnImageUri: String?
    var userProductTitle: String?
    
    var userProductId: String?
    var productTitle: String?
    var productS3ImageUri: String?
    var userProductS3ImageUri: String?
    var productImageUri: String?
    var userProductStatus: String?
    
    var productLink: String?
    
    /*
     upload 를 위한 parameter
     */
    var xRatio: String?
    var yRatio: String?
    
    func mapping(map: Map) {
        productCdnImageUri <- map["productCdnImageUri"]
        isMyProduct <- map["isMyProduct"]
        isReviewed <- map["isReviewed"]
        userProductCdnImageUri <- map["userProductCdnImageUri"]
        userProductTitle <- map["userProductTitle"]
        
        userProductId <- map["userProductId"]
        productTitle <- map["productTitle"]
        productS3ImageUri <- map["productS3ImageUri"]
        userProductS3ImageUri <- map["userProductS3ImageUri"]
        productImageUri <- map["productImageUri"]
        userProductStatus <- map["userProductStatus"]
        productLink <- map["productLink"]
    }
}
