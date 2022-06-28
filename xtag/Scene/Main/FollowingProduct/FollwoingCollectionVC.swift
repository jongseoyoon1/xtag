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
            self.collectionView.reloadData()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public var CELL_WIDTH: CGFloat = 0
    
    private lazy var collectionView : UICollectionView = {
        let cv = UICollectionView()
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SmallCategoryCell.self, forCellWithReuseIdentifier: SmallCategoryCell.IDENTIFIER)
        
        return cv
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    private var collectionViewHeight : NSLayoutConstraint!
    
    private lazy var followingLabel: UILabel = {
        let lb = UILabel()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 18)
        lb.textColor = .white
        
        return lb
    }()
    
    private lazy var moreBUtton: UIButton = {
        let btn = UIButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
        btn.titleLabel?.textColor = XTColor.GREY_400.getColorWithString()
        btn.setTitle("더보기", for: [])
        btn.setImage(UIImage(named: ""), for: [])
        
        return btn
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
        setupTableView()
    }
    

    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 0)
        
    }
    
    private func setupUI() {
        
    }
    
    private func setupTableView() {
        
    }

}
