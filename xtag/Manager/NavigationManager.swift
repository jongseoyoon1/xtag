//
//  NavigationManager.swift
//  xtag
//
//  Created by Yoon on 2022/06/20.
//

import Foundation
import Combine

class NavigationManager {
    public static var shared = NavigationManager()
    
    public var isCategory : Bool = false
    
    var objectDidChange = PassthroughSubject<Void,Never>()
  
    @Published public var activeBottomBar: Bool = false {
        didSet {
            objectDidChange.send()
        }
    }
}
