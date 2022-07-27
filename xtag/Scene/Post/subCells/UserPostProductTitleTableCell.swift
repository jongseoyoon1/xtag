//
//  UserPostProductTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/13.
//

import UIKit

class UserPostProductTitleTableCell: UITableViewCell {

    public static let IDENTIFIER = "UserPostProductTitleTableCell"
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public var onLink: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func linkBtnPressed(_ sender: Any) {
        guard let onLink = onLink else {
            return
        }

        onLink()
    }
    
}
