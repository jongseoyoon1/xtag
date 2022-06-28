//
//  MyPageVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/12.
//

import UIKit
import Kingfisher

class MyPageVC: UIViewController {
    
    enum MyPageType: String {
    case Album = "Album"
    case Collection = "Collection"
    }
    
    /* ScrollView */
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var descroptionLabel: UILabel!
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var follwerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var collectionMoreButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var myPageType : MyPageType = .Album
    
    private var postList: [PostModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    public var smallCategoryList: [SmallCategoryModel] = []
    public var selectedCategoryIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        getPost()
        setupCollectionView()
        getUserCategory()
    }
    
    private func setupUI() {
        guard let userInfo = UserManager.shared.userInfo else { return }
        print(userInfo)
        
        
        if userInfo.s3ImageUri != nil {
            if userInfo.s3ImageUri! == "" {
                profileImageVIew.kf.setImage(with: URL(string: userInfo.s3ImageUri!), placeholder: UIImage(named: "profile_image"))
            }
            
        }
        
        nameLabel.text = userInfo.name
        follwerLabel.text = userInfo.followers
        followingLabel.text = userInfo.followings
        descroptionLabel.text = userInfo.introduction
        
        view.layoutIfNeeded()
        
        print("********************************* stackView Frame")
        print("frame = \(stackView.frame)")
        contentViewHeight.constant = self.view.frame.height + stackView.frame.origin.y - 40 - 92
        print("********************************* stackView Frame")
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
        
        collectionView.contentInset = UIEdgeInsets.zero
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "MyPageMoreCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MyPageMoreCollectionCell")
        categoryCollectionView.register(UINib(nibName: "MyPageFilterCell", bundle: nil), forCellWithReuseIdentifier: "MyPageFilterCell")
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func collectionMoreBtnPressed(_ sender: Any) {
        
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.smallCategoryList = smallCategoryModel ?? []
                
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    private func getPost() {
        if CategoryManager.shared.mainSelectedSmallCategory == nil {
            HTTPSession.shared.feed(smallCategoryId: nil, page: nil, size: nil) { result, error in
                if error == nil {
                    guard let result = result else {
                        return
                    }

                    self.postList = result
                }
            }
        } else {
            
        }
        
    }
    
}

extension MyPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if collectionView == self.collectionView {
            let post = postList[indexPath.row]
            let ratio = post.postImageRatio
            let rx = CGFloat(ratio!.getRatioRx())
            let ry = CGFloat(ratio!.getRatioRy())
            
            let width = (self.view.frame.size.width - 2) / 2
            var height = width * ry / rx
            
            if rx == 0 || ry == 0 {
                height = width
            }
            
            print("rx = \(rx) ry = \(ry)")
            print("width = \(width) hieght = \(height)")
            
            return height
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return postList.count
        } else if collectionView == self.categoryCollectionView {
            print("smallCategoryList.count = \(smallCategoryList.count)")
            return smallCategoryList.count + 2
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
            let post = postList[indexPath.row]
            
            cell.setupCell(userName: post.userName ?? "", profileImageUri: post.userCdnImageUri ?? "", postImageUri: post.postCdnImageUri ?? "")
            
            
            
            
            return cell
        }
        
        if collectionView == self.categoryCollectionView {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageMoreCollectionCell", for: indexPath) as! MyPageMoreCollectionCell
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageFilterCell", for: indexPath) as! MyPageFilterCell
            
            
            
            if indexPath.row == 1 {
                cell.type = .ALL
                
                cell.categoryLabel.text = "ALL"
                
                if indexPath.row == selectedCategoryIndex {
                    cell.isFilterSelected = true
                } else {
                    cell.isFilterSelected = false
                }
            } else {
                cell.type = .FILTER
                
                let category = self.smallCategoryList[indexPath.row - 2]
                cell.categoryLabel.text = category.smallCategoryName ?? ""
                cell.followingCountLabel.text = "0"
                
                if indexPath.row == selectedCategoryIndex {
                    cell.isFilterSelected = true
                } else {
                    cell.isFilterSelected = false
                }
            }
            
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let post = postList[indexPath.row]
            let ratio = post.postImageRatio
            let rx = CGFloat(ratio!.getRatioRx())
            let ry = CGFloat(ratio!.getRatioRy())
            
            let width = (self.view.frame.size.width - 2) / 2
            var height = width * rx / ry
            
            if rx == 0 || ry == 0 {
                height = width
            }
            
            print("rx = \(rx) ry = \(ry)")
            print("width = \(width) hieght = \(height)")
            
            return CGSize(width: width, height: height)
        }
        
        if collectionView == self.categoryCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: 36, height: 36)
            }
            
            if indexPath.row == 1 {
                let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                let fontAttributes = [NSAttributedString.Key.font : font]
                let text = "ALL"
                let size = (text as NSString).size(withAttributes: fontAttributes)
                
                return CGSize(width: size.width + 32, height: 54)
            }
            
            if indexPath.row > 1 {
                if indexPath.row == selectedCategoryIndex {
                    let category = self.smallCategoryList[indexPath.row - 2]
                    
                    
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
                    let category = self.smallCategoryList[indexPath.row - 2]
                    
                    
                    let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
                    let fontAttributes = [NSAttributedString.Key.font : font]
                    let text = category.smallCategoryName ?? ""
                    let size = (text as NSString).size(withAttributes: fontAttributes)
                    
                    return CGSize(width: size.width + 32, height: 54)
                }
                
            }
            
            return CGSize(width: 120, height: 54)
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
        if collectionView == self.collectionView {
            if let viewController = UIStoryboard(name: "UserPost", bundle: nil).instantiateViewController(withIdentifier: "UserPostVC") as? UserPostVC {
                
                viewController.modalPresentationStyle = .fullScreen
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        if collectionView == self.categoryCollectionView {
            self.selectedCategoryIndex = indexPath.row
            
            self.categoryCollectionView.reloadData()
        }
        
        
    }
    
    
}
