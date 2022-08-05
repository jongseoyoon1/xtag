//
//  MakePostSelectCategoryVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/26.
//

import UIKit

class UpdatePostCategoryVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    public var smallCategoryList: [SmallCategoryModel] = []
    public var selectedSmallCategoryList: [SmallCategoryModel] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
                
            }
        }
    }
    
    public var updateUserPostVC: UpdateUserPostVC!
    
    public var CELL_WIDTH: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CELL_WIDTH = (self.view.frame.size.width - 32 - 44) / 3
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView!.register(PostSmallCategoryCell.self, forCellWithReuseIdentifier: PostSmallCategoryCell.IDENTIFIER)
        
        getUserCategory()
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.smallCategoryList = smallCategoryModel ?? []
                
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectBtnPressed(_ sender: Any) {
        
        MakePostManager.shared.selectedCategory = selectedSmallCategoryList
        
        if updateUserPostVC != nil {
            updateUserPostVC.selectedCategory = self.selectedSmallCategoryList
            
        }
        
        self.dismiss(animated: true)
    }
}

extension UpdatePostCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return smallCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostSmallCategoryCell.IDENTIFIER, for: indexPath) as! PostSmallCategoryCell
        let smallCategory = smallCategoryList[indexPath.row]
        cell.cornerradius = CELL_WIDTH / 4
        
        
        if self.selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
            cell.isSelectedCategory = true
        } else {
            
            cell.isSelectedCategory = false
        }
        
        
        
        cell.name = smallCategory.smallCategoryName ?? ""
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let smallCategory = smallCategoryList[indexPath.row]
        
        
        if self.selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
            self.selectedSmallCategoryList.remove(at: self.selectedSmallCategoryList.firstIndex(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! })!)
        } else {
            self.selectedSmallCategoryList.append(smallCategory)
        }
    }
}
