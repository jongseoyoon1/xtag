//
//  ProductCategoryCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/21.
//

import UIKit

class ProductCategoryCell: UITableViewCell {

    
    public static let IDENTIFIER = "ProductCategoryCell"
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var smallCategoryList : [SmallCategoryModel] = []
    var selectedSmallCategoryList : [SmallCategoryModel] = [] {
        didSet {
            guard let updateSelectedSmallCategoryList = updateSelectedSmallCategoryList else { return }
            updateSelectedSmallCategoryList(self.selectedSmallCategoryList)
        }
    }
    
    public var selectedCategoryIndex : [Int] = [] {
        didSet {
            self.categoryCollectionView.reloadData()
        }
    }
    
    var updateSelectedSmallCategoryList : (([SmallCategoryModel])->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "ProductMakeFilterCell", bundle: nil), forCellWithReuseIdentifier: "ProductMakeFilterCell")
        
        
        getUserCategory()
    }
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.smallCategoryList = smallCategoryModel ?? []
                
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ProductCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            print("smallCategoryList.count = \(smallCategoryList.count)")
            return smallCategoryList.count
        }
        
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoryCollectionView {
         
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductMakeFilterCell", for: indexPath) as! ProductMakeFilterCell
            cell.cornerradius = 21
            
            let category = self.smallCategoryList[indexPath.row]
            cell.categoryLabel.text = category.smallCategoryName ?? ""
            
            
            if selectedCategoryIndex.contains(indexPath.row) {
                cell.isFilterSelected = true
            } else {
                cell.isFilterSelected = false
            }
            
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = self.smallCategoryList[indexPath.row]
        
        
        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
        let fontAttributes = [NSAttributedString.Key.font : font]
        let text = category.smallCategoryName ?? ""
        let size = (text as NSString).size(withAttributes: fontAttributes)
        
        return CGSize(width: size.width + 32, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
 
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        if collectionView == self.categoryCollectionView {
    
            if selectedCategoryIndex.contains(indexPath.row) {
                selectedCategoryIndex.remove(at: selectedCategoryIndex.firstIndex(where: { $0 == indexPath.row })!)
               
            } else {
                selectedCategoryIndex.append(indexPath.row)
            }
            
            let smallCategory = smallCategoryList[indexPath.row]
            if selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                selectedSmallCategoryList.remove(at: selectedSmallCategoryList.firstIndex(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! })!)
            } else {
                self.selectedSmallCategoryList.append(smallCategory)
            }
        }
        
        
    }
    
    
}
