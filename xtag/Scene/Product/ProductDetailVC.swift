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
    
    public var postList : [PostModel] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        getProductWithTag()
        setupUI()
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
            
            if let postDetailModel = self.postDetailModel {
                cell.smallCategoryList = postDetailModel.postCategoryList
                cell.tagCollectionView.reloadData()
            }
            
            
            
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
