//
//  SettingBlockUserCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/31.
//

import UIKit

class SettingBlockUserCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    public var onBlock:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func blockBtnPressed(_ sender: Any) {
        guard let onBlock = onBlock else {
            return
        }
        onBlock()
    }
}
