//
//  CommonModel.swift
//  xtag
//
//  Created by Yoon on 2022/06/12.
//

import Foundation
import Alamofire
import ObjectMapper

class CommonResult: Mappable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var pagenation: PagenationModel?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        isSuccess <- map["isSuccess"]
        code <- map["code"]
        message <- map["message"]
        pagenation <- map["pagenation"]
    }
    
}

class PagenationModel: Mappable {
    var pageSize: Int?
    var pageNumber: Int?
    var totalPages: Int?
    var totalElements: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        pageSize <- map["pageSize"]
        pageNumber <- map["pageNumber"]
        totalPages <- map["totalPages"]
        totalElements <- map["totalElements"]
    }
}
