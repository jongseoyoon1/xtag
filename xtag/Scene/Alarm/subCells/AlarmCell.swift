//
//  AlarmCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/22.
//

import UIKit

class AlarmCell: UITableViewCell {

    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
