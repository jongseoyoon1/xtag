//
//  FollowingProductContainerVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/27.
//

import UIKit
import Combine

class FollowingProductContainerVC: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    private var followingProductVC: FollowingProductVC!
    private var follwoingCollectionVC: FollwoingCollectionVC!

    
    private var subscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        followingProductVC = children.first! as! FollowingProductVC
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 22
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        follwoingCollectionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollwoingCollectionVC") as! FollwoingCollectionVC
        //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryCollectionVC") as! CategoryCollectionVC
        
        
        
        let publisher = CategoryManager.shared.$isOpen
        
        publisher
            .sink { _ in
                
            } receiveValue: { [self] value in
                print("isOpen2 = \(value)")
                if value {
                    if (children.first! is FollowingProductVC) {
                        cycle(from: followingProductVC, to: follwoingCollectionVC)
                        CategoryManager.shared.bottomBarIsOpen = false
                    }
                    
                } else {
                    if (children.first! is FollwoingCollectionVC) {
                        cycle(from: follwoingCollectionVC, to: followingProductVC)
                        CategoryManager.shared.bottomBarIsOpen = true
                        //CategoryManager.shared.mainSelectedSmallCategory = nil
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func cycle(from oldVC: UIViewController, to newVC: UIViewController) {
        oldVC.willMove(toParent: nil)
        addChild(newVC)
        
        newVC.view.frame = containerView.bounds
        
        transition(from: oldVC, to: newVC, duration: 0.0, options: .transitionCrossDissolve, animations: {
        }, completion: { finished in
            
            oldVC.removeFromParent()
            newVC.didMove(toParent: self)

        })
    }
    
    func display(_ child: UIViewController) {
        addChild(child)
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
}
