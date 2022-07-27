//
//  MakePostTagVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/27.
//

import UIKit

class MakePostTagVC: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var postImageView: UIImageView!
    
    public var postImage: UIImage!
    public var productList: [ProductModel] = []
    
    var selectedProduct : ProductModel? {
        didSet {
            self.productCollectionView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
    }
    
    private func setupUI() {
        postImageView.image = postImage
    }
    
    private func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "UserPostProductCell", bundle: nil), forCellWithReuseIdentifier: UserPostProductCell.IDENTIFIER)
        productCollectionView.register(UINib(nibName: "MakePostTagPlusCell", bundle: nil), forCellWithReuseIdentifier: "MakePostTagPlusCell")
    }
    
    @IBAction func compBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension MakePostTagVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.productCollectionView {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MakePostTagPlusCell", for: indexPath) as! MakePostTagPlusCell
                
                
                return cell
            } else {
                let product = productList[indexPath.row - 1]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostProductCell.IDENTIFIER, for: indexPath) as! UserPostProductCell
                
                cell.productImageView.kf.setImage(with: URL(string: product.productImageUri ?? ""))
                
                if let selectedProduct = self.selectedProduct {
                    if product.userProductId! == selectedProduct.userProductId! {
                        cell.productImageView.layer.borderColor = XTColor.BLUE_800.getColorWithString().cgColor
                        cell.productImageView.layer.borderWidth = 4.0
                    } else {
                        cell.productImageView.layer.borderWidth = 0.0
                    }
                    
                } else {
                    cell.productImageView.layer.borderWidth = 0.0
                }
                
                
                return cell
            }
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.productCollectionView {
            return productList.count + 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == self.productCollectionView {
            return CGSize(width: 56, height: 56)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            if indexPath.row == 0 {
                
            } else {
                let product = productList[indexPath.row - 1]
                
                if self.selectedProduct == nil {
                    self.selectedProduct = product
                    
                } else {
                    if product.userProductId! == self.selectedProduct!.userProductId! {
                        self.selectedProduct = nil
                    } else {
                        self.selectedProduct = product
                    }
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
