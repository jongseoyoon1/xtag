//
//  UserProfileCategoryVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/21.
//

import UIKit

class UserProfileCategoryVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    @IBOutlet weak var allCategoryCollectionView: UICollectionView!
    @IBOutlet weak var realeseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    public var userInfo : UserInfo!
    
    public var userCategoryList: [SmallCategoryModel] = []
    public var selectCategoryList: [SmallCategoryModel] = [] {
        didSet {
            allCategoryCollectionView.reloadData()
            selectCategoryCollectionView.reloadData()
            
            if selectCategoryList.count == 0 {
                handleReleaseButtonState(isActive: false)
            } else {
                handleReleaseButtonState(isActive: true)
            }
        }
    }
    public var originalSelectCategoryList: [SmallCategoryModel] = [] {
        didSet {
            self.userCategoryList = originalSelectCategoryList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
    }
    
    private func setupUI() {
        guard let userInfo = self.userInfo else { return }
        print(userInfo)
        
        
        if userInfo.s3ImageUri != nil {
            if userInfo.s3ImageUri! != "" {
                profileImageView.kf.setImage(with: URL(string: userInfo.s3ImageUri!), placeholder: UIImage(named: "profile_image"))
            }
            
        }
        
        if userInfo.cdnImageUri != nil {
            if userInfo.cdnImageUri! != "" {
                profileImageView.kf.setImage(with: URL(string: userInfo.cdnImageUri!), placeholder: UIImage(named: "profile_image"))
            }
            
        }
        nameLabel.text = userInfo.name
        followerLabel.text = userInfo.followers
        
    }
    
    private func setupCollectionView() {
        allCategoryCollectionView.delegate = self
        allCategoryCollectionView.dataSource = self
        
        allCategoryCollectionView.register(UINib(nibName: "ProductMakeFilterCell", bundle: nil), forCellWithReuseIdentifier: "ProductMakeFilterCell")
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self
        
        selectCategoryCollectionView.register(UINib(nibName: "UserProfileSelectCategoryCell", bundle: nil), forCellWithReuseIdentifier: "UserProfileSelectCategoryCell")
    }
    
    private func handleReleaseButtonState(isActive: Bool) {
        if isActive {
            realeseButton.setTitleColor(.white, for: [])
            
            saveButton.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
            saveButton.backgroundColor = .white
        } else {
            realeseButton.setTitleColor(XTColor.GREY_500.getColorWithString(), for: [])
            
            saveButton.setTitleColor(XTColor.GREY_400.getColorWithString(), for: [])
            saveButton.backgroundColor = XTColor.GREY_500.getColorWithString()
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        var removeSmallCategoryIdList : [String] = []
        var addSmallCategoryIdList : [String] = []
        
        for smallCategory in self.userCategoryList {
            if self.selectCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                
            } else {
                removeSmallCategoryIdList.append(smallCategory.smallCategoryId!)
            }
        }
        
        for smallCategory in self.selectCategoryList {
            if self.userCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
                
            } else {
                addSmallCategoryIdList.append(smallCategory.smallCategoryId!)
            }
        }
        
        
        HTTPSession.shared.userFollow(removeSmallCategoryIdList: removeSmallCategoryIdList, addSmallCategoryIdList: addSmallCategoryIdList, userId: self.userInfo.userId!) { result, error in
            if error == nil {
                self.dismiss(animated: true)
            }
        }
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func allCategoryDeletePressed(_ sender: Any) {
        userCategoryList = originalSelectCategoryList
        selectCategoryList = []
        
        allCategoryCollectionView.reloadData()
        selectCategoryCollectionView.reloadData()
    }
}

extension UserProfileCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.allCategoryCollectionView {
            print("smallCategoryList.count = \(userCategoryList.count)")
            return userCategoryList.count
        }
        
        if collectionView == self.selectCategoryCollectionView {
            return selectCategoryList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.allCategoryCollectionView {
         
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductMakeFilterCell", for: indexPath) as! ProductMakeFilterCell
            
            cell.cornerradius = 22
            let category = self.userCategoryList[indexPath.row]
            cell.categoryLabel.text = category.smallCategoryName ?? ""
            
            cell.isFilterSelected = true
   
            return cell
        }
        
        if collectionView == self.selectCategoryCollectionView {
         
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileSelectCategoryCell", for: indexPath) as! UserProfileSelectCategoryCell
            
            
            let category = self.selectCategoryList[indexPath.row]
            cell.categoryLabel.text = category.smallCategoryName ?? ""
            
            cell.isFilterSelected = true
   
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == allCategoryCollectionView {
            let category = self.userCategoryList[indexPath.row]
            
            
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 32, height: 44)
        } else {
            
            let category = self.selectCategoryList[indexPath.row]
            
            
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 48, height: 44)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
 
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        if collectionView == self.allCategoryCollectionView {
            let selectedCategory = self.userCategoryList[indexPath.row]
            
            self.userCategoryList.remove(at: userCategoryList.firstIndex(where: { $0.smallCategoryId! == selectedCategory.smallCategoryId! })!)
            self.selectCategoryList.append(selectedCategory)
            
        }
        
        if collectionView == self.selectCategoryCollectionView {
            let selectedCategory = self.selectCategoryList[indexPath.row]
            
            self.userCategoryList.append(selectedCategory)
            self.selectCategoryList.remove(at: selectCategoryList.firstIndex(where: { $0.smallCategoryId! == selectedCategory.smallCategoryId! })!)
            
        }
    }
    
}

