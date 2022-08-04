//
//  FollwoingCollectionVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/27.
//

import UIKit
import Combine

class FollwoingCollectionVC: UIViewController {
    
    public var smallCategoryList: [SmallCategoryModel] = []
    
    private var selectedSmallCategory: SmallCategoryModel? {
        didSet {
            //self.collectionView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private var subscriptions = Set<AnyCancellable>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
        setupTableView()
    }
    

    private func setupCollectionView() {
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        
    }
    
    private func setupUI() {
        
    }
    
    private func setupTableView() {
        
    }

}
