//
//  ProductTagProductsCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/19.
//

import UIKit

class ProductTagProductsCell: UITableViewCell {
    
    public static let IDENTIFIER = "ProductTagProductsCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productCountLabel: UILabel!
    
    public var productDetailVC : ProductDetailVC!
    public var postList: [PostModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setupCollectionView()
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
    
}

extension ProductTagProductsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let post = postList[indexPath.row]
        let ratio = post.postImageRatio
        let rx = CGFloat(ratio!.getRatioRx())
        let ry = CGFloat(ratio!.getRatioRy())
        
        let width = (self.frame.size.width - 2) / 2
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
        cell.profileImageView.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = postList[indexPath.row]
        let ratio = post.postImageRatio
        let rx = CGFloat(ratio!.getRatioRx())
        let ry = CGFloat(ratio!.getRatioRy())
        
        let width = (self.frame.size.width - 2) / 2
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
        let post = postList[indexPath.row]
        if let viewController = UIStoryboard(name: "UserPost", bundle: nil).instantiateViewController(withIdentifier: "UserPostVC") as? UserPostVC {
            MainNavigationBar.isHidden = true
            viewController.modalPresentationStyle = .fullScreen
            viewController.postId = post.postId ?? ""
            productDetailVC.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
}
