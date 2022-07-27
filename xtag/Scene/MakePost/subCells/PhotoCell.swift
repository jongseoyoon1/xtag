//
//  PhotoCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/26.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    public static let IDENTIFIER = "PhotoCell"

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    
    public var onSelected:(()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectBtnPressed(_ sender: Any) {
        guard let onSelected = onSelected else {
            return
        }

        onSelected()
    }
}
