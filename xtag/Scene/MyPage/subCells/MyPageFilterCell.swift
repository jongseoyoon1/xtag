//
//  MyPageFilterCell.swift
//  xtag
//
//  Created by Yoon on 2022/06/24.
//

import UIKit

class MyPageFilterCell: UICollectionViewCell {
    
    enum FilterType: String {
        case ALL = "ALL"
        case FILTER = "FILTER"
    }

    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var type : FilterType = .ALL {
        didSet {
            if type == .ALL {
                followingCountLabel.isHidden = true
                iconImageView.isHidden = true
            } else {
                followingCountLabel.isHidden = false
                iconImageView.isHidden = false
            }
        }
    }
    var isFilterSelected : Bool = false {
        didSet {
            handleSelect()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    private func handleSelect() {
        if isFilterSelected {
            self.backgroundColor = XTColor.FLUORESCENT_YELLOW.getColorWithString()
            categoryLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            if type == .FILTER {
                followingCountLabel.isHidden = false
                iconImageView.isHidden = false
            }
        } else {
            self.backgroundColor = XTColor.GREY_100.getColorWithString()
            categoryLabel.textColor = XTColor.GREY_500.getColorWithString()
            
            if type == .FILTER {
                followingCountLabel.isHidden = true
                iconImageView.isHidden = true
            }
        }
    }
}
