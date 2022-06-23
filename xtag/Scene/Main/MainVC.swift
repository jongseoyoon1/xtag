//
//  MainVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/06.
//

import UIKit
import Tabman
import Pageboy

class MainVC: TabmanViewController {
    
    @IBOutlet weak var mainNavigationBar: XTMainNavigationBar!
    private var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let allProductVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllProductVC") as! UINavigationController
        let myProductVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProductVC") as! MyProductVC
        let followingProductVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowingProductVC") as! FollowingProductVC
        
        viewControllers.append(allProductVC)
        viewControllers.append(myProductVC)
        viewControllers.append(followingProductVC)
        
        
        self.dataSource = self
        setupNav()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    private func setupNav() {
        self.navigationController?.navigationBar.isHidden = true
        
        mainNavigationBar.onAllProductButton = {
            DispatchQueue.main.async {
                self.scrollToPage(.at(index: 0), animated: false)
            }
            
        }
        
        mainNavigationBar.onMyProductButton = {
            DispatchQueue.main.async {
                self.scrollToPage(.at(index: 1), animated: false)
            }
        }
        
        mainNavigationBar.onFollowingProductButton = {
            DispatchQueue.main.async {
                self.scrollToPage(.at(index: 2), animated: false)
            }
        }
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
        if index == 0 {
            self.mainNavigationBar.state = .ALL
        } else if index == 1 {
            self.mainNavigationBar.state = .MY
        } else {
            self.mainNavigationBar.state = .FOLLOWING
        }
    }
}

extension MainVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = "Page \(index)"
        item.image = UIImage(named: "image.png")
        
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
