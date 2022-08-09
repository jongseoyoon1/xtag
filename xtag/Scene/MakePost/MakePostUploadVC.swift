//
//  MakePostUploadVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/27.
//

import UIKit

class MakePostUploadVC: UIViewController {
    
    private let placeholderTextList = ["첫 번째 사진 내용 작성",
                                       "두 번째 사진 내용 작성",
                                       "세 번째 사진 내용 작성",
                                       "네 번째 사진 내용 작성",
                                       "다섯 번째 사진 내용 작성",
                                       "여섯 번째 사진 내용 작성",
                                       "일곱 번째 사진 내용 작성",
                                       "여덟 번째 사진 내용 작성",
                                       "아홉 번째 사진 내용 작성",
                                       "열 번째 사진 내용 작성"]
    
    @IBOutlet weak var postImgaeCollectionVIewPaddingWidth: NSLayoutConstraint!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var postImageCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    public var selectedCategory: [SmallCategoryModel] = []
    public var imageList: [UIImage] = []
    public var ratioType : RatioType!
    
    private var placeholderText = "" {
        didSet {
            if MakePostManager.shared.postList[pageIndex - 1].content != nil {
                contentTextView.text = MakePostManager.shared.postList[pageIndex - 1].content
            } else {
                contentTextView.text = placeholderText
            }
            
        }
    }
    
