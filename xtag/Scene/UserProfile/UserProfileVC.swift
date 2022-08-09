//
//  MyPageVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/12.
//

import UIKit
import Kingfisher

class UserProfileVC: UIViewController {
    
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
    @IBOutlet weak var collectionMoreButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    private var selectedSmallCategoryId = ""
    
    public var userId = ""
    private var userInfo : UserInfo?
    
    var myPageType : MyPageType = .Album {
        didSet {
            self.setMenuButtons()
        }
    }
    
    private var postList: [PostModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var productList: [ProductModel] = [] {
        didSet {
            
            self.setMenuButtons()
            self.productCollectionView.reloadData()
        }
    }
    
    public var smallCategoryList: [SmallCategoryModel] = []
    public var selectedCategoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
    }
    
    private func getUserInfo() {
        HTTPSession.shared.getUserProfile(userId: userId) { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }
                
                self.userInfo = result
                
                self.setupUI()
                self.getPost()
                self.setupCollectionView()
                self.getUserCategory()
            }
        }
    }
    
    private func setupUI() {
        guard let userInfo = self.userInfo else { return }
        print(userInfo)
        
        profileImageVIew.kf.setImage(with: URL(string: userInfo.s3ImageUri ?? (userInfo.cdnImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
    
        
        nameLabel.text = userInfo.name
        follwerLabel.text = userInfo.followers
        descroptionLabel.text = userInfo.introduction
        
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
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "MyPageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MyPageCollectionCell")
    }
    
    private func setMenuButtons() {
        if myPageType == .Album {
            self.productCollectionView.isHidden = true
            
            albumButton.setTitle("Album \(postList.count)", for: [])
            collectionButton.setTitle("Collection", for: [])
            albumButton.setAttributedTitle(applyBoldAttributedStringSelected("Album \(postList.count)", highlightText: "\(postList.count)"), for: [])
            collectionButton.setAttributedTitle(applyBoldAttributedStringDeSelected("Collection \(productList.count)", highlightText: "\(productList.count)"), for: [])
            
        } else {
            self.productCollectionView.isHidden = false
            
            albumButton.setTitle("Album \(postList.count)", for: [])
            collectionButton.setTitle("Collection", for: [])
            
            albumButton.setAttributedTitle(applyBoldAttributedStringDeSelected("Album \(postList.count)", highlightText: "\(postList.count)"), for: [])
            collectionButton.setAttributedTitle(applyBoldAttributedStringSelected("Collection \(productList.count)", highlightText: "\(productList.count)"), for: [])
            
        }
        
        self.collectionView.reloadData()
    }
    
    @IBAction func followBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileCategoryVC") as? UserProfileCategoryVC {
            viewcontroller.modalPresentationStyle = .fullScreen
            viewcontroller.originalSelectCategoryList = self.smallCategoryList
            viewcontroller.userInfo = self.userInfo!
            
            self.present(viewcontroller, animated: false)
        }
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as? SettingVC {
            
            viewcontroller.modalPresentationStyle = .fullScreen
            self.present(viewcontroller, animated: true)
        }
    }
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: userId) { smallCategoryModel, error in
            if error == nil {
                self.smallCategoryList = smallCategoryModel ?? []
                
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    private func getPost() {
        
        
        HTTPSession.shared.getPostAlbum(userId: userId,
                                        smallCategoryId: selectedSmallCategoryId) { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }
                
                self.postList = result
                
                HTTPSession.shared.getUserProductWithReview(userId: self.userId,
                                                            smallCategoryId: self.selectedSmallCategoryId, status: "active") { result, error in
                    if error == nil {
                        guard let result = result else {
                            return
                        }
                        self.productList = result
                        self.setMenuButtons()
                        
                    }
                }
                
            }
        }
        
    }
    @IBAction func albumBtnPressed(_ sender: Any) {
        self.myPageType = .Album
    }
    
    @IBAction func collectionBtnPressed(_ sender: Any) {
        self.myPageType = .Collection
    }
    
    fileprivate func applyBoldAttributedStringSelected(_ originalText: String, highlightText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText, attributes: [
            .font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 16)!,
            .foregroundColor: XTColor.GREY_900.getColorWithString()
            
        ])
        
        let range = (originalText as NSString).range(of:highlightText)
        attributedString.addAttribute(
            .font,
            value: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13.0)!,
            range: range)
        
        attributedString.addAttribute(.foregroundColor, value: XTColor.BLUE_800.getColorWithString(), range: range)
        
        return attributedString
        
    }
    
    fileprivate func applyBoldAttributedStringDeSelected(_ originalText: String, highlightText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText, attributes: [
            .font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 16)!,
            .foregroundColor: XTColor.GREY_500.getColorWithString()
            
        ])
        
        let range = (originalText as NSString).range(of:highlightText)
        attributedString.addAttribute(
            .font,
            value: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13.0)!,
            range: range)
        
        attributedString.addAttribute(.foregroundColor, value: XTColor.GREY_400.getColorWithString(), range: range)
        
        return attributedString
        
    }
}

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if collectionView == self.collectionView {
            if self.myPageType == .Album {
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
            } else {
                let width = (self.view.frame.width - 2) / 3
                
                return width + 40
            }
            
            
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if myPageType == .Album {
                return postList.count
            }
            
        } else if collectionView == self.categoryCollectionView {
            print("smallCategoryList.count = \(smallCategoryList.count)")
            return smallCategoryList.count + 1
        } else if collectionView == self.productCollectionView {
            return productList.count
            
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            if self.myPageType == .Album {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
                let post = postList[indexPath.row]
                
                cell.setupCell(userName: post.userName ?? "", profileImageUri: post.userCdnImageUri ?? "", postImageUri: post.postCdnImageUri ?? "")
                
                
                
                
                return cell
            }
        }
        
        
        if collectionView == self.productCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageCollectionCell", for: indexPath) as! MyPageCollectionCell
            
            let product = productList[indexPath.row]
            cell.imageView.kf.setImage(with: URL(string: product.productImageUri ?? ""), placeholder: UIImage(named: "nproduct_image"))
            cell.contentLabel.text = product.productTitle
            return cell
            
        }
        
        if collectionView == self.categoryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageFilterCell", for: indexPath) as! MyPageFilterCell
            
            
            
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
                
                let category = self.smallCategoryList[indexPath.row - 1]
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
            if self.myPageType == .Album {
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
            
        }
        
        if collectionView == self.productCollectionView {
            let width = (self.view.frame.width - 2) / 3
            
            return CGSize(width: width, height: width + 40)
            
        }
        
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
                    let category = self.smallCategoryList[indexPath.row - 1]
                    
                    
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
                    let category = self.smallCategoryList[indexPath.row - 1]
                    
                    
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
            
            if indexPath.row == 0 {
                self.selectedSmallCategoryId = ""
                self.getPost()
                
                self.categoryCollectionView.reloadData()
            } else {
                let category = self.smallCategoryList[indexPath.row - 1]
                self.selectedSmallCategoryId = category.smallCategoryId ?? ""
                self.getPost()
                
                self.categoryCollectionView.reloadData()
            }
            
            
        }
        
        
    }
    
    
}
