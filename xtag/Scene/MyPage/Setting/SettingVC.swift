//
//  SettingVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var navigationBar: XTNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var pushCellCount = 1
    
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
    
    private func alarmCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
            cell.titleLabel.text = "알림 설정"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPushCell") as! SettingPushCell
            cell.titleLabel.text = "푸시알림"
            cell.titleLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPushCell") as! SettingPushCell
            cell.titleLabel.text = "  좋아요"
            cell.titleLabel.textColor = XTColor.GREY_500.getColorWithString()
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPushCell") as! SettingPushCell
            cell.titleLabel.text = "  댓글"
            cell.titleLabel.textColor = XTColor.GREY_500.getColorWithString()
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPushCell") as! SettingPushCell
            cell.titleLabel.text = "  새 팔로워"
            cell.titleLabel.textColor = XTColor.GREY_500.getColorWithString()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func settingCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
            cell.titleLabel.text = "사용자 설정"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.chevronImage.isHidden = true
            cell.emailLabel.isHidden = false
            cell.typeImage.isHidden = false
            
            cell.titleLabel.text = "로그인 정보"
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.chevronImage.isHidden = false
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            
            cell.titleLabel.text = "차단한 사용자"
            cell.titleLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func etcCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! SettingHeaderCell
            cell.titleLabel.text = "기타"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = false
            cell.chevronImage.isHidden = false
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            
            cell.titleLabel.text = "버전 정보"
            cell.titleLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.chevronImage.isHidden = false
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            
            cell.titleLabel.text = "서비스 이용약관"
            cell.titleLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.chevronImage.isHidden = false
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            
            cell.titleLabel.text = "문의하기"
            cell.titleLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.chevronImage.isHidden = false
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            
            cell.titleLabel.text = "로그아웃"
            cell.titleLabel.textColor = XTColor.GREY_900.getColorWithString()
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingContentCell") as! SettingContentCell
            
            cell.versionLabel.isHidden = true
            cell.chevronImage.isHidden = false
            cell.emailLabel.isHidden = true
            cell.typeImage.isHidden = true
            
            cell.titleLabel.text = "서비스 탈퇴"
            cell.titleLabel.textColor = XTColor.GREY_500.getColorWithString()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - XTNavigationDelegate
extension SettingVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func onMore() {
        
    }
    
    
}

// MARK: - TableViewDelegate, TableViewDatasource
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pushCellCount + 1
        case 1:
            return 3
        case 2:
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return alarmCell(tableView, indexPath)
        case 1:
            return settingCell(tableView, indexPath)
        case 2:
            return etcCell(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
