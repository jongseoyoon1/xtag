//
//  SmallCategory.swift
//  xtag
//
//  Created by Yoon on 2022/06/20.
//

import Foundation
import ObjectMapper

class SmallCategoryModel: Mappable {
    var largeCategoryId: String?
    var smallCategoryId: String?
    var smallCategoryColor: String?
    var smallCategoryName: String?
    var smallCategoryEn: String?
    var smallCategoryS3ImageUn: String?
    var smallCategoryCdnImageUn: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        largeCategoryId <- map["largeCategoryId"]
        smallCategoryId <- map["smallCategoryId"]
        smallCategoryColor <- map["smallCategoryColor"]
        smallCategoryName <- map["smallCategoryName"]
        smallCategoryEn <- map["smallCategoryEn"]
        smallCategoryS3ImageUn <- map["smallCategoryS3ImageUn"]
        smallCategoryCdnImageUn <- map["smallCategoryCdnImageUn"]
    }
}
