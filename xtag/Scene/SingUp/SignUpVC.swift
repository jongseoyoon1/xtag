//
//  SignUpVC.swift
//  xtag
//
//  Created by Yoon on 2022/05/26.
//

import UIKit

class SignUpVC: BaseViewController {
    
    @IBOutlet weak var navigationBar: XTNavigationBar!
    @IBOutlet weak var inputTextField: XTTextField!
    @IBOutlet weak var cautionLabel: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    
    @IBOutlet weak var confirmButton: XTConfirmButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    private func setupUI() {
        cautionLabel.isHidden = true
        inputTextField.delegate = self
        navigationBar.delegate = self
        
        inputTextField.inputTextField.text = SignUpManager.shared.userInfo.email
        textCountLabel.text = "\(SignUpManager.shared.userInfo.email!.count)/64"
        updateCountLabel()
    }
    
    private func updateCountLabel() {
        if textCountLabel.text?.count == 4 {
            textCountLabel.attributedText = applyAttributedString(textCountLabel.text!, 1)
        } else {
            textCountLabel.attributedText = applyAttributedString(textCountLabel.text!, 2)
        }
        
        checkValidEmail(testStr: inputTextField.inputTextField.text!)
    }
    
    fileprivate func applyAttributedString(_ text: String,_ length: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13)!,
            .foregroundColor: XTColor.GREY_500.getColorWithString(),
            
        ])
        
        let range = NSRange.init(location: 0, length: length)
        attributedString.addAttribute(
            .font,
            value: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13.0)!,
            range: range)
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.white,
            range: range)
        
        return attributedString
    }
    
    func checkValidEmail(testStr: String) {
        if isValidEmail(testStr: testStr) {
            cautionLabel.isHidden = true
            confirmButton.isConfirm = true
        } else {
            cautionLabel.isHidden = true
            confirmButton.isConfirm = false
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        if confirmButton.isConfirm {
            if let viewcontroller = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpNickNameVC") as? SignUpNickNameVC {
                viewcontroller.modalPresentationStyle = .fullScreen
                viewcontroller.modalTransitionStyle = .crossDissolve
                
                self.present(viewcontroller, animated: true)
            }
        } else {
        }
    }
}

extension SignUpVC: XTTextFieldDelegate {
    func textFieldEndEditing(_ text: String) {
        print("end editing = \(text)")
    }
    
    func onCancel() {
        inputTextField.inputTextField.text = ""
        textCountLabel.text = "\(0)/64"
        updateCountLabel()
    }
    
    func getTextLength(_ textCount: Int) {
        textCountLabel.text = "\(textCount)/64"
        updateCountLabel()
    }
}

extension SignUpVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func onMore() {
        
    }
    
    
}
