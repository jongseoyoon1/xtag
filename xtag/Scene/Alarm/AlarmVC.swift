//
//  AlarmVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/22.
//

import UIKit

class AlarmVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    var todayNotificationList: [NotificationModel] = []
    var pastNotificationList: [NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        getAlarm()
    }
    
    private func getAlarm() {
        HTTPSession.shared.getNotification(status: "today") { todayResult, error in
            if error == nil {
                self.todayNotificationList = todayResult ?? []
                
                HTTPSession.shared.getNotification(status: "last") { lastResult, error in
                    if error == nil {
                        self.pastNotificationList = lastResult ?? []
                        
                        if self.todayNotificationList.count != 0 ||
                            self.pastNotificationList.count != 0 {
                            self.emptyLabel.isHidden = true
                        } else {
                            self.emptyLabel.isHidden = false
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: "AlarmCell")
    }
    

    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension AlarmVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if todayNotificationList.count == 0 {
                return pastNotificationList.count
            } else {
                return todayNotificationList.count
            }
        } else {
            return pastNotificationList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        var noti: NotificationModel!
        
        if indexPath.section == 0 {
            if todayNotificationList.count == 0 {
                noti = pastNotificationList[indexPath.row]
            } else {
                noti = todayNotificationList[indexPath.row]
            }
            
            
        } else {
            noti = pastNotificationList[indexPath.row]
        }
        
        cell.profileImageView.kf.setImage(with: URL(string: noti.sender?.userS3ImageUri ?? (noti.sender?.userCdnImageUri ?? "")), placeholder: UIImage(named: "profile_image"))
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if todayNotificationList.count == 0 && pastNotificationList.count == 0 {
            return 0
        } else if todayNotificationList.count > 0 && pastNotificationList.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = .white
        let label = UILabel()
        label.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 16)
        label.textColor = XTColor.GREY_900.getColorWithString()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if section == 0 {
            if todayNotificationList.count != 0 {
                label.text = "오늘"
            } else {
                label.text = "지난 알림"
            }
        } else {
            label.text = "지난 알림"
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = .white
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        imageView.image = UIImage(named: "dot_line_gray")
        imageView.contentMode = .scaleAspectFill
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
            return 0
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
