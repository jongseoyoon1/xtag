//
//  SettingContentCell.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit

class SettingContentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
