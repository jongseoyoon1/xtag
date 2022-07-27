//
//  UserPostProductCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/12.
//

import UIKit

class MakePostProductCell: UICollectionViewCell {

    public static let IDENTIFIER = "MakePostProductCell"
    public var onRemove: (()->Void)?
    @IBOutlet weak var isTaggedView: UIView!
    
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func removeBtnPressed(_ sender: Any) {
        guard let onRemove = onRemove else {
            return
        }

        onRemove()
    }
    
}
