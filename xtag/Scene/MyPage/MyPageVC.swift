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
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    var myPageType : MyPageType = .Album
    
    private var postList: [PostModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        guard let userInfo = UserManager.shared.userInfo else { return }
        print(userInfo)
        
        
        if userInfo.s3ImageUri != nil {
            if userInfo.s3ImageUri! == "" {
                profileImageVIew.kf.setImage(with: URL(string: userInfo.s3ImageUri!))
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
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func collectionMoreBtnPressed(_ sender: Any) {
        
    }
    
}

extension MyPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        let post = postList[indexPath.row]
        
        cell.setupCell(userName: post.userName ?? "", profileImageUri: post.userCdnImageUri ?? "", postImageUri: post.postCdnImageUri ?? "")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "UserPost", bundle: nil).instantiateViewController(withIdentifier: "UserPostVC") as? UserPostVC {
            
            viewController.modalPresentationStyle = .fullScreen
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
}