    private var pageIndex = 1 {
        didSet {
            if pageIndex == 0 {
                pageIndex = 1
                return
            }
            
            pageLabel.text = "\(pageIndex)/\(imageList.count)"
            pageLabel.attributedText = applyAttributedString(pageLabel.text!, 1)
            
            if MakePostManager.shared.postList[pageIndex - 1].productList.count > 0 {
                productCollectionView.isHidden = false
                productCollectionView.reloadData()
            } else {
                productCollectionView.isHidden = true
            }
            
            postImageCollectionView.reloadItems(at: [IndexPath(item: pageIndex - 1, section: 0)])
            
            placeholderText = placeholderTextList[pageIndex - 1]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderText = placeholderTextList[pageIndex - 1]
        setupCollectionView()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageLabel.text = "\(pageIndex)/\(imageList.count)"
        pageLabel.attributedText = applyAttributedString(pageLabel.text!, 1)
        
        if ratioType == .ratio45 {
            let width = self.view.frame.size.width
            
            
            postImgaeCollectionVIewPaddingWidth.constant = width / 10
        } else {
            postImgaeCollectionVIewPaddingWidth.constant = 16
        }
        
        if MakePostManager.shared.postList[pageIndex - 1].productList.count > 0 {
            productCollectionView.isHidden = false
            postImageCollectionView.reloadItems(at: [IndexPath(item: pageIndex - 1, section: 0)])
            productCollectionView.reloadData()
        } else {
            productCollectionView.isHidden = true
        }
    }
    
    private func setupTextView() {
        contentTextView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentTextView.delegate = self
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
        
        productCollectionView.register(UINib(nibName: "UserPostProductCell", bundle: nil), forCellWithReuseIdentifier: UserPostProductCell.IDENTIFIER)
        
        postImageCollectionView.decelerationRate = .fast
        postImageCollectionView.isPagingEnabled = false
        //postImageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func updateCategoryCollectionView() {
        
        self.categoryCollectionView.reloadData()
    }
    
    fileprivate func applyAttributedString(_ text: String,_ length: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13)!,
            .foregroundColor: XTColor.GREY_400.getColorWithString(),
            
        ])
        
        let range = NSRange.init(location: 0, length: length)
        attributedString.addAttribute(
            .font,
            value: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13.0)!,
            range: range)
        attributedString.addAttribute(
            .foregroundColor,
            value: XTColor.GREY_900.getColorWithString(),
            range: range)
        
        return attributedString
    }
    @IBAction func openCategoryBtnPressed(_ sender: Any) {
        DispatchQueue.main.async {
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostSelectCategoryVC") as? MakePostSelectCategoryVC {
                viewcontroller.makePostUploadVC = self
                viewcontroller.modalPresentationStyle = .automatic
                viewcontroller.selectedSmallCategoryList = self.selectedCategory
                self.present(viewcontroller, animated: true)
                
            }
        }
    }
    @IBAction func openAddImageBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostAddImageVC") as? MakePostAddImageVC {
            
            viewcontroller.modalPresentationStyle = .fullScreen
            viewcontroller.selectedCategory = self.selectedCategory
            viewcontroller.makePostUploadVC = self
            
            self.present(viewcontroller, animated: true)
        }
    }
    @IBAction func uploadBtnPRessed(_ sender: Any) {
        
        var imageData :[Data] = []
        
        for image in imageList {
            imageData.append(image.jpegData(compressionQuality: 1.0)!)
        }
        
        HTTPSession.shared.uploadPost(image: imageData) { _, _ in
            
        } completion: { _, _ in
            
        }

    }
    
    @IBAction func addPostBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func tagBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostTagVC") as? MakePostTagVC {
            
            viewcontroller.postIndex = pageIndex - 1
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
            let product = MakePostManager.shared.postList[self.pageIndex - 1].productList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostProductCell.IDENTIFIER, for: indexPath) as! UserPostProductCell
            
            cell.productImageView.kf.setImage(with: URL(string: product.productImageUri ?? ""))
            cell.productImageView.layer.borderWidth = 0.0
            
            return cell
        } else if collectionView == postImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
            
            let image = self.imageList[indexPath.row]
            
            cell.postImageView.image = image
            
            if MakePostManager.shared.postList[pageIndex - 1].productList.count > 0 {
                cell.productCountView.isHidden = false
                cell.productCountLabel.text = "\(MakePostManager.shared.postList[pageIndex - 1].productList.count)"
            } else {
                cell.productCountView.isHidden = true
            }
            
            if self.imageList.count < 2 {
                cell.deleteButton.isHidden = true
            } else {
                cell.deleteButton.isHidden = false
            }
            
            cell.onDelete = {
                MakePostManager.shared.postList.remove(at: self.pageIndex - 1)
                self.imageList.remove(at: self.pageIndex - 1)
                
                self.postImageCollectionView.reloadData()
                self.postImageCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                self.pageIndex = 1
            }
            
            cell.onTag = {
                if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostTagVC") as? MakePostTagVC {
                    
                    viewcontroller.postIndex = self.pageIndex - 1
                    viewcontroller.postImage = self.imageList[self.pageIndex - 1]
                    viewcontroller.modalPresentationStyle = .fullScreen
                    
                    self.present(viewcontroller, animated: true, completion: nil)
                }
            }
            
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
            return MakePostManager.shared.postList[self.pageIndex - 1].productList.count
        } else if collectionView == postImageCollectionView {
            return imageList.count
        } else {
            return selectedCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView {
            return CGSize(width:56, height: 56)
        } else if collectionView == postImageCollectionView {
            if self.ratioType == .ratio11 {
                let width = self.view.frame.size.width - 32
                
                return CGSize(width: width, height: width)
            } else if self.ratioType == .ratio169 {
                let width = self.view.frame.size.width - 32
                
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
            return 8
        } else if collectionView == postImageCollectionView {
            if self.ratioType == .ratio11 {
                let width = self.view.frame.size.width
                
                return 16
            } else if self.ratioType == .ratio169 {
                let width = self.view.frame.size.width
                
                return 16
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
            return 8
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

extension MakePostUploadVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.postImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if self.ratioType == .ratio45 {
            let width = self.view.frame.size.width
            
            let cellWidthIncludingSpacing = self.view.frame.size.width - ( width / 10)
            
            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
            } else {
                index = Int(round(estimatedIndex))
            }
            
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
            if index  < imageList.count {
                
                self.pageIndex = index + 1
            }
            
        } else {
            let cellWidthIncludingSpacing = self.view.frame.size.width - 16
            
            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
            } else {
                index = Int(round(estimatedIndex))
            }
            
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
            if index  < imageList.count {
                
                self.pageIndex = index + 1
            }
        }
    }
    
    
}

extension MakePostUploadVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = XTColor.GREY_900.getColorWithString()
            MakePostManager.shared.postList[self.pageIndex - 1].content = ""
        } else {
            MakePostManager.shared.postList[self.pageIndex - 1].content = textView.text
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = XTColor.GREY_400.getColorWithString()
            
            MakePostManager.shared.postList[self.pageIndex - 1].content = ""
        } else {
            MakePostManager.shared.postList[self.pageIndex - 1].content = textView.text
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        MakePostManager.shared.postList[self.pageIndex - 1].content = newString
        let characterCount = newString.count
       
        return true
    }
}
