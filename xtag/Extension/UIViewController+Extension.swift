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
    
    func showCommonBottomSheet(actions: [XTBottomSheetAction], confirmFunc: (()->Void)?) {
        let bottomSheet = XTCommonBottomSheet.create()
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bottomSheet.actions = actions
        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.view.backgroundColor = .clear
        //bottomSheet.onCancel = confirmFunc
        
        self.present(bottomSheet, animated: true)
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1215686275, alpha: 0.3)
        self.view.addSubview(backgroundView)
        
        bottomSheet.onCancel = {
            backgroundView.removeFromSuperview()
        }
    }
    
    func showCommonPopup(title: String, content: String, confirmButtonTitle: String, popupType: PopupType, confirmFunc: (()->Void)?) {
        let commonPopup = XTCommonPopup.create()
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        
        commonPopup.popupType = popupType
        commonPopup.onConfirm = confirmFunc
        commonPopup.modalPresentationStyle = .overFullScreen
        commonPopup.view.backgroundColor = .clear
        
        
        commonPopup.titleLabel.text = title
        commonPopup.contentLabel.text = content
        commonPopup.confirmButton.setTitle(confirmButtonTitle, for: [])
        self.present(commonPopup, animated: true)
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1215686275, alpha: 0.3)
        self.view.addSubview(backgroundView)
        
        commonPopup.onCancel = {
            backgroundView.removeFromSuperview()
        }
        
        
    }
    
    func showCommonPopup(title: String, content: NSAttributedString, confirmButtonTitle: String, popupType: PopupType, confirmFunc: (()->Void)?) {
        let commonPopup = XTCommonPopup.create()
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        
        commonPopup.popupType = popupType
        commonPopup.onConfirm = confirmFunc
        commonPopup.modalPresentationStyle = .overFullScreen
        commonPopup.view.backgroundColor = .clear
        
        
        commonPopup.titleLabel.text = title
        commonPopup.contentLabel.attributedText = content
        commonPopup.confirmButton.setTitle(confirmButtonTitle, for: [])
        self.present(commonPopup, animated: true)
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1215686275, alpha: 0.3)
        self.view.addSubview(backgroundView)
        
        commonPopup.onCancel = {
            backgroundView.removeFromSuperview()
        }
        
        
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

