//
//  UserPostImageTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/12.
//

import UIKit
import CHIPageControl

class UserPostImageTableCell: UITableViewCell {
    
    public static let IDENTIFIER = "UserPostImageTableCell"
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: CHIPageControlAleppo!
    @IBOutlet weak var imageCollectionViewHeightConstraint: NSLayoutConstraint!
    
    public var updateSelectedPostBody: ((PostBodyModel)->Void)?
    public var updateSelectedProduct: ((ProductModel?)->Void)?
    
    public var updateInndex: ((Int)->Void)?
    
    public var categoryList: [SmallCategoryModel] = []
    
    private var tagViews: [UIImageView] = []
    
    
    var selectedProduct : ProductModel? {
        didSet {
            self.productCollectionView.reloadData()
            
            
            guard let updateSelectedProduct = updateSelectedProduct else { return }
            updateSelectedProduct(self.selectedProduct)
            
            if selectedProduct != nil {
                let view = tagViews.filter({ $0.tag == Int(selectedProduct?.userProductId ?? "0")! })
                guard let view = view.first else { return }
                view.image = UIImage(named: "tag_45")
                view.backgroundColor = .clear
                view.frame.size = CGSize(width: 30, height: 30)
            } else {
                for view in tagViews {
                    view.image = nil
                    view.cornerradius = 3.5
                    view.backgroundColor = .white
                    view.frame.size = CGSize(width: 7, height: 7)
                }
            }
        }
    }
    
    var selectedPostBody: PostBodyModel? {
        didSet {
            guard let selectedPostBody = selectedPostBody else {
                return
            }
            selectedProduct = nil
            for view in tagViews {
                view.removeFromSuperview()
            }
            
            tagViews.removeAll()
            
            for product in selectedPostBody.postBodyProductList {
                let xratio = CGFloat(Float(product.productXRatio ?? "") ?? 0.0)
                let yratio = CGFloat(Float(product.productYRatio ?? "") ?? 0.0)
                let vw = UIImageView(frame: CGRect(x: self.frame.width * xratio - 3.5, y: self.imageCollectionView.frame.height * yratio - 3.5, width: 7, height: 7))
                vw.tag = Int(product.product!.userProductId ?? "0")!
                vw.cornerradius = 3.5
                vw.backgroundColor = .white
                print("add image view")
                tagViews.append(vw)
                self.contentView.addSubview(vw)
            }
            
            self.productCollectionView.reloadData()
            
            guard let updateSelectedPostBody = updateSelectedPostBody else {
                return
            }
            
            updateSelectedPostBody(selectedPostBody)
            
        }
    }
    
    public var postDetail: PostDetailModel? {
        didSet {
            self.imageCollectionView.reloadData()
            
            if let ratio = postDetail?.postImageRatio {
                let rx = CGFloat(ratio.getRatioRx())
                let ry = CGFloat(ratio.getRatioRy())
                
                let width = self.frame.size.width
                var height = width / rx * ry
                
                if rx == 0 || ry == 0 {
                    height = width
                }
                
                imageCollectionViewHeightConstraint.constant = height
                self.layoutIfNeeded()
            }
            
            
            if let firstPostBody = postDetail?.postBodyList.first {
                self.selectedPostBody = firstPostBody
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(UINib(nibName: "UserPostImageCell", bundle: nil), forCellWithReuseIdentifier: UserPostImageCell.IDENTIFIER)
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "UserPostProductCell", bundle: nil), forCellWithReuseIdentifier: UserPostProductCell.IDENTIFIER)
    }
    
}

extension UserPostImageTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostImageCell.IDENTIFIER, for: indexPath) as! UserPostImageCell
            
            let postBody = postDetail?.postBodyList[indexPath.row]
            cell.productImageView.kf.setImage(with: URL(string: postBody?.postBodyCdnImageUri ?? ""))
            
            return cell
        }
        
        if collectionView == self.productCollectionView {
            guard let selectedPostBody = self.selectedPostBody else { return UICollectionViewCell() }
            let postBody = selectedPostBody.postBodyProductList[indexPath.row]
            guard let product = postBody.product else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostProductCell.IDENTIFIER, for: indexPath) as! UserPostProductCell
            
            cell.productImageView.kf.setImage(with: URL(string: product.productImageUri ?? ""))
            
            if let selectedProduct = self.selectedProduct {
                if product.userProductId! == selectedProduct.userProductId! {
                    cell.productImageView.layer.borderColor = XTColor.GREY_800.getColorWithString().cgColor
                    cell.productImageView.layer.borderWidth = 4.0
                } else {
                    cell.productImageView.layer.borderWidth = 0.0
                }
                
            } else {
                cell.productImageView.layer.borderWidth = 0.0
            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.imageCollectionView {
            guard let postDetail = postDetail else { return 0 }
            return postDetail.postBodyList.count
        }
        
        if collectionView == self.productCollectionView {
            guard let selectedPostBody = self.selectedPostBody else { return 0 }
            return selectedPostBody.postBodyProductList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.imageCollectionView {
            
            if let ratio = postDetail?.postImageRatio {
                let rx = CGFloat(ratio.getRatioRx())
                let ry = CGFloat(ratio.getRatioRy())
                
                let width = self.frame.size.width
                var height = width / rx * ry
                
                if rx == 0 || ry == 0 {
                    height = width
                }
                
                return CGSize(width: width, height: height)
            }
            
        }
        
        if collectionView == self.productCollectionView {
            return CGSize(width: 56, height: 56)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            guard let selectedPostBody = selectedPostBody else {
                return
            }
            let product = selectedPostBody.postBodyProductList[indexPath.row]
            
            if self.selectedProduct == nil {
                self.selectedProduct = product.product!
                
            } else {
                if product.product!.userProductId! == self.selectedProduct!.userProductId! {
                    self.selectedProduct = nil
                } else {
                    self.selectedProduct = product.product!
                }
            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            self.selectedProduct = nil
        }
    }
}

extension UserPostImageTableCell : UIScrollViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        if let cv = scrollView as? UICollectionView {
            var currentIdx : CGFloat = 0
            let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let idx = round((offset.x + cv.contentInset.left) / cellWidth)
            
            if idx > currentIdx {
                currentIdx += 1
            } else if idx < currentIdx {
                if currentIdx != 0 {
                    currentIdx -= 1
                }
            }
            let page = Int(targetContentOffset.pointee.x / self.frame.width)
            let currentIndex = page
            guard let postBodyList = self.postDetail?.postBodyList else { return }
            self.selectedPostBody = postBodyList[currentIndex]
            self.pageControl.set(progress: currentIndex, animated: true)
//            offset = CGPoint(x: currentIdx * cellWidth - cv.contentInset.left, y: 0)
//
//            targetContentOffset.pointee = offset
            
            print("printCurrentIdx ", currentIdx)
            
            guard let updateIndex = self.updateInndex else { return }
            updateIndex(currentIndex)
        }
    }
}

