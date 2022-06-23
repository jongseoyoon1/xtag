//
//  XTTextField.swift
//  xtag
//
//  Created by Yoon on 2022/05/26.
//

import UIKit

@IBDesignable
class XTTextField: XIBView {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    public var delegate: XTTextFieldDelegate!
    
    @IBInspectable
    public var placeHolderString: String = "" {
        didSet {
            inputTextField.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes: [NSAttributedString.Key.foregroundColor : XTColor.GREY_600.getColorWithString()])
        }
    }
    
    @IBInspectable
    public var maxTextLength : Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        inputTextField.delegate = self
        inputTextField.placeholder = placeHolderString
        
    }
    
    override func loadInit(_ view: UIView) {
        
        inputTextField.delegate = self
        inputTextField.placeholder = placeHolderString
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        if delegate != nil {
            delegate.onCancel()
        }
    }
}

extension XTTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate.textFieldEndEditing(textField.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            return false
        }
        
        let newLength = (textField.text?.count)! + string.count - range.length
          
        if delegate != nil {
            delegate.getTextLength(newLength)
        }
        
        return !(newLength > maxTextLength - 1)
    }
}

protocol XTTextFieldDelegate {
    func onCancel()
    func textFieldEndEditing(_ text: String)
    func getTextLength(_ textCount: Int)
}
