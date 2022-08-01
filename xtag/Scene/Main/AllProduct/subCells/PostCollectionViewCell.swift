//
//  PostCollectionViewCell.swift
//  xtag
//
//  Created by Yoon on 2022/06/14.
//

import UIKit
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setupCell(userName: String, profileImageUri: String, postImageUri: String) {
        
        userNameLabel.text = userName
        postImageView.kf.setImage(with: URL(string: postImageUri))
        profileImageView.kf.setImage(with: URL(string: profileImageUri), placeholder: UIImage(named: "profile_image"))
        
    }
}
