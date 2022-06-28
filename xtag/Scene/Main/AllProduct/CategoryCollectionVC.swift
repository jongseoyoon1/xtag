//
//  CategoryCollectionVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/20.
//

import UIKit
import Combine

private let reuseIdentifier = "Cell"

class CategoryCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public var largeCategoryList: [LargeCategoryModel] = []
    public var smallCategoryList: [SmallCategoryModel] = []
    public var selectedCategoryList: [String] = []
    
    lazy var applyButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        
        return btn
    }()
    
    public var CELL_WIDTH : CGFloat = 0.0
    
    private var selectedSmallCategory: SmallCategoryModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var selectedLargeCatgoryIndex = 0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var selectedSmallCategoryCount = 0
    
    var isLargeCategorySelected: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = XTColor.GREY_900.getColorWithString()
        collectionView.backgroundColor = XTColor.GREY_900.getColorWithString()
        
        self.collectionView!.register(LargeCategoryCell.self, forCellWithReuseIdentifier: LargeCategoryCell.IDENTIFIER)
        self.collectionView!.register(SmallCategoryCell.self, forCellWithReuseIdentifier: SmallCategoryCell.IDENTIFIER)
        
        getLargeCategory()
        setupApplyButton()
        
        collectionView.autoresizesSubviews = false
        
        let publisher = CategoryManager.shared.$mainSelectedSmallCategory
        publisher.sink { smallCategoryModel in
            self.selectedSmallCategory = smallCategoryModel
        }
        .store(in: &subscriptions)
    }
    
    private func setupApplyButton() {
        
    }
    
    private func getLargeCategory() {
        //        HTTPSession.shared.categoryLarge { result, error in
        //            if error == nil {
        //                self.largeCategoryList = result ?? []
        //
        //                self.collectionView.reloadData()
        //            }
        //        }
        
        self.largeCategoryList = CategoryManager.shared.largeCategoryList.sorted(by: { $0.largeCategoryId! > $1.largeCategoryId! })
        var count = 0
        for largeCategory in largeCategoryList {
            largeCategory.index = count
            count += 1
        }
        
        self.collectionView.reloadData()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return largeCategoryList.count + selectedSmallCategoryCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isLargeCategorySelected  {
            if indexPath.row > (selectedLargeCatgoryIndex) &&
                indexPath.row <= (selectedLargeCatgoryIndex + selectedSmallCategoryCount) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCategoryCell.IDENTIFIER, for: indexPath) as! SmallCategoryCell
                
                let smallCategory = smallCategoryList[indexPath.row - selectedLargeCatgoryIndex - 1]
                cell.name = smallCategory.smallCategoryName ?? ""
                
                if let selectedSmallCategory = selectedSmallCategory,
                   selectedSmallCategory.smallCategoryId == smallCategory.smallCategoryId {
                    cell.isSelectedCategory = true
                } else {
                    cell.isSelectedCategory = false
                }
                
                return cell
            } else {
                if indexPath.row <= selectedLargeCatgoryIndex {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCategoryCell.IDENTIFIER, for: indexPath) as! LargeCategoryCell
                    
                    // Configure the cell
                    let largeCategory = largeCategoryList[indexPath.row]
                    
                    cell.nameLabel.text = largeCategory.largeCategoryName
                    cell.backgroundImageVieww.kf.setImage(with: URL(string: largeCategory.largeCategoryCdnImageUri ?? ""))
                    
                    cell.backgroundImageVieww.layer.cornerRadius = CELL_WIDTH / 2
                    cell.backgroundImageVieww.clipsToBounds = true
                    
                    cell.grayView.cornerradius = CELL_WIDTH / 2
                    
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCategoryCell.IDENTIFIER, for: indexPath) as! LargeCategoryCell
                    
                    // Configure the cell
                    let largeCategory = largeCategoryList[indexPath.row - selectedSmallCategoryCount]
                    
                    cell.nameLabel.text = largeCategory.largeCategoryName
                    cell.backgroundImageVieww.kf.setImage(with: URL(string: largeCategory.largeCategoryCdnImageUri ?? ""))
                    
                    cell.backgroundImageVieww.layer.cornerRadius = CELL_WIDTH / 2
                    cell.backgroundImageVieww.clipsToBounds = true
                    
                    cell.grayView.cornerradius = CELL_WIDTH / 2
                    
                    return cell
                }
            }
            
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCategoryCell.IDENTIFIER, for: indexPath) as! LargeCategoryCell
            
            // Configure the cell
            let largeCategory = largeCategoryList[indexPath.row]
            
            cell.nameLabel.text = largeCategory.largeCategoryName
            cell.backgroundImageVieww.kf.setImage(with: URL(string: largeCategory.largeCategoryCdnImageUri ?? ""))
            
            cell.backgroundImageVieww.layer.cornerRadius = CELL_WIDTH / 2
            cell.backgroundImageVieww.clipsToBounds = true
            
            cell.grayView.cornerradius = CELL_WIDTH / 2
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CELL_WIDTH, height: CELL_WIDTH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedSmallCategoryCount == 0 {
            let largeCategory = largeCategoryList[indexPath.row]
            selectLargeCategory(largeCategory: largeCategory)
        } else {
            if indexPath.row <= selectedLargeCatgoryIndex {
                let largeCategory = largeCategoryList[indexPath.row]
                selectLargeCategory(largeCategory: largeCategory)
            } else {
                // Small Category 를 선택하였을 경우
                
                if indexPath.row > (selectedLargeCatgoryIndex) &&
                    indexPath.row <= (selectedLargeCatgoryIndex + selectedSmallCategoryCount) {
                    let smallCategory = smallCategoryList[indexPath.row - selectedLargeCatgoryIndex - 1]
                    if let selectedSmallCategory = selectedSmallCategory {
                        if selectedSmallCategory.smallCategoryId == smallCategory.smallCategoryId {
                            CategoryManager.shared.mainSelectedSmallCategory = nil
                        } else {
                            CategoryManager.shared.mainSelectedSmallCategory = smallCategory
                        }
                    } else {
                        CategoryManager.shared.mainSelectedSmallCategory = smallCategory
                    }
                } else {
                    let largeCategory = largeCategoryList[indexPath.row - selectedSmallCategoryCount]
                    selectLargeCategory(largeCategory: largeCategory)
                }
                
            }
        }
    }
    
    private func selectLargeCategory(largeCategory: LargeCategoryModel) {
        selectedLargeCatgoryIndex = largeCategory.index
        selectedSmallCategoryCount = largeCategory.smallCategoryList.count
        smallCategoryList = largeCategory.smallCategoryList
        isLargeCategorySelected = true
    }
    
}

