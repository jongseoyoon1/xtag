//
//  UserPostUpdateTextViewCell.swift
//  xtag
//
//  Created by Yoon on 2022/08/05.
//

import UIKit

class UserPostUpdateTextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    public var onChange:((String)->Void)?
    
    static let IDENTIFIER = "UserPostUpdateTextViewCell"
    public var placeholderText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupTextView() {
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.delegate = self
    }
    
}

extension UserPostUpdateTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let onChange = onChange else { return }
        onChange(textView.text!)
    }
    
}

extension UserPostUpdateTextViewCell {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = XTColor.GREY_900.getColorWithString()
            //MakePostManager.shared.postList[self.pageIndex - 1].content = ""
        } else {
            //MakePostManager.shared.postList[self.pageIndex - 1].content = textView.text
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = XTColor.GREY_400.getColorWithString()
            
            //MakePostManager.shared.postList[self.pageIndex - 1].content = ""
        } else {
            //MakePostManager.shared.postList[self.pageIndex - 1].content = textView.text
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        //MakePostManager.shared.postList[self.pageIndex - 1].content = newString
        let characterCount = newString.count
       
        return true
    }
    
}
