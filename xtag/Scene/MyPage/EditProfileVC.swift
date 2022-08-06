//
//  EditProfileVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/20.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var userInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUI()
    }
    
    private func setupUI() {
        userInfo = UserManager.shared.userInfo
        
        profileImageView.kf.setImage(with: URL(string: userInfo.cdnImageUri ?? (userInfo.s3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
        nameLabel.text = userInfo.name
        descriptionLabel.text = userInfo.introduction
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
        var actions : [XTBottomSheetAction] = []
        let defaultImageAction = XTBottomSheetAction(title: "기본 이미지로 변경", type: .COMMON) {
            
        }
        
        let albumAction = XTBottomSheetAction(title: "앨범에서 사진 선택", type: .COMMON) {
            
        }
        actions.append(defaultImageAction)
        actions.append(albumAction)
        
        showCommonBottomSheet(actions: actions) {
            
        }
    }
    
    @IBAction func gotoChangeNameBtnPressed(_ sender: Any) {
        
    }
    @IBAction func gotoChangeIntroBtnPressed(_ sender: Any) {
    }
}
