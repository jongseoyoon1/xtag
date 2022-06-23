//
//  XTCommonButton.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import UIKit

@IBDesignable
class XTCommonButton: XIBView {
    
    @IBOutlet weak var button: UIButton!
    
    @IBInspectable
    public var isSelected: Bool = false {
        didSet {
            setupButton(isSelected)
        }
    }
    
    @IBInspectable
    public var title: String = "" {
        didSet {
            button.setTitle(title, for: [])
        }
    }
    
    public var didTab: (()->Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupButton(false)
    }
    
    override func loadInit(_ view: UIView) {
        
        setupButton(false)
    }
    
    private func setupButton(_ isSelected: Bool) {
        if isSelected {
            button.backgroundColor = XTColor.FLUORESCENT_YELLOW.getColorWithString()
            button.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
        } else {
            button.backgroundColor = XTColor.GREY_900.getColorWithString()
            button.setTitleColor(XTColor.GREY_400.getColorWithString(), for: [])
        }
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        if didTab != nil {
            didTab!()
        }
    }
}
