//
//  MyPageEditCategoryVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/22.
//

import UIKit



class MyPageEditCategoryVC: UIViewController {

    @IBOutlet weak var allCategoryCollectionView: UICollectionView!
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    public var largeCategoryList: [LargeCategoryModel] = []
    public var smallCategoryList: [SmallCategoryModel] = []
    public var originalSmallCategoryList: [SmallCategoryModel] = []
    
    private var selectedSmallCategoryList: [SmallCategoryModel] = [] {
        didSet {
            
            if selectedSmallCategoryList.sorted(by: { $0.smallCategoryId! > $1.smallCategoryId! }) == originalSmallCategoryList.sorted(by: { $0.smallCategoryId! > $1.smallCategoryId! }) {
                saveButton.backgroundColor = XTColor.GREY_800.getColorWithString()
                saveButton.setTitleColor(XTColor.GREY_400.getColorWithString(), for: [])
            } else {
                saveButton.backgroundColor = .white
                saveButton.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
            }
            
            allCategoryCollectionView.reloadData()
            selectCategoryCollectionView.reloadData()
        }
    }
    
    
    var selectedSmallCategoryCount = 0
    var isLargeCategorySelected: Bool = false
    
    public var CELL_WIDTH : CGFloat = 0.0
    
    var selectedLargeCatgoryIndex = 0 {
        didSet {
            self.allCategoryCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CELL_WIDTH = (self.view.frame.size.width - 32 - 44) / 3 - 3
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
        
        selectCategoryCollectionView.register(UINib(nibName: "UserProfileSelectCategoryCell", bundle: nil), forCellWithReuseIdentifier: "UserProfileSelectCategoryCell")
        
        allCategoryCollectionView.delegate = self
        allCategoryCollectionView.dataSource = self
        
        self.allCategoryCollectionView.register(LargeCategoryCell.self, forCellWithReuseIdentifier: LargeCategoryCell.IDENTIFIER)
        self.allCategoryCollectionView.register(SmallCategoryCell.self, forCellWithReuseIdentifier: SmallCategoryCell.IDENTIFIER)
        
        //allCategoryCollectionView.autoresizesSubviews = false
        
        getLargeCategory()
    }
    
    private func getLargeCategory() {
        
        self.largeCategoryList = CategoryManager.shared.largeCategoryList.sorted(by: { $0.largeCategoryId! > $1.largeCategoryId! })
        var count = 0
        for largeCategory in largeCategoryList {
            largeCategory.index = count
            count += 1
        }
        
        self.allCategoryCollectionView.reloadData()
        getUserCategory()
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo?.userId ?? "") { smallCategoryModel, error in
            if error == nil {
                self.originalSmallCategoryList = smallCategoryModel ?? []
                self.selectedSmallCategoryList = self.originalSmallCategoryList
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        var removeSmallCategoryIdList : [String] = []
        var addSmallCategoryIdList : [String] = []
        
        for smallCategory in self.originalSmallCategoryList {
            if self.selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                
            } else {
                removeSmallCategoryIdList.append(smallCategory.smallCategoryId!)
            }
        }
        
        for smallCategory in self.selectedSmallCategoryList {
            if self.originalSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                
            } else {
                addSmallCategoryIdList.append(smallCategory.smallCategoryId!)
            }
        }
        
        
        HTTPSession.shared.updateUserCategory(removeSmallCategoryIdList: removeSmallCategoryIdList, addSmallCategoryIdList: addSmallCategoryIdList) { result, error in
            if error == nil {
                self.dismiss(animated: true)
            }
        }
    }
}

