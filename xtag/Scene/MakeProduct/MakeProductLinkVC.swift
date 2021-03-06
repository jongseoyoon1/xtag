//
//  MakeProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit
import PKHUD
import Toast

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
        
        if urlString != "" {
            self.confirmButton.isSelected = true
        } else {
            self.confirmButton.isSelected = false
        }
        
        
    }
    
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        
        validateUrl(urlString: textView.text)
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.showCommonPopup(title: "변경 내용 삭제", content: "이전으로 돌아갈 시 변경 내용이 삭제됩니다.", confirmButtonTitle: "확인", popupType: .COMMON) {
            self.dismiss(animated: true)
        }
        
        
    }
    
    @IBAction func comfirmBtnPressed(_ sender: Any) {
        
        if confirmButton.isSelected {
            
            HUD.show(.progress)
            
            HTTPSession.shared.productInfo(url: textView.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { result, error in
                HUD.hide()
                
                
                if error == nil {
                    print(result)
                    
                    MakeProductManager.shared.productInfo = result
                    
                    if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeProductDetailVC") as?  MakeProductDetailVC {
                        
                        viewcontroller.modalPresentationStyle = .fullScreen
                        self.present(viewcontroller, animated: true)
                    }
                } else {
                    self.view.makeToast("다른 상품 링크를 넣어주세요", duration: 0.5, position: .center)
                }
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
