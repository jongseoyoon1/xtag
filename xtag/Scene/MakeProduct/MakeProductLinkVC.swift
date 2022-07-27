//
//  MakeProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit
import PKHUD

class MakeProductLinkVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backgroundTextView: UIView!
    
    let textViewPlaceHolder = "상품 링크 복사 후 붙여넣기"
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MakeProductManager.shared.productInfo?.memo = "작성하기"
        setupTextView()
    }
    
    private func setupTextView() {
        let dashedLayer = backgroundTextView.addLineDashedStroke(pattern: [5,5], radius: 21.0, color: XTColor.GREY_900.getColorWithString().cgColor)
        backgroundTextView.layer.addSublayer(dashedLayer)
        
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
    }
    
    private func updateCountLabel(characterCount: Int) {
        
    }
    
    private func validateUrl(urlString: String) {
        HUD.show(.progress)
        
        HTTPSession.shared.productInfo(url: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { result, error in
            HUD.hide()
            self.confirmButton.isSelected = false
            
            if error == nil {
                print(result)
                self.confirmButton.isSelected = true
                MakeProductManager.shared.productInfo = result
            }
        }
    }
    
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        
        validateUrl(urlString: textView.text)
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func comfirmBtnPressed(_ sender: Any) {
        if confirmButton.isSelected {
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeProductDetailVC") as?  MakeProductDetailVC {
                
                viewcontroller.modalPresentationStyle = .fullScreen
                self.present(viewcontroller, animated: true)
            }
        }
    }
}

extension MakeProductLinkVC: UITextViewDelegate {
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = XTColor.GREY_900.getColorWithString()
            
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            updateCountLabel(characterCount: 0)
        }
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
            {
                view.endEditing(true)
                return false
            }
        confirmButton.isSelected = false
        if let paste = UIPasteboard.general.string, text == paste {
            print("paste")
            if paste.isValidURL {
                validateUrl(urlString: textView.text)
            }
        } else {
            print("normal typing")
        }
        
        
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 700 else { return false }
        updateCountLabel(characterCount: characterCount)
        
        if textView.text.isValidURL {
            validateUrl(urlString: textView.text)
        }
        
        return true
    }
}
