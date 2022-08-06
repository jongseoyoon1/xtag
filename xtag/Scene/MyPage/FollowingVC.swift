//
//  FollowingVC.swift
//  xtag
//
//  Created by Yoon on 2022/08/01.
//

import UIKit

class FollowingVC: UIViewController {
    
    enum FollowType {
        case FOLLOW
        case FOLLOWING
    }
    
    @IBOutlet weak var indexLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    
    public var userId = ""
    
    private var followerCount = 0
    private var followingCount = 0
    
    private var followType: FollowType = .FOLLOW {
        didSet {
            
            if followType == .FOLLOW {
                followerButton.setAttributedTitle(self.applySelectBoldAttributedStringSelected("\(followerCount) 팔로워", highlightText: "\(followerCount)"), for: [])
                followingButton.setAttributedTitle(self.applyDeselectBoldAttributedStringSelected("\(followingCount) 팔로잉", highlightText: "\(followingCount)"), for: [])
            } else {
                followingButton.setAttributedTitle(self.applySelectBoldAttributedStringSelected("\(followingCount) 팔로잉", highlightText: "\(followingCount)"), for: [])
                followerButton.setAttributedTitle(self.applyDeselectBoldAttributedStringSelected("\(followerCount) 팔로워", highlightText: "\(followerCount)"), for: [])
            }
            
            selectedCategoryIndex = 0
            selectedSmallCategoryId = ""
            
            self.categoryCollectionView.reloadData()
            self.tableView.reloadData()
            
            
        }
    }
    private var selectedCategoryIndex = 0
    private var selectedSmallCategoryId = "" {
        didSet {
            if followType == .FOLLOW {
                self.getFollowers()
            } else {
                self.getFollowingUser()
            }
        }
    }
    
    private var followSmallCategoryList: [SmallCategoryModel] = []
    private var followingSmallCategoryList: [SmallCategoryModel] = []
    
    private var followerUserList : [BlockUserModel] = []
    private var followingUserList : [BlockUserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableVeiw()
        getUser()
    }
    
