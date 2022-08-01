//
//  MakePostSelectImageVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/26.
//

import UIKit
import Photos

enum RatioType {
    case ratio11
    case ratio169
    case ratio45
}

class MakePostSelectImageVC: UIViewController {
    
    @IBOutlet weak var imageCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var ratioView: UIView!
    @IBOutlet weak var ratioHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rationWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratioButton: UIButton!
    
    public var selectedCategory: [SmallCategoryModel] = []
    
    private var ratioType : RatioType = .ratio11
    private var allPhotos = PHFetchResult<PHAsset>()
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    
    private var allPhotoCount = 0
    private var selectedIndex: [Int] = [] {
        didSet {
            self.imageCollectionView.reloadData()
            
            if selectedIndex.count == 0 {
                infoStackView.isHidden = false
            } else {
                infoStackView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        checkAccessPhotoLibrary()
        updateCollectionViewHeight()
        setupRatioView()
        
        MakePostManager.shared.imageRatio = "1:1"
    }
    
    private func setupRatioView() {
        let width = UIScreen.main.bounds.width
        
        ratioHeightConstraint.constant = width
        rationWidthConstraint.constant = width
        
        view.layoutSubviews()
    }
    
    private func updateCollectionViewHeight() {
        let width = (self.view.frame.size.width - 2) / 3
        var count = allPhotoCount / 3
        if allPhotoCount % 3 != 0 {
            count = count + 1
        }
        
        imageCollectionHeightConstraint.constant = CGFloat(count) * width
        view.layoutSubviews()
    }
    
    private func setupCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "UserPostTagCell", bundle: nil), forCellWithReuseIdentifier: UserPostTagCell.IDENTIFIER)
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: PhotoCell.IDENTIFIER)
    }
    
    private func checkAccessPhotoLibrary() {
        if #available(iOS 14, *) {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .notDetermined:
                print("not determined")
                fetchImage()
            case .restricted:
                print("restricted")
                fetchImage()
            case .denied:
                print("denined")
            case .authorized:
                print("autorized")
                fetchImage()
                
            case .limited:
                print("limited")
            @unknown default:
                print("unKnown")
            }
            
        } else {
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                print("not determined")
                fetchImage()
            case .restricted:
                print("restricted")
                fetchImage()
            case .denied:
                print("denined")
            case .authorized:
                print("autorized")
                
                fetchImage()
                
            @unknown default:
                print("unKnown")
            }
            
        }
    }
    
    private func fetchImage() {
        DispatchQueue.main.async { [self] in
            let fetchQotions = PHFetchOptions()
            
            allPhotos = PHAsset.fetchAssets(with: .image, options: fetchQotions)
            allPhotoCount = allPhotos.count
            smartAlbums = PHAssetCollection.fetchAssetCollections(
              with: .smartAlbum,
              subtype: .albumRegular,
              options: nil)
            userCollections = PHAssetCollection.fetchAssetCollections(
              with: .album,
              subtype: .albumRegular,
              options: nil)
            
            self.imageCollectionView.reloadData()
            self.updateCollectionViewHeight()
        }
    }
    
    private func getUIImage(asset: PHAsset) -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { data, _ in
            if let data = data {
                img = data
            }
        }
        
        return img
    }
    
    private func getOriginalUIImage(asset: PHAsset) -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    @IBAction func rationBtnPressed(_ sender: Any) {
        if ratioType == .ratio11 {
            ratioType = .ratio169
            ratioButton.setImage(UIImage(named: "ratio_169"), for: [])
            
            let width = UIScreen.main.bounds.width
            
            rationWidthConstraint.constant = width
            ratioHeightConstraint.constant = width / 16 * 9
            
            MakePostManager.shared.imageRatio = "16:9"
            
            view.layoutSubviews()
        } else if ratioType == .ratio169 {
            ratioType = .ratio45
            ratioButton.setImage(UIImage(named: "ratio_45"), for: [])
            
            let height = UIScreen.main.bounds.width
            
            ratioHeightConstraint.constant = height
            rationWidthConstraint.constant = height / 5 * 4
            
            MakePostManager.shared.imageRatio = "4:5"
            
            view.layoutSubviews()
        } else {
            ratioType = .ratio11
            ratioButton.setImage(UIImage(named: "ratio_11"), for: [])
            
            let width = UIScreen.main.bounds.width
            
            ratioHeightConstraint.constant = width
            rationWidthConstraint.constant = width
            
            MakePostManager.shared.imageRatio = "1:1"
            
            view.layoutSubviews()
        }
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostUploadVC") as? MakePostUploadVC {
            var selectImage : [UIImage] = []
            
            MakePostManager.shared.postList = []
            
            for idx in self.selectedIndex {
                let reversedIndex = allPhotos.count - idx - 1
                let asset = self.allPhotos[reversedIndex]
                let image = getOriginalUIImage(asset: asset)
                selectImage.append(image!)
                
                MakePostManager.shared.postList.append(UploadPostModel.init())
                
            }
            
            viewcontroller.selectedCategory = self.selectedCategory
            viewcontroller.ratioType = self.ratioType
            viewcontroller.imageList = selectImage
            viewcontroller.modalPresentationStyle = .fullScreen
            
            self.present(viewcontroller, animated: true, completion: nil)
        }
        
    }
    
    
}


extension MakePostSelectImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostTagCell.IDENTIFIER, for: indexPath) as! UserPostTagCell
            
            let category = selectedCategory[indexPath.row]
            
            cell.tagButton.setTitle(category.smallCategoryName ?? "", for: [])
            cell.tagButton.isUserInteractionEnabled = false
            cell.setButtonState(isSelected: true)
            cell.layer.cornerRadius = 16
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.IDENTIFIER, for: indexPath) as! PhotoCell
            let reversedIndex = allPhotos.count - indexPath.row - 1
            let asset = self.allPhotos[reversedIndex]
            let image = getUIImage(asset: asset)
            
            cell.photoImageView.image = image
            
            if self.selectedIndex.contains(indexPath.row) {
                cell.countView.backgroundColor = XTColor.GREY_900.getColorWithString()
                cell.countView.bordercolor = XTColor.GREY_900.getColorWithString()
                
                cell.countLabel.text = "\((self.selectedIndex.firstIndex(of: indexPath.row) ?? 0) + 1)"
                
                cell.countLabel.isHidden = false
            } else {
                
                
                cell.countView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
                cell.countView.bordercolor = .white
                
                cell.countLabel.isHidden = true
            }
            
            cell.onSelected = {
                if self.selectedIndex.contains(indexPath.row) {
                    self.selectedIndex.remove(at: self.selectedIndex.firstIndex(of: indexPath.row)!)
                    
                }
                
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return selectedCategory.count
        } else {
            return allPhotoCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let category = selectedCategory[indexPath.row]
            let font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 11)
            let fontAttributes = [NSAttributedString.Key.font : font]
            let text = category.smallCategoryName ?? ""
            let size = (text as NSString).size(withAttributes: fontAttributes)
            
            return CGSize(width: size.width + 24, height: 32)
        } else {
            let width = (self.view.frame.size.width - 3) / 3
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return 16
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return 16
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
        } else {
            let reversedIndex = allPhotos.count - indexPath.row - 1
            let asset = self.allPhotos[reversedIndex]
            
            if self.selectedIndex.contains(indexPath.row) {
                
            } else {
                self.selectedIndex.append(indexPath.row)
            }
            
            self.postImageView.image = getOriginalUIImage(asset: asset)//getUIImage(asset: asset)
        }
    }
}
