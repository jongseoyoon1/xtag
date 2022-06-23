//
//  XIBView.swift
//  xtag
//
//  Created by Yoon on 2022/05/25.
//

import Foundation
import UIKit

@IBDesignable
open class XIBView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        xibSetup()
    }

    func xibSetup() {
        let view = loadNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        
        loadInit(view)
    }

    func loadInit(_ view:UIView ) {
        
    }
}

extension UIView {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, lineWidth:CGFloat = 1.0 ,  color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        
        borderLayer.strokeColor = color
        borderLayer.lineWidth = lineWidth
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
