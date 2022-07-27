//
//  UserPostTagCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/12.
//

import UIKit

class UserPostTagCell: UICollectionViewCell {
    
    public static let IDENTIFIER = "UserPostTagCell"

    @IBOutlet weak var tagButton: UIButton!
    public var onTagButton: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    @IBAction func tagBtnPressed(_ sender: Any) {
        tagButton.isSelected = !tagButton.isSelected
        handleTagButtonState()
        
    }
    
    public func setButtonState(isSelected: Bool) {
        tagButton.isSelected = isSelected
        handleTagButtonState()
    }
    
    private func handleTagButtonState() {
        if tagButton.isSelected {
            tagButton.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
            tagButton.backgroundColor = XTColor.FLUORESCENT_YELLOW.getColorWithString()
        } else {
            tagButton.setTitleColor(XTColor.GREY_500.getColorWithString(), for: [])
            tagButton.backgroundColor = XTColor.GREY_100.getColorWithString()
        }
    }
}
