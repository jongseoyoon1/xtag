//
//  CommentCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/19.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    public static let IDENTIFIER = "CommentCell"
    
    public var onReply:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func replyBtnPressed(_ sender: Any) {
        guard let onReply = onReply else {
            return
        }

        onReply()
    }
    
}
