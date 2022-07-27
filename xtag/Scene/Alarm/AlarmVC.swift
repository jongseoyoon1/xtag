//
//  AlarmVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/22.
//

import UIKit

class AlarmVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todayNotificationList: [NotificationModel] = []
    var pastNotificationList: [NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAlarm()
    }
    
    private func getAlarm() {
        HTTPSession.shared.getNotification(status: "today") { todayResult, error in
            if error == nil {
                self.todayNotificationList = todayResult ?? []
                
                HTTPSession.shared.getNotification(status: "last") { lastResult, error in
                    if error == nil {
                        self.pastNotificationList = lastResult ?? []
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
        
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
      
        
        return 2
    }
}
