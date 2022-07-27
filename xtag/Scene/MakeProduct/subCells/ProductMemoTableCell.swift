//
//  ProductMemoTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/11.
//

import UIKit

class ProductMemoTableCell: UITableViewCell {
    
    static let IDENTIFIER = "ProductMemoTableCell"

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func writeBtnPressed(_ sender: Any) {
        
    }
    
}
