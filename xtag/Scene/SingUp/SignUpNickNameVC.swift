//
//  SignUpVC.swift
//  xtag
//
//  Created by Yoon on 2022/05/26.
//

import UIKit

class SignUpNickNameVC: BaseViewController {
    
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
        if isValidateName(testStr: testStr) {
            cautionLabel.isHidden = true
            confirmButton.isConfirm = true
        } else {
            
            cautionLabel.isHidden = true
            confirmButton.isConfirm = false
        }
    }
    
    func isValidateName(testStr:String) -> Bool {
        
        if testStr.count > 0 {
            if String(testStr.last!).contains(".") {
                cautionLabel.text = "아이디 끝에 마침표를 사용할 수 없어요."
                print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
                return false
            }
        }
        
        let regStringEx = "^(?=.*[!@#$%^&*()_+=-]).{8,20}"
        let regTest = NSPredicate(format: "SELF MATCHES %@", regStringEx)
        let lastRegStringEx = "[A-Z0-9a-z]"
        let lastRegTest = NSPredicate(format: "SELF MATCHES %@", lastRegStringEx)
        
        if regTest.evaluate(with: testStr) {
            if lastRegTest.evaluate(with: testStr) {
                cautionLabel.text = "특수문자는 단독으로 사용할 수 없어요."
                print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB")
                return false
            }
        }
        
        
        return true
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        if confirmButton.isConfirm {
            SignUpManager.shared.userInfo.name = inputTextField.inputTextField.text
            
            HTTPSession.shared.signUp { result, error in
                if error == nil {
                    UserManager.shared.user = result
                    
                    if let viewcontroller = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpCategoryVC") as? SignUpCategoryVC {
                        
                        viewcontroller.modalPresentationStyle = .fullScreen
                        viewcontroller.modalTransitionStyle = .crossDissolve
                        
                        self.present(viewcontroller, animated: true)
                    }
                }
            }
            
            
        } else {
        }
    }
}

extension SignUpNickNameVC: XTTextFieldDelegate {
    func textFieldEndEditing(_ text: String) {
        print("end editing = \(text)")
    }
    
    func onCancel() {
        inputTextField.inputTextField.text = ""
        textCountLabel.text = "\(0)/30"
        updateCountLabel()
    }
    
    func getTextLength(_ textCount: Int) {
        textCountLabel.text = "\(textCount)/30"
        updateCountLabel()
    }
}

extension SignUpNickNameVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func onMore() {
        
    }
    
    
}
