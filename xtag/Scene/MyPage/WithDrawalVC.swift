//
//  WithDrawalVC.swift
//  xtag
//
//  Created by Yoon on 2022/08/05.
//

import UIKit

class WithDrawalVC: UIViewController {
    @IBOutlet weak var navigationBar: XTNavigationBar!
    @IBOutlet weak var chevronImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var reasonButton: UIButton!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    private var reason = "" {
        didSet {
            if reason == "" {
                nextButton.setTitleColor(XTColor.GREY_500.getColorWithString(), for: [])
                nextButton.backgroundColor = XTColor.GREY_100.getColorWithString()
                reasonButton.setTitle(reason, for: [])
            } else {
                nextButton.setTitleColor(.white, for: [])
                nextButton.backgroundColor = XTColor.GREY_900.getColorWithString()
                reasonButton.setTitle("선택해 주세요.", for: [])
            }
        }
    }
    
    private var reasonList : [String] = ["앱 오류가 있어요.", "사용빈도가 낮아요.", "서비스가 불만이에요.", "콘텐츠가 불만이에요.", "앱이 불편해요.", "개인 정보 유출이 우려돼요."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WithDrawalReasonCell", bundle: nil), forCellReuseIdentifier: WithDrawalReasonCell.IDENTIFIER)
    }
    
    private func setupNavigationBar() {
        navigationBar.delegate = self
    }
    @IBAction func reasonBtnPressed(_ sender: Any) {
        reasonButton.isSelected = !reasonButton.isSelected
        
        if reasonButton.isSelected {
            chevronImageView.image = UIImage(named: "reason_chevron-up")
            tableViewHeight.constant = 300
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutSubviews()
            }
        } else {
            chevronImageView.image = UIImage(named: "reason_chevron-down")
            
            tableViewHeight.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutSubviews()
            }
        }
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if reason != "" {
            if let viewcontroller = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "WithDrawalInfoVC") as? WithDrawalInfoVC {
                viewcontroller.modalPresentationStyle = .fullScreen
                viewcontroller.content = self.reason
                
                self.present(viewcontroller, animated: true)
            }
        }
    }
}

extension WithDrawalVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onMore() {
        
    }
    
    
}

extension WithDrawalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WithDrawalReasonCell.IDENTIFIER, for: indexPath) as! WithDrawalReasonCell
        
        let reason = reasonList[indexPath.row]
        cell.titleLabel.text = reason
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reason = reasonList[indexPath.row]
        
        self.reason = reason
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
