//
//  CommentVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/19.
//

import UIKit

class ReplyVC: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var textViewPlaceHolder = "댓글 입력"
    
    var commentModel : CommentModel!
    var commentList : [ReplytModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: CommentCell.IDENTIFIER)
        
        setupUI()
        getComments()
    }
    
    private func getComments() {
        HTTPSession.shared.getPostReply(postCommentId: commentModel.postCommentId ?? "") { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }

                self.commentList = result
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        myProfileImageView.kf.setImage(with: URL(string: UserManager.shared.userInfo?.cdnImageUri ?? ""), placeholder: UIImage(named: "profile_image"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func replyBtnPressed(_ sender: Any) {
        HTTPSession.shared.writeReply(postCommentId: self.commentModel.postCommentId ?? "", comment: self.textView.text!) { result, error in
            if error == nil {
                self.textView.text = ""
                self.getComments()
            }
        }
    }
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
      
      private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
      
      @objc func keyboardWillShow(_ notificatoin: Notification) {
        let duration = notificatoin.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notificatoin.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let keyboardSize = (notificatoin.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let height = keyboardSize.height - view.safeAreaInsets.bottom
        
          bottomConstraint.constant = height
          view.layoutIfNeeded()
        /*
            애니메이션 처리
        */
      }
      
      @objc func keyboardWillHide(_ notificatoin: Notification) {
        
        let duration = notificatoin.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notificatoin.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
          bottomConstraint.constant = 0
          view.layoutIfNeeded()
          
        /*
            애니메이션 처리
        */
      }
}

extension ReplyVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = XTColor.GREY_900.getColorWithString()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = XTColor.GREY_400.getColorWithString()
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

extension ReplyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.IDENTIFIER, for: indexPath) as! CommentCell
        
        if indexPath.row == 0 {
            let comment = self.commentModel!
            
            cell.profileImageView.kf.setImage(with: URL(string: comment.postCommentUserCdnImageUri ?? ""), placeholder: UIImage(named: "profile_image"))
            cell.nameLabel.text = comment.postCommentUserName ?? ""
            cell.commentLabel.text = comment.comment ?? ""
            cell.timeLabel.text = comment.postCommentRegisterDate ?? ""
            
            cell.backgroundColor = XTColor.GREY_100.getColorWithString()
            cell.replyLabel.isHidden = true
            
        } else {
            let comment = self.commentList[indexPath.row - 1]
            
            cell.profileImageView.kf.setImage(with: URL(string: comment.postCommentReplyUserCdnImageUri ?? (comment.postCommentReplyUserS3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
            cell.nameLabel.text = comment.postCommentReplyUserName ?? ""
            cell.commentLabel.text = comment.comment ?? ""
            cell.timeLabel.text = comment.postCommentReplyRegisterDate ?? ""
            cell.replyLabel.isHidden = true
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let text = self.commentModel!.comment ?? ""
            let height = text.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont(name: XTFont.PRETENDARD_REGULAR, size: 13)!)
            
            return 88 + height
        } else {
            let text = self.commentList[indexPath.row - 1].comment ?? ""
            let height = text.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont(name: XTFont.PRETENDARD_REGULAR, size: 13)!)
            
            return 88 + height
        }
        
        
        return 0
    }
    
}
