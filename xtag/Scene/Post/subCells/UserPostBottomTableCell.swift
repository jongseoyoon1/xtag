//
//  UserPostBottomTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/12.
//

import UIKit

class UserPostBottomTableCell: UITableViewCell {

    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    public static let IDENTIFIER = "UserPostBottomTableCell"
    public static let HEIGHT = 219
    
    public var postId = ""
    
    public var smallCategoryList: [SmallCategoryModel] = []
    
    public var onComment:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(UINib(nibName: "UserPostTagCell", bundle: nil), forCellWithReuseIdentifier: UserPostTagCell.IDENTIFIER)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        HTTPSession.shared.likePost(postId: postId) { result, error in
            if error == nil {
                
            }
        }
        
        
        
        likeButton.isSelected = !likeButton.isSelected
        
        if likeButton.isSelected {
            var likeCount = Int(likeCountLabel.text!)!
            likeCount += 1
            
            likeCountLabel.text = "\(likeCount)"
            likeImageView.image = UIImage(named: "thumbs_up_fill")
            
            
        } else {
            var likeCount = Int(likeCountLabel.text!)!
            likeCount -= 1
            
            likeCountLabel.text = "\(likeCount)"
            likeImageView.image = UIImage(named: "thumbs_up")
        }
        
    }
    @IBAction func commentBtnPressed(_ sender: Any) {
        guard let onComment = onComment else {
            return
        }

        onComment()
    }
}

extension UserPostBottomTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
        
        let category = smallCategoryList[indexPath.row]
        
        cell.tagButton.setTitle(category.smallCategoryName ?? "", for: [])
        cell.tagButton.isUserInteractionEnabled = false
        cell.setButtonState(isSelected: true)
        cell.layer.cornerRadius = 16
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = smallCategoryList[indexPath.row]
        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
        let fontAttributes = [NSAttributedString.Key.font : font]
        let text = category.smallCategoryName ?? ""
        let size = (text as NSString).size(withAttributes: fontAttributes)
        
        return CGSize(width: size.width + 32, height: 32)
    }
}
