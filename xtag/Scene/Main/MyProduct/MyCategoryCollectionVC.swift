//
//  MyCategoryCollectionVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/24.
//

import UIKit
import Combine

class MyCategoryCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public var smallCategoryList: [SmallCategoryModel] = []
    
    private var selectedSmallCategory: SmallCategoryModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var selectedLargeCatgoryIndex = 0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    public var CELL_WIDTH: CGFloat = 0
    
    private let applyButton : UIButton = {
        let btn = UIButton()
       
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("적용", for: [])
        btn.backgroundColor = .white
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor  = XTColor.GREY_900.getColorWithString()
        collectionView.backgroundColor = XTColor.GREY_900.getColorWithString()
        
        self.collectionView!.register(SmallCategoryCell.self, forCellWithReuseIdentifier: SmallCategoryCell.IDENTIFIER)
        
        let publisher = CategoryManager.shared.$mainSelectedSmallCategory
        publisher.sink { smallCategoryModel in
            self.selectedSmallCategory = smallCategoryModel
        }
        .store(in: &subscriptions)
        
        getUserCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CategoryManager.shared.mainSelectedSmallCategory = nil
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.smallCategoryList = smallCategoryModel ?? []
                
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return smallCategoryList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCategoryCell.IDENTIFIER, for: indexPath) as! SmallCategoryCell
        
        let smallCategory = smallCategoryList[indexPath.row]
        cell.name = smallCategory.smallCategoryName ?? ""
        
        if let selectedSmallCategory = selectedSmallCategory,
           selectedSmallCategory.smallCategoryId == smallCategory.smallCategoryId {
            cell.isSelectedCategory = true
        } else {
            cell.isSelectedCategory = false
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CELL_WIDTH, height: CELL_WIDTH / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let selectedSmallCategory = selectedSmallCategory {
            let smallCategory = smallCategoryList[indexPath.row]
            if smallCategory.smallCategoryId! == selectedSmallCategory.smallCategoryId! {
                self.selectedSmallCategory = nil
                CategoryManager.shared.mainSelectedSmallCategory = nil
            } else {
                self.selectedSmallCategory = smallCategory
                CategoryManager.shared.mainSelectedSmallCategory = smallCategory
            }
            
            
        } else {
            let smallCategory = smallCategoryList[indexPath.row]
            
            self.selectedSmallCategory = smallCategory
            CategoryManager.shared.mainSelectedSmallCategory = smallCategory
        }
    }
    
}