extension MyPageEditCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if collectionView == allCategoryCollectionView {
            return largeCategoryList.count + selectedSmallCategoryCount
        } else {
            return self.selectedSmallCategoryList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == allCategoryCollectionView {
            if isLargeCategorySelected  {
                if indexPath.row > (selectedLargeCatgoryIndex) &&
                    indexPath.row <= (selectedLargeCatgoryIndex + selectedSmallCategoryCount) {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCategoryCell.IDENTIFIER, for: indexPath) as! SmallCategoryCell
                    
                    let smallCategory = smallCategoryList[indexPath.row - selectedLargeCatgoryIndex - 1]
                    cell.name = smallCategory.smallCategoryName ?? ""
                    
                    if selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                        cell.isSelectedCategory = true
                    } else {
                        cell.isSelectedCategory = false
                    }
                    
                    return cell
                } else {
                    if indexPath.row <= selectedLargeCatgoryIndex {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCategoryCell.IDENTIFIER, for: indexPath) as! LargeCategoryCell
                        
                        // Configure the cell
                        let largeCategory = largeCategoryList[indexPath.row]
                        
                        cell.nameLabel.text = largeCategory.largeCategoryName
                        cell.backgroundImageVieww.kf.setImage(with: URL(string: largeCategory.largeCategoryCdnImageUri ?? ""))
                        
                        cell.backgroundImageVieww.layer.cornerRadius = CELL_WIDTH / 2
                        cell.backgroundImageVieww.clipsToBounds = true
                        
                        cell.grayView.cornerradius = CELL_WIDTH / 2
                        
                        return cell
                    } else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCategoryCell.IDENTIFIER, for: indexPath) as! LargeCategoryCell
                        
                        // Configure the cell
                        let largeCategory = largeCategoryList[indexPath.row - selectedSmallCategoryCount]
                        
                        cell.nameLabel.text = largeCategory.largeCategoryName
                        cell.backgroundImageVieww.kf.setImage(with: URL(string: largeCategory.largeCategoryCdnImageUri ?? ""))
                        
                        cell.backgroundImageVieww.layer.cornerRadius = CELL_WIDTH / 2
                        cell.backgroundImageVieww.clipsToBounds = true
                        
                        cell.grayView.cornerradius = CELL_WIDTH / 2
                        
                        return cell
                    }
                }
                
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCategoryCell.IDENTIFIER, for: indexPath) as! LargeCategoryCell
                
                // Configure the cell
                let largeCategory = largeCategoryList[indexPath.row]
                
                cell.nameLabel.text = largeCategory.largeCategoryName
                cell.backgroundImageVieww.kf.setImage(with: URL(string: largeCategory.largeCategoryCdnImageUri ?? ""))
                
                cell.backgroundImageVieww.layer.cornerRadius = CELL_WIDTH / 2
                cell.backgroundImageVieww.clipsToBounds = true
                
                cell.grayView.cornerradius = CELL_WIDTH / 2
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileSelectCategoryCell", for: indexPath) as! UserProfileSelectCategoryCell
            
            
            let category = self.selectedSmallCategoryList[indexPath.row]
            cell.categoryLabel.text = category.smallCategoryName ?? ""
            
            cell.isFilterSelected = true
   
            return cell
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.allCategoryCollectionView {
            return CGSize(width: CELL_WIDTH, height: CELL_WIDTH)
        }
        else {
            let category = self.selectedSmallCategoryList[indexPath.row]
            
            
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 48, height: 44)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.allCategoryCollectionView {
            return 18
        } else {
            return 16
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.allCategoryCollectionView {
            return 22
        } else {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == allCategoryCollectionView {
            if selectedSmallCategoryCount == 0 {
                let largeCategory = largeCategoryList[indexPath.row]
                selectLargeCategory(largeCategory: largeCategory)
            } else {
                if indexPath.row <= selectedLargeCatgoryIndex {
                    let largeCategory = largeCategoryList[indexPath.row]
                    selectLargeCategory(largeCategory: largeCategory)
                } else {
                    // Small Category 를 선택하였을 경우
                    
                    if indexPath.row > (selectedLargeCatgoryIndex) &&
                        indexPath.row <= (selectedLargeCatgoryIndex + selectedSmallCategoryCount) {
                        let smallCategory = smallCategoryList[indexPath.row - selectedLargeCatgoryIndex - 1]
                        
                        if self.selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                            
                            self.selectedSmallCategoryList.remove(at: self.selectedSmallCategoryList.firstIndex(where:  {$0.smallCategoryId! == smallCategory.smallCategoryId! })!)
                        } else {
                            self.selectedSmallCategoryList.append(smallCategory)
                        }
                        
                    } else {
                        let largeCategory = largeCategoryList[indexPath.row - selectedSmallCategoryCount]
                        selectLargeCategory(largeCategory: largeCategory)
                    }
                    
                }
            }
        } else {
            selectedSmallCategoryList.remove(at: indexPath.row)
        }
        
    }
    
    private func selectLargeCategory(largeCategory: LargeCategoryModel) {
        selectedLargeCatgoryIndex = largeCategory.index
        selectedSmallCategoryCount = largeCategory.smallCategoryList.count
        smallCategoryList = largeCategory.smallCategoryList
        isLargeCategorySelected = true
    }
}
