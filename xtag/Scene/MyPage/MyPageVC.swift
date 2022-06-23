//
//  MyPageVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/12.
//

import UIKit
import Kingfisher

class MyPageVC: UIViewController {
    
    /* ScrollView */
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var descroptionLabel: UILabel!
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var follwerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var collectionMoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()

    }
    
    private func setupUI() {
        guard let userInfo = UserManager.shared.userInfo else { return }
        print(userInfo)
        
        
        if userInfo.s3ImageUri != nil {
            if userInfo.s3ImageUri! == "" {
                profileImageVIew.kf.setImage(with: URL(string: userInfo.s3ImageUri!))
            }
            
        }
        
        nameLabel.text = userInfo.name
        follwerLabel.text = userInfo.followers
        followingLabel.text = userInfo.followings
        descroptionLabel.text = userInfo.introduction
        
        view.layoutIfNeeded()
        
        print("********************************* stackView Frame")
        print("frame = \(stackView.frame)")
        contentViewHeight.constant = self.view.frame.height + stackView.frame.origin.y - 40 - 92
        print("********************************* stackView Frame")
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func collectionMoreBtnPressed(_ sender: Any) {
        
    }
    
}
