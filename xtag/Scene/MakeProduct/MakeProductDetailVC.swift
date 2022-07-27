//
//  MakeProductDetailVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/11.
//

import UIKit

class MakeProductDetailVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var isLinkOpen = false
    private var evaluateState: EvaluateState?
    
    private var selectedSmallCategoryList : [SmallCategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.evaluateState != nil {
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProductLinkTableCell", bundle: nil), forCellReuseIdentifier: ProductLinkTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "ProductEvaluationTableCell", bundle: nil), forCellReuseIdentifier: ProductEvaluationTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "ProductMemoTableCell", bundle: nil), forCellReuseIdentifier: ProductMemoTableCell.IDENTIFIER)
        tableView.register(UINib(nibName: "ProductCategoryCell", bundle: nil), forCellReuseIdentifier: ProductCategoryCell.IDENTIFIER)
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func completeBtnPressed(_ sender: Any) {
        var smallCategoryList : [String] = []
        
        for category in selectedSmallCategoryList {
            smallCategoryList.append(category.smallCategoryId!)
        }
        var satisfied = ""
        if let evaluateState = evaluateState {
            if evaluateState == .DIFFICULT {
                satisfied = "NORMAL"
            } else if evaluateState == .LIKED {
                satisfied = "GOOD"
            } else {
                satisfied = "BAD"
            }
        }
        
        var content = ""
        if let memo = MakeProductManager.shared.productInfo?.memo {
            if memo == "작성하기" {
                
            } else {
                content = memo
            }
        }
        
        HTTPSession.shared.makeProduct(title: MakeProductManager.shared.productInfo?.title ?? "",
                                       imageUri: MakeProductManager.shared.productInfo?.imageUri ?? "",
                                       link: MakeProductManager.shared.productInfo?.link ?? "",
                                       satisfied: satisfied,
                                       smallCategoryList: smallCategoryList,
                                       type: "MEMO",
                                       content: content) { result, error in
            if error == nil {
                self.dismiss(animated: true)
            }
        }
    }
}

extension MakeProductDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.evaluateState != nil {
            return 4
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductLinkTableCell.IDENTIFIER, for: indexPath) as! ProductLinkTableCell
            
            cell.setupCell(link: MakeProductManager.shared.productInfo?.link ?? "",
                           imageUrl: MakeProductManager.shared.productInfo?.imageUri ?? "",
                           productName: MakeProductManager.shared.productInfo?.title ?? "")
            
            cell.textViewContainer.isHidden = !self.isLinkOpen
            cell.textView.isHidden = !self.isLinkOpen
            cell.linkButton.isHidden = !self.isLinkOpen
            cell.confirmButton.isHidden = !self.isLinkOpen
            
            cell.updateLayout = { (isOpen) in
                
                self.isLinkOpen = isOpen
                cell.textViewContainer.isHidden = !self.isLinkOpen
                cell.textView.isHidden = !self.isLinkOpen
                cell.linkButton.isHidden = !self.isLinkOpen
                cell.confirmButton.isHidden = !self.isLinkOpen
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductEvaluationTableCell.IDENTIFIER, for: indexPath) as! ProductEvaluationTableCell
            
            cell.selectEvaluation = { (state) in
                if self.evaluateState == nil {
                    self.evaluateState = state
                    self.tableView.reloadData()
                } else {
                    self.evaluateState = state
                }
                
                
                MakeProductManager.shared.productEvaluateState = state
            }
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductMemoTableCell.IDENTIFIER, for: indexPath) as! ProductMemoTableCell
            
            if let memo = MakeProductManager.shared.productInfo?.memo {
                cell.contentLabel.text = memo
                
                if memo == "작성하기" {
                    cell.contentLabel.textColor = XTColor.GREY_400.getColorWithString()
                } else {
                    cell.contentLabel.textColor = XTColor.GREY_900.getColorWithString()
                }
            }
            
            
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCategoryCell.IDENTIFIER, for: indexPath) as! ProductCategoryCell
            
            cell.updateSelectedSmallCategoryList = { (selectedSmallCategoryList) in
                self.selectedSmallCategoryList = selectedSmallCategoryList
                
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let width = view.frame.width - 40
            if isLinkOpen {
                
                return 269 + width
            } else {
                return 219 + width
            }
        } else if indexPath.row == 1 {
            return 152
        } else if indexPath.row == 2 {
            return 312
        } else if indexPath.row == 3 {
            return 176
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeProductMemoVC") as? MakeProductMemoVC {
                viewcontroller.modalPresentationStyle = .fullScreen
                
                self.present(viewcontroller, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
}
