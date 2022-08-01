//
//  SettingServiceTermVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/31.
//

import UIKit

class SettingServiceTermVC: UIViewController {
    
    @IBOutlet weak var navigationBar: XTNavigationBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationBar.delegate = self
        navigationBar.backButton.setImage(UIImage(named: "chevron-left-back"), for: [])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingHeaderCell", bundle: nil), forCellReuseIdentifier: "SettingHeaderCell")
        tableView.register(UINib(nibName: "SettingPushCell", bundle: nil), forCellReuseIdentifier: "SettingPushCell")
        tableView.register(UINib(nibName: "SettingContentCell", bundle: nil), forCellReuseIdentifier: "SettingContentCell")
    }
    
    private func termCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
            cell.titleLabel.text = "공통"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            cell.chevronImage.isHidden = true
            
            cell.titleLabel.text = "서비스 이용약관"
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            cell.chevronImage.isHidden = true
            
            cell.titleLabel.text = "개인정보 처리방침"
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

// MARK: - XTNavigationDelegate
extension SettingServiceTermVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func onMore() {
        
    }
    
    
}

// MARK: - TableViewDelegate, TableViewDatasource
extension SettingServiceTermVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
       
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return termCell(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                let appURL = URL(string: "https://docs.xtag.info/xtag-privacy-policy_ko.html")!

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else if indexPath.row == 2 {
                let appURL = URL(string: "https://docs.xtag.info/xtag-terms-of-use_ko.html")!

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
                
                
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
