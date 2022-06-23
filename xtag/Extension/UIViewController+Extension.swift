//
//  UIViewController+Extension.swift
//  balance
//
//  Created by 윤종서 on 2021/04/02.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlertDialog(title: String = "", titleMessage: String, confirmMessage: String? = nil, confirmAction: ((UIAlertAction) -> Void)? = nil, cancelMessage: String? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil){
        let dialog = UIAlertController(title: title, message: titleMessage, preferredStyle: UIAlertController.Style.alert)
        
        var confirmMsg = ""
        if(confirmMessage == nil) {
            confirmMsg = "확인"
        } else {
            confirmMsg = confirmMessage!
        }
        let confirmAction = UIAlertAction(title: confirmMsg, style: UIAlertAction.Style.default) {
            (action : UIAlertAction) -> Void in
            confirmAction?(action)
        }
        
        if(cancelMessage != nil) {
            var cancelMsg = ""
            if(cancelMessage == nil) {
                cancelMsg = "취소"
            } else {
                cancelMsg = cancelMessage!
            }
            let cancelAction = UIAlertAction(title: cancelMsg, style: UIAlertAction.Style.default) {
                (action : UIAlertAction) -> Void in
                cancelAction?(action)
            }
            dialog.addAction(cancelAction)
        }
        dialog.addAction(confirmAction)
        self.present(dialog, animated: true)
    }
    
}

