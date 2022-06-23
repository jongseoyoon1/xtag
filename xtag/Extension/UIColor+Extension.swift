//
//  UIColor+Extension.swift
//  thehae
//
//  Created by Yoon on 2022/04/26.
//
import UIKit

public extension UIColor {
    convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) {
        let rgba = [red, green, blue, alpha].map { i -> CGFloat in
            switch i {
            case let i where i < 0:
                return 0
            case let i where i > 255:
                return 1
            default:
                return CGFloat(i) / 255
            }
        }
        self.init(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
    }
    
    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex , alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }

}


extension UIColor {
    static func random() -> UIColor {
       return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
}
