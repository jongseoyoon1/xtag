//
//  UserPostVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/15.
//

import UIKit

class UserPostVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    public var postId = ""
    private var isReload = false
    
    public var postDetailModel : PostDetailModel! {
        didSet {
            guard let postDetailModel = postDetailModel else { return }
            
            nameLabel.text = postDetailModel.userName ?? ""
            profileImageView.kf.setImage(with: URL(string: postDetailModel.userCdnImageUri ?? ""), placeholder: UIImage(named: "profile_image"))
            
            if let firstPostBody = postDetailModel.postBodyList.first {
                self.selectedPostBody = firstPostBody
            }
        }
    }
    private var selectedPostBody : PostBodyModel? {
        didSet {
            //self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
            self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
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
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "UserPostBottomTableCell", bundle: nil), forCellReuseIdentifier: UserPostBottomTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "UserPostImageTableCell", bundle: nil), forCellReuseIdentifier: UserPostImageTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "UserPostProductTitleTableCell", bundle: nil), forCellReuseIdentifier: UserPostProductTitleTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "ProductEvaluationResultTableCell", bundle: nil), forCellReuseIdentifier: ProductEvaluationResultTableCell.IDENTIFIER)
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
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        MainNavigationBar.isHidden = false
    }
    
    @IBAction func moreBtnPressed(_ sender: Any) {
        
        if self.postDetailModel.userId! == UserManager.shared.userInfo!.userId! {
            var actions : [XTBottomSheetAction] = []
            actions.append(XTBottomSheetAction(title: "삭제", type: .ALERT, handler: {
                self.showCommonPopup(title: "게시물 삭제", content: "게시물을 삭제하시겠습니까?", confirmButtonTitle: "삭제", popupType: .ALERT) {
                    
                }
            }))
            
            actions.append(XTBottomSheetAction(title: "수정", type: .COMMON, handler: {
              
            }))
            
            showCommonBottomSheet(actions: actions) {
                
            }
        } else {
            var actions : [XTBottomSheetAction] = []
            actions.append(XTBottomSheetAction(title: "신고", type: .ALERT, handler: {
                print("신고")
                
                self.showCommonPopup(title: "게시물 신고", content: "게시물을 신고하시겠습니까?", confirmButtonTitle: "신고", popupType: .ALERT) {
                    
                }
            }))
            
            showCommonBottomSheet(actions: actions) {
                
            }
        }
        
        
        
    }
    @IBAction func gotoProfileBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC {
            viewcontroller.modalPresentationStyle = .fullScreen
            viewcontroller.userId = self.postDetailModel.userId ?? ""
            
            
            self.present(viewcontroller, animated: true)
        }
    }
}

extension UserPostVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserPostProductTitleTableCell.IDENTIFIER, for: indexPath) as! UserPostProductTitleTableCell
            
            if let selectedProduct = self.selectedProduct {
                cell.titleLabel.text = selectedProduct.productTitle ?? ""
                
                
                
                cell.onLink = {
                    if let viewcontroller = UIStoryboard(name: "ProductDetail", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
                        viewcontroller.modalPresentationStyle = .fullScreen
                        
                        if let selectedProduct = self.selectedProduct {
                            viewcontroller.product = selectedProduct
                        }
                        
                        if let selectedProductReview = self.selectedProductReview {
                            viewcontroller.productReview = selectedProductReview
                        }
                        
                        if let postDetailModel = self.postDetailModel {
                            viewcontroller.postDetailModel = postDetailModel
                            
                        }
                        
                        if let postBodyModel = self.selectedPostBody {
                            viewcontroller.PostBodyModel = postBodyModel
                        }
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                        //self.present(viewcontroller, animated: true, completion: nil)
                    }
                }
            }
            
            return cell
        }
        
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductEvaluationResultTableCell.IDENTIFIER, for: indexPath) as! ProductEvaluationResultTableCell
            
            if let selectedProductReview = self.selectedProductReview {
                cell.evaluationLabel.text = selectedProductReview.content ?? ""
                
                let satisfied = selectedProductReview.satisfied!
                print("stisfied = \(satisfied)")
                
                if satisfied == "GOOD" {
                    cell.evaluationImageVIew.image = UIImage(named: "rating_liked-1")
                } else if satisfied == "NONE" {
                    cell.evaluationImageVIew.image = UIImage(named: "rating_difficult to answer-1")
                } else {
                    cell.evaluationImageVIew.image = UIImage(named: "rating_not liked-1")
                }
            }
            
            if let postDetailModel = self.postDetailModel {
                cell.smallCategoryList = postDetailModel.postCategoryList
                cell.tagCollectionView.reloadData()
            }
            
            
            
            return cell
        }
        
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserPostBottomTableCell.IDENTIFIER, for: indexPath) as! UserPostBottomTableCell
            
            if let postBody = self.selectedPostBody {
                cell.titleLabel.text = postBody.postBodyContent ?? ""
            }
            if let postDetailModel = self.postDetailModel {
                cell.likeCountLabel.text = postDetailModel.likes ?? ""
                cell.commentCountLabel.text = postDetailModel.comments ?? ""
                cell.timeLabel.text = postDetailModel.postRegisterDate ?? ""
                
                cell.smallCategoryList = postDetailModel.postCategoryList
                cell.tagCollectionView.reloadData()
                
                cell.postId = postDetailModel.postId ?? ""
                
                if postDetailModel.isLiked! == "false" {
                    cell.likeButton.isSelected = false
                    cell.likeImageView.image = UIImage(named: "thumbs_up")
                } else {
                    cell.likeButton.isSelected = true
                    cell.likeImageView.image = UIImage(named: "thumbs_up_fill")
                }
            }
            
            cell.onComment = {
                if let viewcontroller = UIStoryboard(name: "Comment", bundle: nil).instantiateViewController(withIdentifier: "CommentVC") as? CommentVC {
                    
                    viewcontroller.modalPresentationStyle = .fullScreen
                    viewcontroller.postDetailModel = self.postDetailModel
                    
                    self.present(viewcontroller, animated: true)
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
        
        if indexPath.row == 1 {
            if selectedProduct == nil {
                return 0
            } else {
                guard let title = selectedProduct?.productTitle else { return 128 }
                let height = title.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)!)
                
                return 118 + height
            }
            
        }
        
        if indexPath.row == 2 {
            if selectedProduct == nil {
                return 0
            } else {
                return UITableView.automaticDimension
            }
            
        }
        
        if indexPath.row == 3 {
            return 214
        }
        
        return 1000
    }
}
