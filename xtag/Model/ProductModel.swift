//
//  ProductModel.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import Foundation
import ObjectMapper

class ProductInfoModel: Mappable {
    var title: String?
    var imageUri: String?
    var link: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        imageUri <- map["imageUri"]
        link <- map["link"]
    }
}
