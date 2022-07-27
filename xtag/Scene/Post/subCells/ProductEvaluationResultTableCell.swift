//
//  ProductEvaluationTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/13.
//

import UIKit

class ProductEvaluationResultTableCell: UITableViewCell {

    public static let IDENTIFIER = "ProductEvaluationResultTableCell"
    
    @IBOutlet weak var evaluationImageVIew: UIImageView!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    public var smallCategoryList: [SmallCategoryModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
}

extension ProductEvaluationResultTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
        
        let category = smallCategoryList[indexPath.row]
        
        cell.tagButton.setTitle(category.smallCategoryName ?? "", for: [])
        cell.tagButton.isUserInteractionEnabled = false
        cell.setButtonState(isSelected: true)
        cell.layer.cornerRadius = 22
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = smallCategoryList[indexPath.row]
        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
        let fontAttributes = [NSAttributedString.Key.font : font]
        let text = category.smallCategoryName ?? ""
        let size = (text as NSString).size(withAttributes: fontAttributes)
        
        return CGSize(width: size.width + 32, height: 44)
    }
}
