//
//  MakePostManager.swift
//  xtag
//
//  Created by Yoon on 2022/06/24.
//

import Foundation
import Combine

class MakePostManager {
    public static let shared = MakePostManager()
    
    var productInfo: ProductInfoModel?
    
}

class MakeProductManager {
    public static let shared = MakeProductManager()
    
    var productInfo: ProductInfoModel?
    var productEvaluateState: EvaluateState?
    
    public func `init`() {
        productInfo = nil
        productEvaluateState = nil
    }
}
