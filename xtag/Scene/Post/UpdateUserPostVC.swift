//
//  UserPostVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/15.
//

import UIKit

class UpdateUserPostVC: UIViewController {
    
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
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    public var postId = ""
    private var isReload = false
    private var pageIndex = 0
    private var contentStrings : [String] = []
    
    public var selectedCategory: [SmallCategoryModel] = []
    
    public var postDetailModel : PostDetailModel! {
        didSet {
            guard let postDetailModel = postDetailModel else { return }
            
            if let firstPostBody = postDetailModel.postBodyList.first {
                self.selectedPostBody = firstPostBody
            }
            
            for postBody in postDetailModel.postBodyList {
                self.contentStrings.append(postBody.postBodyContent ?? "")
            }
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            
        }
    }
    private var selectedPostBody : PostBodyModel? {
        didSet {
            //self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
        }
    }
    
    private var selectedProduct : ProductModel? {
        didSet {
            if selectedProduct == nil {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .none)
            } else {
                self.getProductReview(userProductId: selectedProduct!.userProductId ?? "")
            }
            
        }
    }
    
    private var selectedProductReview: ProductReviewModel? {
        didSet {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .none)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getPostDetail()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.categoryCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight: CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            
            self.tableViewTopConstraint.constant = -keyboardHeight
            self.view.layoutIfNeeded()
            
            
        }
        
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableViewTopConstraint.constant =  0
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func setupCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "UserPostTagCell", bundle: nil), forCellWithReuseIdentifier: UserPostTagCell.IDENTIFIER)
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "UserPostImageTableCell", bundle: nil), forCellReuseIdentifier: UserPostImageTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "UserPostUpdateTextViewCell", bundle: nil), forCellReuseIdentifier: UserPostUpdateTextViewCell.IDENTIFIER)
    }
    
    private func getPostDetail() {
        HTTPSession.shared.getPostDetail(postId: postId) { result, error in
            if error == nil {
                self.postDetailModel = result
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func getProductReview(userProductId: String) {
        HTTPSession.shared.getProductReview(userProductId: userProductId) { result, error in
            if error == nil {
                self.selectedProductReview = result
            }
        }
    }
    @IBAction func gotoSelectCategory(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "UserPost", bundle: nil).instantiateViewController(withIdentifier: "UpdatePostCategoryVC") as? UpdatePostCategoryVC {
            
            viewcontroller.modalPresentationStyle = .fullScreen
            viewcontroller.selectedSmallCategoryList = self.selectedCategory
            viewcontroller.updateUserPostVC = self
            
            self.present(viewcontroller, animated: true)
        }
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        MainNavigationBar.isHidden = false
        
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func moreBtnPressed(_ sender: Any) {
        var categoryIdList: [String] = []
        for category in selectedCategory {
            categoryIdList.append(category.smallCategoryId!)
        }
        
        HTTPSession.shared.updatePost(postId: self.postId, smallCategoryIdList: categoryIdList, postBodyContentList: self.contentStrings) { _, error in
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    @IBAction func gotoProfileBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC {
            viewcontroller.modalPresentationStyle = .fullScreen
            viewcontroller.userId = self.postDetailModel.userId ?? ""
            
            
            self.present(viewcontroller, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UpdateUserPostVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserPostImageTableCell.IDENTIFIER, for: indexPath) as! UserPostImageTableCell
            
            cell.postDetail = self.postDetailModel
            
            cell.imageCollectionView.reloadData()
            
            
            
            if let postDetailModel = self.postDetailModel {
                
                cell.pageControl.numberOfPages = postDetailModel.postBodyList.count
                print("cell.pageControl.numberOfPages ", cell.pageControl.numberOfPages)
            }
            
            cell.updateSelectedPostBody = { (selectedPostBody) in
                self.isReload = true
                self.selectedPostBody = selectedPostBody
                
            }
            
            cell.updateSelectedProduct = { (selectedProduct) in
                self.selectedProduct = selectedProduct
            }
            
            cell.updateInndex = { (index) in
                self.pageIndex = index
            }
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserPostUpdateTextViewCell.IDENTIFIER, for: indexPath) as! UserPostUpdateTextViewCell
            
            let placeholderString = self.placeholderTextList[self.pageIndex]
            var content = ""
            if self.contentStrings.count > self.pageIndex {
                content = self.contentStrings[self.pageIndex]
            }
            
            cell.placeholderText = placeholderString
            if content == "" {
                
                cell.textView.text = placeholderString
            } else {
                
                cell.textView.text = content
            }
            
            cell.onChange = { (text) in
                if text != placeholderString && text != "" {
                    self.contentStrings[self.pageIndex] = text
                }
                
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let width = view.frame.width
            guard let postDetailModel = postDetailModel else { return width }
            guard let ratio = postDetailModel.postImageRatio else { return width }
            let rx = CGFloat(ratio.getRatioRx())
            let ry = CGFloat(ratio.getRatioRy())
            
            var height = width / rx * ry
            
            if rx == 0 || ry == 0 {
                height = width
            }
            
            guard let selectedPostBody = selectedPostBody else { return height }
            
            if selectedPostBody.postBodyProductList.count > 0 {
                return height + 93
            } else {
                return height + 15
            }
        }
        
        
        return 242
    }
}

extension UpdateUserPostVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
            
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}


extension UpdateUserPostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
            
            let category = selectedCategory[indexPath.row]
            
            cell.tagButton.setTitle(category.smallCategoryName ?? "", for: [])
            cell.tagButton.isUserInteractionEnabled = false
            cell.setButtonState(isSelected: true)
            cell.layer.cornerRadius = 16
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
            return selectedCategory.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
            let category = selectedCategory[indexPath.row]
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 24, height: 32)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 16
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

            return 16
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}
