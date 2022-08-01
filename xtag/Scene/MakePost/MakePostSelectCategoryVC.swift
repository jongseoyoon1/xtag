//
//  MakePostSelectCategoryVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/26.
//

import UIKit

class MakePostSelectCategoryVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    public var smallCategoryList: [SmallCategoryModel] = []
    public var selectedSmallCategoryList: [SmallCategoryModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var CELL_WIDTH: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CELL_WIDTH = (self.view.frame.size.width - 32 - 44) / 3
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView!.register(PostSmallCategoryCell.self, forCellWithReuseIdentifier: PostSmallCategoryCell.IDENTIFIER)
        
        getUserCategory()
    }
    
    private func getUserCategory() {
        HTTPSession.shared.getUserCategory(userId: UserManager.shared.userInfo!.userId!) { smallCategoryModel, error in
            if error == nil {
                self.smallCategoryList = smallCategoryModel ?? []
                
                self.collectionView.reloadData()
            }
        }
    }

    @IBAction func selectBtnPressed(_ sender: Any) {
        
        MakePostManager.shared.selectedCategory = selectedSmallCategoryList
        
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostSelectImageVC") as? MakePostSelectImageVC {
            viewcontroller.selectedCategory = selectedSmallCategoryList
            viewcontroller.modalPresentationStyle = .fullScreen
            self.present(viewcontroller, animated: true)
        }
    }
}

extension MakePostSelectCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return smallCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostSmallCategoryCell.IDENTIFIER, for: indexPath) as! PostSmallCategoryCell
        let smallCategory = smallCategoryList[indexPath.row]
        cell.cornerradius = CELL_WIDTH / 4
        
        
        if self.selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
            cell.isSelectedCategory = true
        } else {
            
            cell.isSelectedCategory = false
        }
        
        
        
        cell.name = smallCategory.smallCategoryName ?? ""
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CELL_WIDTH, height: CELL_WIDTH / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let smallCategory = smallCategoryList[indexPath.row]
        
        
        if self.selectedSmallCategoryList.contains(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! }) {
            self.selectedSmallCategoryList.remove(at: self.selectedSmallCategoryList.firstIndex(where: { $0.smallCategoryId! == smallCategory.smallCategoryId! })!)
        } else {
            self.selectedSmallCategoryList.append(smallCategory)
        }
    }
}

class PostSmallCategoryCell: UICollectionViewCell {
    public static let IDENTIFIER = "PostSmallCategoryCell"
    
    public var grayView: UIView = {
        let vw = UIView()
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = XTColor.GREY_800.getColorWithString()
        vw.cornerradius = 24
        
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
                grayView.backgroundColor = XTColor.GREY_100.getColorWithString()
                nameLabel.textColor =  XTColor.GREY_500.getColorWithString()
            }
        }
        
    }
}
