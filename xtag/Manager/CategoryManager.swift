//
//  FilterManager.swift
//  xtag
//
//  Created by Yoon on 2022/06/20.
//

import Foundation
import Combine

class CategoryManager {
    public static var shared = CategoryManager()
    
    public var largeCategoryList : [LargeCategoryModel] = []
    
    var objectDidChange = PassthroughSubject<Void,Never>()
    
    @Published public var isOpen: Bool = false {
        didSet {
            objectDidChange.send()
        }
    }
    
    @Published public var mainSelectedSmallCategory : SmallCategoryModel? {
        didSet {
            objectDidChange.send()
        }
    }
    
    @Published public var bottomBarIsOpen: Bool = true {
        didSet {
            objectDidChange.send()
        }
    }
    
    
}
