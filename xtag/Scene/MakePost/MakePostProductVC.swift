//
//  MakePostProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/27.
//

import UIKit

class MakePostProductVC: UIViewController {

    @IBOutlet weak var compButton: UIButton!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var productThumbnailCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private var selectedCategory: SmallCategoryModel!
    private var categoryList: [SmallCategoryModel] = []
    private var selectedProductList: [ProductModel] = [] {
        didSet {
            compButton.setTitle("선택 \(selectedProductList.count)", for: []
            )
            productThumbnailCollectionView.reloadData()
        }
    }
    private var productList: [ProductModel] = [] {
        didSet {
            productCollectionView.reloadData()
        }
    }
    private var selectedIndex: [Int] = [] {
        didSet {
            productCollectionView.reloadData()
        }
    }
    
    private var selectedCategoryId = "" {
        didSet {
            getProduct()
            categoryCollectionView.reloadData()
        }
    }
    
    public var postIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        getProduct()
        getUserCategory()
    }
    
    private func setupCollectionView() {
        productThumbnailCollectionView.delegate = self
        categoryCollectionView.delegate = self
        productCollectionView.delegate = self
        
        productThumbnailCollectionView.dataSource = self
        categoryCollectionView.dataSource = self
        productCollectionView.dataSource = self
        
        productThumbnailCollectionView.register(UINib(nibName: "UserPostProductCell", bundle: nil), forCellWithReuseIdentifier: UserPostProductCell.IDENTIFIER)
        categoryCollectionView.register(UINib(nibName: "UserPostTagCell", bundle: nil), forCellWithReuseIdentifier: UserPostTagCell.IDENTIFIER)
        productCollectionView.register(UINib(nibName: "MyPageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MyPageCollectionCell")
        
    }
    
    private func getProduct() {
        HTTPSession.shared.getUserProductWithReview(userId: UserManager.shared.userInfo?.userId ?? "", smallCategoryId: selectedCategoryId) { result, error in
            if error == nil {
                self.productList = result ?? []
                
                var height = ((self.view.frame.width - 2) / 3 ) + 40
                
                var count = self.productList.count / 3
                if self.productList.count % 3 != 0 {
                    count = count + 1
                }
                
                self.productCollectionViewHeightConstraint.constant = CGFloat(count) * height
                self.view.layoutSubviews()
                
                self.productCountLabel.attributedText = self.applyBoldAttributedStringSelected("평가한 상품" + "\(self.productList.count)" + "개", highlightText: "\(self.productList.count)")
            }
        }
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.categoryList = smallCategoryModel ?? []
                
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    fileprivate func applyBoldAttributedStringSelected(_ originalText: String, highlightText: String) -> NSMutableAttributedString {
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
    @IBAction func compBtnPressed(_ sender: Any) {
        MakePostManager.shared.postList[postIndex].productList = self.selectedProductList
        
        self.dismiss(animated: true)
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension MakePostProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productThumbnailCollectionView {
            let product = selectedProductList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostProductCell.IDENTIFIER, for: indexPath) as! UserPostProductCell
            
            cell.productImageView.kf.setImage(with: URL(string: product.productImageUri ?? ""))
            cell.productImageView.layer.borderWidth = 0.0
            
            return cell
            
        } else if collectionView == categoryCollectionView {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
                
                cell.tagButton.setTitle("최근", for: [])
                cell.tagButton.isUserInteractionEnabled = false
                
                cell.layer.cornerRadius = 16
                
                if selectedCategoryId == "" {
                    cell.setButtonState(isSelected: true)
                } else {
                    cell.setButtonState(isSelected: false)
                }
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
                
                let category = categoryList[indexPath.row - 1]
                
                cell.tagButton.setTitle(category.smallCategoryName ?? "", for: [])
                cell.tagButton.isUserInteractionEnabled = false
                cell.setButtonState(isSelected: true)
                cell.layer.cornerRadius = 16
                
                if selectedCategoryId == "" {
                    cell.setButtonState(isSelected: true)
                } else {
                    if selectedCategoryId == category.smallCategoryId! {
                        cell.setButtonState(isSelected: true)
                    } else {
                        cell.setButtonState(isSelected: false)
                    }
                }
                
                return cell
            }
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageCollectionCell", for: indexPath) as! MyPageCollectionCell
            
            let product = productList[indexPath.row]
            cell.imageView.kf.setImage(with: URL(string: product.productImageUri ?? ""), placeholder: UIImage(named: "nproduct_image"))
            cell.contentLabel.text = product.productTitle
            cell.countView.isHidden = false
            
            if self.selectedIndex.contains(indexPath.row) {
                cell.countView.backgroundColor = XTColor.GREY_900.getColorWithString()
                cell.countView.bordercolor = XTColor.GREY_900.getColorWithString()
                
                cell.countLabel.text = "\((self.selectedIndex.firstIndex(of: indexPath.row) ?? 0) + 1)"
                
                cell.countLabel.isHidden = false
            } else {
                
                
                cell.countView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
                cell.countView.bordercolor = .white
                
                cell.countLabel.isHidden = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productThumbnailCollectionView {
            return selectedProductList.count
        } else if collectionView == categoryCollectionView {
            return categoryList.count + 1
        } else {
            return productList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productThumbnailCollectionView {
            return CGSize(width: 56, height: 56)
        } else if collectionView == categoryCollectionView {
            
            if indexPath.row == 0 {
                let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
                let fontAttributes = [NSAttributedString.Key.font : font]
                let text = "최근"
                let size = (text as NSString).size(withAttributes: fontAttributes)
                
                return CGSize(width: size.width + 24, height: 32)
            }
            
            let category = categoryList[indexPath.row - 1]
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 24, height: 32)
        } else {
            let width = (self.view.frame.width - 2) / 3
            
            return CGSize(width: width, height: width + 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productThumbnailCollectionView {
            
        } else if collectionView == categoryCollectionView {
            if indexPath.row == 0 {
                selectedCategoryId = ""
            } else {
                let category = categoryList[indexPath.row - 1]
                selectedCategoryId = category.smallCategoryId!
            }
        } else {
            if self.selectedIndex.contains(indexPath.row) {
                let product = productList[indexPath.row]
                self.selectedIndex.remove(at: self.selectedIndex.firstIndex(of: indexPath.row)!)
                self.selectedProductList.remove(at: self.selectedProductList.firstIndex(where: { $0.userProductId! == product.userProductId! })!)
            } else {
                self.selectedIndex.append(indexPath.row)
                
                let product = productList[indexPath.row]
                selectedProductList.append(product)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == productThumbnailCollectionView {
            
        } else if collectionView == categoryCollectionView {
            
        } else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productThumbnailCollectionView {
            return 8
        } else if collectionView == categoryCollectionView {
            return 9
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productThumbnailCollectionView {
            return 8
        } else if collectionView == categoryCollectionView {
            return 9
        } else {
            return 1
        }
    }
}

