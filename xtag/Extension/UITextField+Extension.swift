//
//  UITextField+Extension.swift
//  balance
//
//  Created by 윤종서 on 2021/04/02.
//

import UIKit

class FloatingLabelInput: UITextField {
    
    var floatingLabel: UILabel = UILabel(frame: CGRect.zero) // label //CGRect.zero
    var floatingLabelHeight: CGFloat = 20 // default height
    
    
    @IBInspectable
    var _placeholder: String? // cannot override 'placeholder'
    
    @IBInspectable
    var floatingLabelColor: UIColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1) {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = UIColor.clear

    @IBInspectable
    var floatingLabelFont: UIFont = UIFont(name: "NotoSansCJKkr-RegularTTF", size: 14)! {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var validAlertImage: UIImage = UIImage(named: "checkedGreen")!
    
    @IBInspectable
    var invalidAlertImage: UIImage = UIImage(named: "errorChecked")!
    
    @IBInspectable
    var alertMessage: String?
    
    var languageCode: String? {
        didSet {
            if self.isFirstResponder {
                self.resignFirstResponder()
                self.becomeFirstResponder()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder // Use our custom placeholder if none is set
        placeholder = self._placeholder // make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
//<<<<<<< HEAD
//        if self.placeholder != "지역" {
//            self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
//        }
       
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        self.addLeftPadding(16.0)
        self.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        self.layer.cornerRadius = 8
        self.font = UIFont(name: "NotoSansCJKkr-RegularTTF", size: 16)
                
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.clear.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.floatingLabelHeight)
            self.layer.borderColor = self.activeBorderColor.cgColor
            self.addSubview(self.floatingLabel)
            self.floatingLabel.alpha = 0
            
            // Place our label 15pts inside the text field from the top and the left - to show the diagonal animation
            self.floatingLabel.bottomAnchor.constraint(equalTo:
            self.topAnchor, constant: 15).isActive = true
            self.floatingLabel.leftAnchor.constraint(equalTo:
            self.leftAnchor, constant: 15).isActive = true
            
            UILabel.animate(withDuration: 0.2, delay: 0, options: UILabel.AnimationOptions.curveEaseInOut) { [self] in
                self.floatingLabel.transform = CGAffineTransform(translationX: -15, y: -18)
                self.floatingLabel.alpha = 1
            }
            // Remove the placeholder
            if self.placeholder == "소속센터" {
                self.placeholder = "|ex.발란스짐"
            }else{
                self.placeholder = ""
            }
           
            
        }
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            
            UILabel.animate(withDuration: 0.2, delay: 0, options: UILabel.AnimationOptions.curveEaseInOut, animations: {
                self.floatingLabel.transform = .identity
                 self.floatingLabel.alpha = 0
            }, completion: { finished in
                
                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
                self.placeholder = self._placeholder
            })
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func tryLoggingPrimaryLanguageInfoOnKeyboard() {
        for keyboardInputModes in UITextInputMode.activeInputModes {
            if let language = keyboardInputModes.primaryLanguage {
                dump(language)
            }
        }
    }
    
   
    
    override var textInputMode: UITextInputMode? {
        if let language = self.languageCode {
            for keyboardInputModes in UITextInputMode.activeInputModes {
                if let language = keyboardInputModes.primaryLanguage {
                    if language == languageCode {
//                        print("success")
                        return keyboardInputModes
                    }
                }
            }
        }
//        print("failed")
        return super.textInputMode
    }
    
    
}

extension UITextField {
    
    func addLeftPadding(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
     }
    
    func shouldChangeCustomOtp(textField:UITextField, string: String) -> Bool {
        
        //Check if textField has one character
        if ((textField.text?.count)! == 0  && string.count > 0) {
            let nextTag = textField.tag + 1
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)
            if (nextResponder == nil) {
                nextResponder = textField.superview?.viewWithTag(1)
            }
            
            textField.text = textField.text! + string
            //write here your last textfield tag
            if textField.tag == 6 {
                //Dissmiss keyboard on last entry
                textField.resignFirstResponder()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckVerificationCode"), object: nil)
            }
            else {
                ///Appear keyboard
                nextResponder?.becomeFirstResponder()
            }
            return false
        } else if ((textField.text?.count)! == 1  && string.count == 0) {// on deleteing value from Textfield
            
            let previousTag = textField.tag - 1
            // get prev responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            if (previousResponder == nil) {
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false
            
        } else if textField.text?.count == 1 && string.count == 1 {
            let nextTag = textField.tag + 1
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)
            if (nextResponder == nil) {
                nextResponder = textField.superview?.viewWithTag(1)
            }
            
            textField.text = string
            //write here your last textfield tag
            if textField.tag == 6 {
                //Dissmiss keyboard on last entry
                textField.resignFirstResponder()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckVerificationCode"), object: nil)
            }
            else {
                ///Appear keyboard
                nextResponder?.becomeFirstResponder()
            }
            return false
        }
        return true
    }
    
    
    func valid() {
        self.rightViewMode = UITextField.ViewMode.always
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iconView.image = UIImage(named: "checkedGreen")!
        imageContainerView.addSubview(iconView)
        rightView = imageContainerView
        
        self.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        self.textColor = .black
        self.layer.borderWidth = 0
        
    }
    
    func invalid(message: String) {
        self.rightViewMode = UITextField.ViewMode.always
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iconView.image = UIImage(named: "errorChecked")!
        let labelWidth = (message as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansCJKkr-MediumTTF", size: 16) as Any]).width
        let alertLabel = UILabel(frame: CGRect(x: -labelWidth - 5, y: -1, width: labelWidth, height: 20))
        alertLabel.text = message
        alertLabel.font = UIFont(name: "NotoSansCJKkr-MediumTTF", size: 16)
        alertLabel.textColor = #colorLiteral(red: 0.9450980392, green: 0.1137254902, blue: 0.2352941176, alpha: 1)
        alertLabel.textAlignment = .right
        
        
        containerView.addSubview(iconView)
        containerView.addSubview(alertLabel)
        rightView = containerView
        
        self.backgroundColor = .white
        self.textColor = #colorLiteral(red: 0.9450980392, green: 0.1137254902, blue: 0.2352941176, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.1137254902, blue: 0.2352941176, alpha: 1)
        self.layer.borderWidth = 1
    }
    
    func initialState() {
        self.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        self.textColor = .black
        self.layer.borderWidth = 0
        self.rightView?.isHidden = true
    }
    
    
    
}


