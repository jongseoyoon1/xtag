//
//  MakePostUploadVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/27.
//

import UIKit

class MakePostUploadVC: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var postImageCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    public var selectedCategory: [SmallCategoryModel] = []
    public var imageList: [UIImage] = []
    public var ratioType : RatioType!
    
    private var pageIndex = 1 {
        didSet {
            pageLabel.text = "\(pageIndex)/\(imageList.count)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pageLabel.text = "\(pageIndex)/\(imageList.count)"
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        productCollectionView.delegate = self
        postImageCollectionView.delegate = self
        categoryCollectionView.delegate = self
        
        productCollectionView.dataSource = self
        postImageCollectionView.dataSource = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "UserPostTagCell", bundle: nil), forCellWithReuseIdentifier: UserPostTagCell.IDENTIFIER)
        postImageCollectionView.register(UINib(nibName: "PostImageCell", bundle: nil), forCellWithReuseIdentifier: "PostImageCell")
    }


    @IBAction func tagBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostTagVC") as? MakePostTagVC {
            
            viewcontroller.postImage = self.imageList[pageIndex - 1]
            viewcontroller.modalPresentationStyle = .fullScreen
            
            self.present(viewcontroller, animated: true, completion: nil)
        }
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension MakePostUploadVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            return UICollectionViewCell()
        } else if collectionView == postImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
            
            let image = self.imageList[indexPath.row]
            
            cell.postImageView.image = image
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
            
            let category = selectedCategory[indexPath.row]
            
            cell.tagButton.setTitle(category.smallCategoryName ?? "", for: [])
            cell.tagButton.isUserInteractionEnabled = false
            cell.setButtonState(isSelected: true)
            cell.layer.cornerRadius = 16
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView {
            return 0
        } else if collectionView == postImageCollectionView {
            return imageList.count
        } else {
            return selectedCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            return CGSize(width:24, height: 32)
        } else if collectionView == postImageCollectionView {
            if self.ratioType == .ratio11 {
                let width = self.view.frame.size.width
                
                return CGSize(width: width, height: width)
            } else if self.ratioType == .ratio169 {
                let width = self.view.frame.size.width
                
                return CGSize(width: width, height: width / 16 * 9)
            } else {
                let width = self.view.frame.size.width
                
                return CGSize(width: width / 5 * 4, height: width )
            }
        } else {
            let category = selectedCategory[indexPath.row]
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 24, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productCollectionView {
            return 0
        } else if collectionView == postImageCollectionView {
            if self.ratioType == .ratio11 {
                let width = self.view.frame.size.width
                
                return 0
            } else if self.ratioType == .ratio169 {
                let width = self.view.frame.size.width
                
                return 0
            } else {
                let width = self.view.frame.size.width
                
                return width / 10
            }
        } else {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productCollectionView {
            return 0
        } else if collectionView == postImageCollectionView {
            if self.ratioType == .ratio11 {
                let width = self.view.frame.size.width
                
                return 0
            } else if self.ratioType == .ratio169 {
                let width = self.view.frame.size.width
                
                return 0
            } else {
                let width = self.view.frame.size.width
                
                return width / 10
            }
        } else {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView {
         
        } else if collectionView == postImageCollectionView {
          
        } else {
            
        }
    }
    
}
