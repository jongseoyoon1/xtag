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
    
    public let PRODUCT_BOTTOM_CONSTANT: CGFloat = 136
    public let POST_BOTTOM_CONSTANT:CGFloat = 72
    
    @IBOutlet weak var productBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var postBottomConstraint: NSLayoutConstraint!
    private var viewControllers: Array<UIViewController> = []

    @IBOutlet weak var bottomBar: XTBottomBar!
    
    @IBOutlet weak var backgroundView: UIView!
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainVC
        let myPageVC = UIStoryboard.init(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageVC") as! UINavigationController
        
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
        
        let bottomPublisher = NavigationManager.shared.$activeBottomBar
        bottomPublisher.sink { value in
            DispatchQueue.main.async {
                if value {
                    self.backgroundView.isHidden = !value
                }
                
                
                if value {
                    self.postBottomConstraint.constant = self.POST_BOTTOM_CONSTANT
                    self.productBottomConstraint.constant = self.PRODUCT_BOTTOM_CONSTANT
                } else {
                    self.postBottomConstraint.constant = 0
                    self.productBottomConstraint.constant = 0
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: []) {
                    self.backgroundView.layoutIfNeeded()
                } completion: { _ in
                    if !value {
                        self.backgroundView.isHidden = !value
                    }
                }

            }
        }
        .store(in: &subscriptions)
    }
    
    @IBAction func productBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeProductLinkVC") as? MakeProductLinkVC {
            
            viewcontroller.modalPresentationStyle = .fullScreen
            self.present(viewcontroller, animated: true)
        }
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostVC") as? MakePostVC {
            
            viewcontroller.modalPresentationStyle = .fullScreen
            self.present(viewcontroller, animated: true)
        }
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

