//
//  ProductDetailVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/15.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    public var product : ProductModel!
    public var productReview: ProductReviewModel!
    public var postDetailModel: PostDetailModel!
    public var PostBodyModel : PostBodyModel!
    public var myPage: MyPageVC?
    public var postList : [PostModel] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var openButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateOpenButtonState()
        setupTableView()
        
        getProductWithTag()
        getProductDetail()
        
        setupUI()
    }
    
    private func getProductDetail() {
        HTTPSession.shared.getProductDetail(userProductId: product.userProductId!) { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }
                self.product.smallCategoryList = result.smallCategoryList
                self.product.userProductStatus = result.userProductStatus
                self.nameLabel.text = UserManager.shared.userInfo?.name
                self.profileImageView.kf.setImage(with: URL(string: UserManager.shared.userInfo?.cdnImageUri ?? (UserManager.shared.userInfo?.s3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func updateOpenButtonState() {
        
        if let status = product.userProductStatus {
            if status == "ACTIVE" {
                openButton.setTitle("비공개로 전환", for: [])
            } else {
                openButton.setTitle("공개로 전환", for: [])
            }
        }
    }
    
    private func setupUI() {
        guard let postDetailModel = postDetailModel else { return }
        
        nameLabel.text = postDetailModel.userName ?? ""
        profileImageView.kf.setImage(with: URL(string: postDetailModel.userCdnImageUri ?? ""))
    }
    
    private func getProductWithTag() {
        HTTPSession.shared.getProductWithTag(userProductId: product.userProductId ?? "") { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }

                self.postList = result
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProductLinkTableCell", bundle: nil), forCellReuseIdentifier: ProductLinkTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "ProductEvaluationResultTableCell", bundle: nil), forCellReuseIdentifier: ProductEvaluationResultTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "ProductTagProductsCell", bundle: nil), forCellReuseIdentifier: ProductTagProductsCell.IDENTIFIER)
    }

    @IBAction func dismissBtnPressed(_ sender: Any) {
        //self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
        
        if self.navigationController == nil {
            self.dismiss(animated: true)
        }
    }
    @IBAction func openBtnPressed(_ sender: Any) {
        if product.userProductStatus! == "ACTIVE" {
            
            showCommonPopup(title: "비공개 상품으로 전환", content: "이 상품이 다른 사용자들에게 보이지 않으며, 다시 공개로 전환할 수 있습니다.", confirmButtonTitle: "전환", popupType: .COMMON) {
                HTTPSession.shared.updateProductStatus(userProductId: self.product.userProductId!) { _, error in
                    if error == nil {
                        self.view.makeToast("비공개 상품으로 전환 되었습니다.", duration: 0.5, position: .center)
                    }
                }
            }
            product.userProductStatus = "DEACTIVE"
            updateOpenButtonState()
        } else {
            showCommonPopup(title: "공개 상품으로 전환", content: "이 상품이 다른 사용자들에게 보여지며, 다시 비공개로 전환할 수 있습니다.", confirmButtonTitle: "전환", popupType: .COMMON) {
                HTTPSession.shared.updateProductStatus(userProductId: self.product.userProductId!) { _, error in
                    if error == nil {
                        self.view.makeToast("공개 상품으로 전환 되었습니다.", duration: 0.5, position: .center)
                    }
                }
            }
            product.userProductStatus = "ACTIVE"
            updateOpenButtonState()
        }
    }
    @IBAction func deleteBtnPressed(_ sender: Any) {
        
        showCommonPopup(title: "상품 삭제", content: "게시물과 프로필에서 이 상품이 영구적으로 삭제됩니다.", confirmButtonTitle: "삭제", popupType: .ALERT) {
            HTTPSession.shared.deleteProduct(userProductId: self.product.userProductId!) { _, error in
                if error == nil {
                    self.dismiss(animated: false) {
                        
                        if let myPage = self.myPage {
                            
                            myPage.view.makeToast("상품이 삭제되었습니다.", duration: 0.5, position: .center)
                        }
                    }
                    
                }
            }
        }
    }
}

extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductLinkTableCell.IDENTIFIER, for: indexPath) as! ProductLinkTableCell
            
            cell.setupCell(link: product.productLink ?? "",
                           imageUrl: product.productImageUri ?? "",
                           productName: product.productTitle ?? "")
            
            cell.textViewContainer.isHidden = true
            cell.textView.isHidden = true
            cell.linkButton.isHidden = false
            cell.confirmButton.isHidden = true
            
            cell.onLink = { [self] in
                if let url = URL(string: product.productLink ?? "") {
                    UIApplication.shared.open(url, options: [:])
                    
                } 
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductEvaluationResultTableCell.IDENTIFIER, for: indexPath) as! ProductEvaluationResultTableCell
            
            if let selectedProductReview = self.productReview {
                cell.evaluationLabel.text = selectedProductReview.content ?? ""
                
                let satisfied = selectedProductReview.satisfied!
                if satisfied == "GOOD" {
                    cell.evaluationImageVIew.image = UIImage(named: "rating_liked-1")
                } else if satisfied == "NONE" {
                    cell.evaluationImageVIew.image = UIImage(named: "rating_difficult to answer-1")
                } else {
                    cell.evaluationImageVIew.image = UIImage(named: "rating_not liked-1")
                }
            }
            
            cell.smallCategoryList = self.product.smallCategoryList
            cell.tagCollectionView.reloadData()
            
            
            
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductTagProductsCell.IDENTIFIER, for: indexPath) as! ProductTagProductsCell
            
            cell.productDetailVC = self
            cell.postList = self.postList
            cell.productCountLabel.text = "\(self.postList.count) 개"
            cell.collectionView.reloadData()
            
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            let width = view.frame.width - 40
            guard let title = product.productTitle else { return 128 }
            let height = title.height(withConstrainedWidth: width, font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)!)
            
            return 16 + width + height + 100
        }
        
        if indexPath.section == 2 {
            if self.postList.count == 0 {
                return 0
            } else {
                return 500
            }
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = XTColor.GREY_200.getColorWithString()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 24
        }
        
        return 0
    }
    
    
}