    private func setupCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "MyPageMoreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MyPageMoreCollectionCell")
        categoryCollectionView.register(UINib(nibName: "MyPageFilterCell", bundle: nil), forCellWithReuseIdentifier: "MyPageFilterCell")
        
        self.categoryCollectionView.register(SmallCategoryCell.self, forCellWithReuseIdentifier: SmallCategoryCell.IDENTIFIER)
    }
    
    private func setupTableVeiw() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingBlockUserCell", bundle: nil), forCellReuseIdentifier: "SettingBlockUserCell")
    }
    
    private func getUser() {
        HTTPSession.shared.getUserProfile(userId: userId) { userInfo, error in
            if error == nil {
                guard let userInfo = userInfo else {
                    return
                }
                self.setupUI(userInfo: userInfo)
            }
        }
    }
    
    private func setupUI(userInfo: UserInfo) {
        profileImageView.kf.setImage(with: URL(string: userInfo.cdnImageUri ?? (userInfo.s3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
        nameLabel.text = userInfo.name
        
        followerCount = Int(userInfo.followers ?? "0")!
        followingCount = Int(userInfo.followings ?? "0")!
        
        followerButton.setAttributedTitle(self.applySelectBoldAttributedStringSelected("\(userInfo.followers ?? "") 팔로워", highlightText: "\(userInfo.followers ?? "")"), for: [])
        followingButton.setAttributedTitle(self.applyDeselectBoldAttributedStringSelected("\(userInfo.followings ?? "") 팔로잉", highlightText: "\(userInfo.followings ?? "")"), for: [])
        
        getUserCategory()
        getFollowers()
        getFollowingCategory()
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.followSmallCategoryList = smallCategoryModel ?? []
                
                self.categoryCollectionView.reloadData()
                self.getFollowers()
            
            }
        }
    }
    
    private func getFollowingCategory() {
        HTTPSession.shared.getFollowCategoryAll { result, error in
            if error == nil {
                self.followingSmallCategoryList = result ?? []
           
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    private func getFollowingUser() {
        HTTPSession.shared.getFollowingUser(smallCategoryId: "", page: "0", size: "20") { user, _, error in
            if error == nil {
                self.followingUserList = user ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    private func getFollowers() {
        HTTPSession.shared.getFollowerUser(smallCategoryId: selectedSmallCategoryId, page: "0", size: "20") { userList, _, error in
            if error == nil {
                self.followerUserList = userList ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func applySelectBoldAttributedStringSelected(_ originalText: String, highlightText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText, attributes: [
            .font: UIFont(name: XTFont.PRETENDARD_REGULAR, size: 14)!,
            .foregroundColor: XTColor.GREY_900.getColorWithString()
            
        ])
        
        let range = (originalText as NSString).range(of:highlightText)
        attributedString.addAttribute(
            .font,
            value: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14.0)!,
            range: range)
        
        attributedString.addAttribute(.foregroundColor, value: XTColor.GREY_900.getColorWithString(), range: range)
                                      
        return attributedString
        
    }
    
    fileprivate func applyDeselectBoldAttributedStringSelected(_ originalText: String, highlightText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText, attributes: [
            .font: UIFont(name: XTFont.PRETENDARD_REGULAR, size: 14)!,
            .foregroundColor: XTColor.GREY_500.getColorWithString()
            
        ])
        
        let range = (originalText as NSString).range(of:highlightText)
        attributedString.addAttribute(
            .font,
            value: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14.0)!,
            range: range)
        
        attributedString.addAttribute(.foregroundColor, value: XTColor.GREY_500.getColorWithString(), range: range)
                                      
        return attributedString
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func followerBtnPressed(_ sender: Any) {
        followType = .FOLLOW
        indexLeadingConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func followingBtnPressed(_ sender: Any) {
        followType = .FOLLOWING
        indexLeadingConstraint.constant = self.view.frame.width / 2
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension FollowingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if followType == .FOLLOWING {
            return followingSmallCategoryList.count
        } else {
            return followSmallCategoryList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.categoryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageFilterCell", for: indexPath) as! MyPageFilterCell
            
            if self.followType == .FOLLOW {
                if indexPath.row == 0 {
                    cell.type = .ALL
                    
                    cell.categoryLabel.text = "ALL"
                    
                    if indexPath.row == selectedCategoryIndex {
                        cell.isFilterSelected = true
                    } else {
                        cell.isFilterSelected = false
                    }
                } else {
                    cell.type = .FILTER
                    if self.followSmallCategoryList.count > indexPath.row - 1 {
                        let category = self.followSmallCategoryList[indexPath.row - 1]
                        cell.categoryLabel.text = category.smallCategoryName ?? ""
                        cell.followingCountLabel.text = "0"
                        
                        if indexPath.row == selectedCategoryIndex {
                            cell.isFilterSelected = true
                        } else {
                            cell.isFilterSelected = false
                        }
                    }
                    
                }
            } else {
                if indexPath.row == 0 {
                    cell.type = .ALL
                    
                    cell.categoryLabel.text = "ALL"
                    
                    if indexPath.row == selectedCategoryIndex {
                        cell.isFilterSelected = true
                    } else {
                        cell.isFilterSelected = false
                    }
                } else {
                    cell.type = .FILTER
                    if self.followSmallCategoryList.count > indexPath.row - 1 {
                        let category = self.followSmallCategoryList[indexPath.row - 1]
                        cell.categoryLabel.text = category.smallCategoryName ?? ""
                        cell.followingCountLabel.text = "0"
                        
                        if indexPath.row == selectedCategoryIndex {
                            cell.isFilterSelected = true
                            cell.followingCountLabel.isHidden = true
                            cell.iconImageView.isHidden = true
                        } else {
                            cell.isFilterSelected = false
                        }
                    }
                    
                }
            }
            
            
            
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if followType == .FOLLOW {
            if collectionView == self.categoryCollectionView {
                
                if indexPath.row == 0 {
                    let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                    let fontAttributes = [NSAttributedString.Key.font : font]
                    let text = "ALL"
                    let size = (text as NSString).size(withAttributes: fontAttributes)
                    
                    return CGSize(width: size.width + 32, height: 54)
                }
                
                if indexPath.row > 0 {
                    if indexPath.row == selectedCategoryIndex {
                        let category = self.followSmallCategoryList[indexPath.row - 1]
                        
                        
                        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                        let fontAttributes = [NSAttributedString.Key.font : font]
                        let text = category.smallCategoryName ?? ""
                        let size = (text as NSString).size(withAttributes: fontAttributes)
                        
                        let font2 = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13)
                        let fontAttributes2 = [NSAttributedString.Key.font : font2]
                        let text2 = "0"
                        let size2 = (text2 as NSString).size(withAttributes: fontAttributes2)
                        
                        return CGSize(width: size.width + size2.width + 57, height: 54)
                    } else {
                        let category = self.followSmallCategoryList[indexPath.row - 1]
                        
                        
                        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                        let fontAttributes = [NSAttributedString.Key.font : font]
                        let text = category.smallCategoryName ?? ""
                        let size = (text as NSString).size(withAttributes: fontAttributes)
                        
                        return CGSize(width: size.width + 32, height: 54)
                    }
                    
                }
                
                return CGSize(width: 120, height: 54)
            }
        } else {
            if collectionView == self.categoryCollectionView {
                
                if indexPath.row == 0 {
                    let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                    let fontAttributes = [NSAttributedString.Key.font : font]
                    let text = "ALL"
                    let size = (text as NSString).size(withAttributes: fontAttributes)
                    
                    return CGSize(width: size.width + 32, height: 54)
                }
                
                if indexPath.row > 0 {
                    if indexPath.row == selectedCategoryIndex {
                        let category = self.followSmallCategoryList[indexPath.row - 1]
                        
                        
                        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                        let fontAttributes = [NSAttributedString.Key.font : font]
                        let text = category.smallCategoryName ?? ""
                        let size = (text as NSString).size(withAttributes: fontAttributes)
                        
                        let font2 = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13)
                        let fontAttributes2 = [NSAttributedString.Key.font : font2]
                        let text2 = "0"
                        let size2 = (text2 as NSString).size(withAttributes: fontAttributes2)
                        
                        return CGSize(width: size.width + 32, height: 54)
                    } else {
                        let category = self.followSmallCategoryList[indexPath.row - 1]
                        
                        
                        let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                        let fontAttributes = [NSAttributedString.Key.font : font]
                        let text = category.smallCategoryName ?? ""
                        let size = (text as NSString).size(withAttributes: fontAttributes)
                        
                        return CGSize(width: size.width + 32, height: 54)
                    }
                    
                }
                
                return CGSize(width: 120, height: 54)
                
                
            }
        }
        
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.categoryCollectionView {
            return 16
        }
        
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.categoryCollectionView {
            return 16
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  followType == .FOLLOW {
            
            if collectionView == self.categoryCollectionView {
                self.selectedCategoryIndex = indexPath.row
                
                
                if indexPath.row == 0 {
                    self.selectedSmallCategoryId = ""
                    
                    self.categoryCollectionView.reloadData()
                } else if indexPath.row > 0 {
                    let category = self.followSmallCategoryList[indexPath.row - 1]
                    self.selectedSmallCategoryId = category.smallCategoryId ?? ""
                    
                    self.categoryCollectionView.reloadData()
                }
            }
        } else {
            if collectionView == self.categoryCollectionView {
                self.selectedCategoryIndex = indexPath.row
                
                
                if indexPath.row == 0 {
                    self.selectedSmallCategoryId = ""
                    
                    self.categoryCollectionView.reloadData()
                } else if indexPath.row > 0 {
                    let category = self.followingSmallCategoryList[indexPath.row - 1]
                    self.selectedSmallCategoryId = category.smallCategoryId ?? ""
                    
                    self.categoryCollectionView.reloadData()
                }
            }
        }
        
    }
    
    
}


extension FollowingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if followType == .FOLLOW {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingBlockUserCell", for: indexPath) as! SettingBlockUserCell
            let user = followerUserList[indexPath.row]
            
            cell.selectionStyle = .none
            
            cell.profileImageView.kf.setImage(with: URL(string: user.userCdnImageUri ?? (user.userS3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
            cell.nameLabel.text = user.userName
            cell.blockButton.isHidden = true
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingBlockUserCell", for: indexPath) as! SettingBlockUserCell
            let user = followingUserList[indexPath.row]
            
            cell.selectionStyle = .none
            
            cell.profileImageView.kf.setImage(with: URL(string: user.userCdnImageUri ?? (user.userS3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
            cell.nameLabel.text = user.userName
            cell.blockButton.isHidden = true
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followType == .FOLLOW {
            return self.followerUserList.count
        } else {
            return self.followingUserList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
}
