//
//  LargeCategory.swift
//  xtag
//
//  Created by Yoon on 2022/05/30.
//

import Foundation
import ObjectMapper

class LargeCategoryModel: Mappable {
    var largeCategoryId: String?
    var largeCategoryColor: String?
    var largeCategoryName: String?
    var largeCategoryNameEn: String?
    var largeCategoryS3ImageUri: String?
    var largeCategoryCdnImageUri: String?
    var smallCategoryList: [SmallCategoryModel] = []
    
    var index = 0
    
    var realName: String?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        largeCategoryId <- map["largeCategoryId"]
        largeCategoryColor <- map["largeCategoryColor"]
        largeCategoryName <- map["largeCategoryName"]
        largeCategoryNameEn <- map["largeCategoryNameEn"]
        largeCategoryS3ImageUri <- map["largeCategoryS3ImageUri"]
        largeCategoryCdnImageUri <- map["largeCategoryCdnImageUri"]
    }
    
}
