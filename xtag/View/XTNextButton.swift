//
//  XTNextButton.swift
//  xtag
//
//  Created by Yoon on 2022/06/05.
//

import Foundation
import UIKit

@IBDesignable
class XTNextButton: XIBView {
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBInspectable
    var isNextButtonHighLight: Bool = false {
        didSet {
            nextButton.isHighlighted = isNextButtonHighLight
            setNextButtonUI(isNextButtonHighLight)
        }
    }
    
    var delegate: XTNextButtonDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func loadInit(_ view: UIView) {
        
        
    }
    
    fileprivate func setNextButtonUI(_ isHighlight: Bool) {
        if isHighlight {
            nextButton.backgroundColor = .white
            nextButton.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
        } else {
            nextButton.backgroundColor = XTColor.GREY_800.getColorWithString()
            nextButton.setTitleColor(XTColor.GREY_400.getColorWithString(), for: [])
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        isNextButtonHighLight = !isNextButtonHighLight
        
    }
    
    
    
}

protocol XTNextButtonDelegate {
    func onNextButton()
}
