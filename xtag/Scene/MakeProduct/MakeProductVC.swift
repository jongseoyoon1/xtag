//
//  MakeProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit

class MakeProductVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backgroundTextView: UIView!
    
    let textViewPlaceHolder = "상품 링크 복사 후 붙여넣기"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        HTTPSession.shared.productInfo(url: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { result, error in
            if error == nil {
                print(result)
                
                MakePostManager.shared.productInfo = result
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
    
}

extension MakeProductVC: UITextViewDelegate {
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
