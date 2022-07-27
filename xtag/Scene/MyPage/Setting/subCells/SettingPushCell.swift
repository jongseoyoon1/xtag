//
//  SettingPushCell.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit

class SettingPushCell: UITableViewCell {

    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var onSwitch: ((Bool)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        guard let onSwitch = onSwitch else {
            return
        }

        onSwitch(settingSwitch.isOn)
    }
}
