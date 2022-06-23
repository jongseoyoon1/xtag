//
//  UIButton+Extension.swift
//  balance
//
//  Created by 윤종서 on 2021/04/06.
//

import UIKit

extension UIButton {
    func enabled(title: String) {
        self.isEnabled = true
        self.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.2745098039, blue: 0.9764705882, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-RegularTTF", size: 20)
        self.layer.cornerRadius = 32
    }
    
    func disabled(title: String) {
        self.isEnabled = false
        self.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.8117647059, blue: 0.8117647059, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1), for: .disabled)
        self.setTitle(title, for: .disabled)
        self.titleLabel?.font = UIFont(name: "NotoSansCJKkr-RegularTTF", size: 20)
        self.layer.cornerRadius = 32
    }
    
    func selected() {
        self.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.2745098039, blue: 0.9764705882, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
    
    func deselected() {
        self.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.968627451, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1), for: .normal)
    }
}

// Inspectable image content mode
extension UIButton {
    /// 0 => .ScaleToFill
    /// 1 => .ScaleAspectFit
    /// 2 => .ScaleAspectFill
    @IBInspectable
    var imageContentMode: Int {
        get {
            return self.imageView?.contentMode.rawValue ?? 0
        }
        set {
            if let mode = UIView.ContentMode(rawValue: newValue),
                self.imageView != nil {
                self.imageView?.contentMode = mode
            }
        }
    }
}
