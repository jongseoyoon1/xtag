//
//  PostImageCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/27.
//

import UIKit

class PostImageCell: UICollectionViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var productCountView: UIView!
    @IBOutlet weak var productCountLabel: UILabel!
    
    public var onDelete: (()->Void)?
    public var onTag: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteBtnPressed(_ sender: Any) {
        guard let onDelete = onDelete else {
            return
        }

        onDelete()
    }
    @IBAction func gotoTagBtnPressed(_ sender: Any) {
        guard let onTag = onTag else {
            return
        }

        onTag()
    }
}
