//
//  XTConfirmButton.swift
//  xtag
//
//  Created by Yoon on 2022/06/22.
//

import UIKit

class XTConfirmButton: UIButton {
    
    @IBInspectable
    var isConfirm: Bool = false {
        didSet {
            setupState(isConfirm)
        }
    }
    
    private func setupState(_ isConfirm: Bool) {
        if isConfirm {
            self.backgroundColor = .white
            self.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
        } else {
            self.backgroundColor = XTColor.GREY_800.getColorWithString()
            self.setTitleColor(XTColor.GREY_400.getColorWithString(), for: [])
        }
    }
}
