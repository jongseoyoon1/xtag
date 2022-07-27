//
//  CommentVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/19.
//

import UIKit

class CommentVC: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var textViewPlaceHolder = "댓글 입력"
    
    var postDetailModel : PostDetailModel!
    var commentList : [CommentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: CommentCell.IDENTIFIER)
        
        setupUI()
        getComments()
    }
    
    private func getComments() {
        HTTPSession.shared.getPostComment(postId: postDetailModel.postId ?? "") { result, error in
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
        HTTPSession.shared.writeComment(postId: self.postDetailModel.postId ?? "", comment: self.textView.text!) { result, error in
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

extension CommentVC: UITextViewDelegate {
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

extension CommentVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.IDENTIFIER, for: indexPath) as! CommentCell
        
        let comment = self.commentList[indexPath.row]
        
        cell.profileImageView.kf.setImage(with: URL(string: comment.postCommentUserCdnImageUri ?? ""), placeholder: UIImage(named: "profile_image"))
        cell.nameLabel.text = comment.postCommentUserName ?? ""
        cell.commentLabel.text = comment.comment ?? ""
        cell.timeLabel.text = comment.postCommentRegisterDate ?? ""
        if let hasCommentReply = comment.hasComentReply {
            if hasCommentReply == "true" {
                cell.replyLabel.text = "답글 모두 보기"
            } else {
                cell.replyLabel.text = "답글 달기"
            }
        } else {
            cell.replyLabel.text = "답글 달기"
        }
        
        cell.onReply = {
            if let viewcontroller = UIStoryboard(name: "Comment", bundle: nil).instantiateViewController(withIdentifier: "ReplyVC") as? ReplyVC {
                viewcontroller.modalPresentationStyle = .fullScreen
                viewcontroller.commentModel = comment
                
                self.present(viewcontroller, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let text = self.commentList[indexPath.row].comment ?? ""
        let height = text.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont(name: XTFont.PRETENDARD_REGULAR, size: 13)!)
        
        return 88 + height
    }
    
}
