//
//  FollwoingCollectionVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/27.
//

import UIKit
import Combine

class FollwoingCollectionVC: UIViewController {
    
    public var smallCategoryList: [SmallCategoryModel] = []
    
    private var selectedSmallCategory: SmallCategoryModel? {
        didSet {
            //self.collectionView.reloadData()
        }
    }
    
    private var followUserList : [BlockUserModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private var subscriptions = Set<AnyCancellable>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCategory()
        getFollowUser()
    }
    
    private func getCategory() {
        HTTPSession.shared.getFollowCategoryAll { result, error in
            if error == nil {
                self.smallCategoryList = result ?? []
                let width = (self.view.frame.size.width - 32 - 44) / 3 - 1 + 18
                
                if self.smallCategoryList.count <= 3 {
                    self.categoryCollectionViewHeight.constant = width / 2
                } else if self.smallCategoryList.count > 3 {
                    self.categoryCollectionViewHeight.constant = width
                } else {
                    let count = self.smallCategoryList.count / 3
                    let remain = self.smallCategoryList.count % 3
                    
                    if remain != 0 {
                        self.categoryCollectionViewHeight.constant = (width / 2) * CGFloat((count + 1))
                    } else {
                        self.categoryCollectionViewHeight.constant = (width / 2) * CGFloat((count ))
                    }
                }
                
                
                
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    private func getFollowUser() {
        HTTPSession.shared.getFollowingUser(smallCategoryId: "", page: "0", size: "20") { user, _, error in
            if error == nil {
                self.followUserList = user ?? []
                
                self.tableViewHeight.constant = CGFloat(72 * self.followUserList.count)
                
                self.tableView.reloadData()
            }
        }
    }
    

    private func setupCollectionView() {
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.register(SmallCategoryCell.self, forCellWithReuseIdentifier: SmallCategoryCell.IDENTIFIER)
    }
    
    private func setupUI() {
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingBlockUserCell", bundle: nil), forCellReuseIdentifier: "SettingBlockUserCell")
    }

}

extension FollwoingCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return smallCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        let width = (self.view.frame.size.width - 32 - 44) / 3 - 1
        return CGSize(width: width, height: width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
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


extension FollwoingCollectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingBlockUserCell", for: indexPath) as! SettingBlockUserCell
        let user = followUserList[indexPath.row]
        
        cell.profileImageView.kf.setImage(with: URL(string: user.userCdnImageUri ?? (user.userS3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
        cell.nameLabel.text = user.userName
        cell.blockButton.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followUserList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
}
