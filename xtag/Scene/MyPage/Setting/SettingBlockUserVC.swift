//
//  SettingBlockUserVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/31.
//

import UIKit

class SettingBlockUserVC: UIViewController {
    
    @IBOutlet weak var navigationBar: XTNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var page = "0"
    private var size = "20"
    
    private var blockUserList : [BlockUserModel] = []

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
        
        tableView.register(UINib(nibName: "SettingBlockUserCell", bundle: nil), forCellReuseIdentifier: "SettingBlockUserCell")
    }
    
    private func getBlockUser() {
        HTTPSession.shared.getBlockUser(page: "0",
                                        size: "20") { result, pagenation, error in
            if error == nil {
                self.blockUserList = result ?? []
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - XTNavigationDelegate
extension SettingBlockUserVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func onMore() {
        
    }
    
    
}

extension SettingBlockUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingBlockUserCell", for: indexPath) as! SettingBlockUserCell
        let user = blockUserList[indexPath.row]
        
        cell.profileImageView.kf.setImage(with: URL(string: user.userCdnImageUri ?? (user.userS3ImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
        cell.nameLabel.text = user.userName
        
        cell.onBlock = {
            HTTPSession.shared.deleteBlockUser(userId: user.userId ?? "") { result, error in
                if error == nil {
                    self.blockUserList.remove(at: self.blockUserList.firstIndex(where: { $0.userId! == user.userId! })!)
                    self.tableView.reloadData()
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.blockUserList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
}
