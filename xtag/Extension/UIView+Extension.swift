//
//  UIView+Extension.swift
//  balance
//
//  Created by 윤종서 on 2021/03/26.
//

import UIKit
import WebKit
import SwiftUI

class CustomPicker: UIView, UIGestureRecognizerDelegate {
    var picker: UIPickerView = UIPickerView(frame: CGRect.zero)
    var textField: UITextField = UITextField(frame: CGRect.zero)
    //    var isKeyboardShowing: Bool = false
    //    var pickerList: [String] = [] {
    //        didSet {
    //            picker.reloadComponent(0)
    //        }
    //    }
    
    @IBInspectable
    var textFieldFont: UIFont = UIFont(name: "NotoSansCJKkr-DemiLiteTTF", size: 16)! {
        didSet {
            self.textField.font = self.textFieldFont
            self.setNeedsDisplay()
        }
    }
    
    //    @IBInspectable
    //    var pickerMaxValue: Int = 800
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = #colorLiteral(red: 0.3333333333, green: 0.2745098039, blue: 0.9764705882, alpha: 1)
        self.layer.borderWidth = 0
        self.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        
        //        textField.delegate = self
        
        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.tintColor = .clear
        
        picker.frame = CGRect(x: 0, y: textField.frame.size.height / 2 -  30, width: self.frame.size.width, height: 60)
        picker.alpha = 0.1
        
        //        picker.delegate = self
        //        picker.dataSource = self
        
        
        self.addSubview(textField)
        self.addSubview(picker)
        
        self.clipsToBounds = true
        
    }
    
    func disabled() {
        self.layer.borderWidth = 0
    }
    
}


extension UIView {
    func createDottedLine(width: CGFloat, color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [5,3]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: self.frame.height)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    
    func setGradient(color1:UIColor,color2:UIColor){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = bounds
        gradient.cornerRadius = 4
        
        layer.addSublayer(gradient)
    }
    
    func addInnerShadow(topColor: UIColor = UIColor.black.withAlphaComponent(0.3)) {
        let shadowLayer = CAGradientLayer()
        shadowLayer.cornerRadius = layer.cornerRadius
        shadowLayer.frame = bounds
        shadowLayer.frame.size.height = 10.0
        shadowLayer.colors = [
            topColor.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        layer.addSublayer(shadowLayer)
    }
    
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension WKWebView {
    
    var refreshControl: UIRefreshControl? { (scrollView.getAllSubviews() as [UIRefreshControl]).first }
    
    enum PullToRefreshType {
        case none
        case embed
        case custom(target: Any, selector: Selector)
    }
    
    func setPullToRefresh(type: PullToRefreshType) {
        (scrollView.getAllSubviews() as [UIRefreshControl]).forEach { $0.removeFromSuperview() }
        switch type {
        case .none: break
        case .embed: _setPullToRefresh(target: self, selector: #selector(webViewPullToRefreshHandler(source:)))
        case .custom(let params): _setPullToRefresh(target: params.target, selector: params.selector)
        }
    }
    
    private func _setPullToRefresh(target: Any, selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        
        scrollView.addSubview(refreshControl)
        
        refreshControl.topAnchor.constraint(equalTo:
                                                scrollView.topAnchor,
                                            constant: 25).isActive = true
        refreshControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
    }
    
    @objc func webViewPullToRefreshHandler(source: UIRefreshControl) {
        guard let url = self.url else { source.endRefreshing(); return }
        load(URLRequest(url: url))
    }
}

extension UIView {
    
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
    
    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
}

extension UIView{
    func setGradientHorizontal(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    func simpleGradient(color1: UIColor, color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [color1.cgColor, color2.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
    
}

