//
//  Extension+UIView.swift
//  tales-ios
//
//  Created by 홍필화 on 2021/10/20.
//

import Foundation
import UIKit

extension UIView {
    var mr_x: CGFloat {
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        
        get {
            return self.frame.origin.x
        }
    }
    var mr_y: CGFloat {
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        
        get {
            return self.frame.origin.y
        }
    }
    var mr_left: CGFloat {
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        
        get {
            return self.frame.origin.x
        }
    }
    var mr_top: CGFloat {
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        
        get {
            return self.frame.origin.y
        }
    }
    var mr_right: CGFloat {
        set {
            var rect = self.frame
            rect.origin.x = newValue - frame.size.width
            self.frame = rect
        }
        
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    
    var mr_height: CGFloat {
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
        
        get {
            return self.frame.size.height
        }
    }
    var mr_bottom: CGFloat {
        set {
            var rect = self.frame
            rect.origin.y = newValue - frame.size.height
            self.frame = rect
        }
        
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    var mr_width: CGFloat {
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
        
        get {
            return self.frame.size.width
        }
    }
    
    var isDeleteSelected: Bool {
        set {
            if newValue {
                self.backgroundColor = #colorLiteral(red: 0.8960424066, green: 0.149099499, blue: 0.2946681678, alpha: 0.8)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.1928582191, green: 0.441696465, blue: 0.9950782657, alpha: 0.8)
            }
            
        }
        
        get {
            if self.backgroundColor == #colorLiteral(red: 0.8960424066, green: 0.149099499, blue: 0.2946681678, alpha: 0.8) {
                return true
            } else {
                return false
            }
            
        }
    }
}

