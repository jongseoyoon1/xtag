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
    
}