extension CategoryCollectionVC: XTNavigationBarDelegate {
    func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func onMore() {
        
    }
    
    
}

class LargeCategoryCell: UICollectionViewCell {
    public static let IDENTIFIER = "LargeCategoryCell"
    
    public var backgroundImageVieww : UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        return iv
    }()
    
    public var grayView: UIView = {
        let vw = UIView()
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = #colorLiteral(red: 0.1405583918, green: 0.1517635584, blue: 0.1622542143, alpha: 0.4)
        
        return vw
    }()
    
    public var nameLabel : UILabel = {
        let lb = UILabel()
        
        lb.text = "test"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
        
        return lb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(backgroundImageVieww)
        self.addSubview(grayView)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageVieww.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageVieww.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImageVieww.rightAnchor.constraint(equalTo: self.rightAnchor),
            backgroundImageVieww.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            grayView.topAnchor.constraint(equalTo: backgroundImageVieww.topAnchor),
            grayView.leftAnchor.constraint(equalTo: backgroundImageVieww.leftAnchor),
            grayView.rightAnchor.constraint(equalTo: backgroundImageVieww.rightAnchor),
            grayView.bottomAnchor.constraint(equalTo: backgroundImageVieww.bottomAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: grayView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: grayView.centerYAnchor)
        ])
    }
}

class SmallCategoryCell: UICollectionViewCell {
    public static let IDENTIFIER = "SmallCategoryCell"
    
    private var grayView: UIView = {
        let vw = UIView()
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = XTColor.GREY_800.getColorWithString()
        vw.cornerradius = 24.3
        
        return vw
    }()
    
    public var nameLabel : UILabel = {
        let lb = UILabel()
        
        lb.text = "test"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
        
        return lb
    }()
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
            
            setupUI()
        }
    }
    
    var isSelectedCategory: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //setupUI()
    }
    
    private func setupUI() {
        DispatchQueue.main.async { [self] in
            self.addSubview(grayView)
            self.addSubview(nameLabel)
            
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            self.layoutSubviews()
            self.layoutIfNeeded()
            
            let nameLabelFrame = nameLabel.frame
            print("nameLabel frame = \(nameLabelFrame.width)")
            
            grayView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            grayView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            grayView.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: 28).isActive = true
            grayView.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, constant: 32).isActive = true
            
            if isSelectedCategory {
                grayView.backgroundColor = XTColor.FLUORESCENT_YELLOW.getColorWithString()
                nameLabel.textColor = XTColor.GREY_900.getColorWithString()
            } else {
                grayView.backgroundColor = XTColor.GREY_800.getColorWithString()
                nameLabel.textColor = .white
            }
        }
        
    }
}
