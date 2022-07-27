//
//  AllProductContainerVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/23.
//

import UIKit
import Combine

class AllProductContainerVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    private var allProductVC: AllProductVC!
    private var categoryCollectionVC : CategoryCollectionVC!
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        allProductVC = children.first! as! AllProductVC
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 22
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        categoryCollectionVC = CategoryCollectionVC(collectionViewLayout: layout)
        categoryCollectionVC.CELL_WIDTH = (self.view.frame.size.width - 32 - 44) / 3 - 1
        //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryCollectionVC") as! CategoryCollectionVC
        
        
        
        let publisher = CategoryManager.shared.$isOpen
        
        publisher
            .sink { _ in
                
            } receiveValue: { [self] value in
                print("isOpen = \(value)")
                if value {
                    if (children.first! is AllProductVC) {
                        cycle(from: allProductVC, to: categoryCollectionVC)
                        CategoryManager.shared.bottomBarIsOpen = false
                    }
                    
                } else {
                    if (children.first! is CategoryCollectionVC) {
                        cycle(from: categoryCollectionVC, to: allProductVC)
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
            print("transition complete")
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
