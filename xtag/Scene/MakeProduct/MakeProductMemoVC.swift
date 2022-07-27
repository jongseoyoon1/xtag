//
//  MakeProductMemoVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/21.
//

import UIKit

class MakeProductMemoVC: UIViewController {
    
    var textViewPlaceHolder = "작성하기"
    @IBOutlet weak var textView: UITextView!
    private var memoString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
    }
    

    @IBAction func completeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            MakeProductManager.shared.productInfo?.memo = self.memoString
        }
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension MakeProductMemoVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.memoString = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = XTColor.GREY_500.getColorWithString()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
       
        return true
    }
}
