//
//  ProductLinkTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/11.
//

import UIKit

class ProductLinkTableCell: UITableViewCell {
    
    public static let IDENTIFIER = "ProductLinkTableCell"

    public var updateLayout: ((Bool)->Void)?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var link = ""
    var imageUrl = ""
    var productName = ""
    
    var onLink: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
    }
    
    public func setupCell(link: String, imageUrl: String, productName: String) {
        self.link = link
        self.imageUrl = imageUrl
        self.productName = productName
        
        productImageView.kf.setImage(with: URL(string: imageUrl))
        productNameLabel.text = productName
        textView.text = link
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func openLinkBtnPressed(_ sender: Any) {
        guard let onLink = onLink else {
            return
        }

        onLink()
        
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            
            if self.updateLayout != nil {
                self.updateLayout!(false)
            }
            
            
        }
    }
    
    @IBAction func linkBtnPressed(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            
            if self.updateLayout != nil {
                self.updateLayout!(true)
            }
            
            
        }
    }
}
