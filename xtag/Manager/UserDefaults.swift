//
//  UserDefaults.swift
//  xtag
//
//  Created by Yoon on 2022/06/13.
//

import Foundation
import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    var jwt: DefaultsKey<String?> { .init("jwt") }
}
