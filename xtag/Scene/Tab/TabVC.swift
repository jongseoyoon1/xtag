//
//  TabVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/09.
//

import UIKit
import Tabman
import Pageboy
import Combine

class TabVC: TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []

    @IBOutlet weak var bottomBar: XTBottomBar!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainVC
        let myPageVC = UIStoryboard.init(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageVC") as! MyPageVC
        
        viewControllers.append(mainVC)
        viewControllers.append(myPageVC)
        
        self.dataSource = self
        self.isScrollEnabled = false
        
        bottomBar.delegate = self
        
        setupPublisher()
    }
    
    private func setupPublisher() {
        let publisher = CategoryManager.shared.$bottomBarIsOpen
        publisher.sink { value in
            DispatchQueue.main.async {
                self.bottomBar.isHidden = !value
                
            }
            
        }
        .store(in: &subscriptions)
    }
    

}

extension TabVC: XTBottomBarDelegate {
    func onPlus() {
        
    }
    
    func onMain() {
        DispatchQueue.main.async {
            self.scrollToPage(.at(index: 0), animated: false)
            
            self.bottomBar.mainButton.isSelected = true
            self.bottomBar.myPageButton.isSelected = false
        }
    }
    
    func onMyPage() {
        DispatchQueue.main.async {
            self.scrollToPage(.at(index: 1), animated: false)
            
            self.bottomBar.mainButton.isSelected = false
            self.bottomBar.myPageButton.isSelected = true
        }
    }
    
    
}

extension TabVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    
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

