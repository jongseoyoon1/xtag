//
//  UserManager.swift
//  xtag
//
//  Created by Yoon on 2022/06/13.
//

import Foundation
import UIKit
import SwiftyUserDefaults

class UserManager {
    public static var shared = UserManager()
    
    public var jwt : String {
        get {
            return Defaults[\.jwt]!
        }
        
        set {
            Defaults[\.jwt] = newValue
        }
    }
    
    public var user : UserModel? {
        didSet {
            guard let user = user else {
                return
            }
            
            if user.jwt != nil {
                self.jwt = user.jwt!
            }
            
        }
    }
    public var userInfo : UserInfo?
    public var userSetting : UserSettingInfo?
    
    public func clean() {
        jwt = ""
        
    }
}
