//
//  SecretProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/20.
//

import UIKit

class SecretProductVC: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var productList : [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupCollectionView()
    }
 
    private func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "MyPageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MyPageCollectionCell")
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension SecretProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            return productList.count
            
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
       if collectionView == self.productCollectionView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageCollectionCell", for: indexPath) as! MyPageCollectionCell
           
           let product = productList[indexPath.row]
           cell.imageView.kf.setImage(with: URL(string: product.productCdnImageUri ?? ""), placeholder: UIImage(named: "nproduct_image"))
           cell.contentLabel.text = product.productTitle
           return cell
            
        }
      
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        
        if collectionView == self.productCollectionView {
            let width = (self.view.frame.width - 2) / 3
            
            return CGSize(width: width, height: width + 40)
            
        }
        
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
   
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    
}
