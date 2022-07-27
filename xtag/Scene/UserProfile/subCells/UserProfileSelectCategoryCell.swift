//
//  ProductMakeFilterCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/21.
//

import UIKit

class UserProfileSelectCategoryCell: UICollectionViewCell {

    public static let IDENTIFIER = "UserProfileSelectCategoryCell"
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var isFilterSelected : Bool = false {
        didSet {
            handleSelect()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private func handleSelect() {
        if isFilterSelected {
            self.backgroundColor = XTColor.FLUORESCENT_YELLOW.getColorWithString()
            categoryLabel.textColor = XTColor.GREY_900.getColorWithString()
            
        } else {
            self.backgroundColor = XTColor.GREY_100.getColorWithString()
            categoryLabel.textColor = XTColor.GREY_500.getColorWithString()
            
        }
    }
}
