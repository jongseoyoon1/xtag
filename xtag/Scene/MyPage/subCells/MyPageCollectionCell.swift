//
//  MyPageCollectionCell.swift
//  xtag
//
//  Created by Yoon on 2022/06/15.
//

import UIKit

class MyPageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    public static let IDENTIFIER = "MyPageCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
