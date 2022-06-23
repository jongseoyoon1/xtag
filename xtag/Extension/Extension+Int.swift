//
//  Extension+Int.swift
//  hnstails
//
//  Created by Jinook Mok on 2021/12/01.
//

import Foundation
import UIKit

extension Int {
    var withComma: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
         
        return decimalFormatter.string(from: self as NSNumber)!
    }
    
    //@IBInspectable
    var cgFloat: CGFloat {
        set {
            cgFloat = CGFloat(self)
        }
        
        get {
            return CGFloat(self)
        }
    }
}

extension Float {
    //@IBInspectable
    var cgFloat: CGFloat {
        set {
            cgFloat = CGFloat(self)
        }
        
        get {
            return CGFloat(self)
        }
    }
}
