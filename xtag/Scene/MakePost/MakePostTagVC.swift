//
//  MakePostTagVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/27.
//

import UIKit

class MakePostTagVC: UIViewController {

    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var emptyRatioView: UIView!
    @IBOutlet weak var emptyProductView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var postImageView: UIImageView!
    
    public var postIndex : Int!
    public var productIndex : Int!
    public var postImage: UIImage!
    public var productList: [ProductModel] = [] {
        didSet {
            productCollectionView.reloadData()
        }
    }
    
    var selectedProduct : ProductModel? {
        didSet {
            self.productCollectionView.reloadData()
            
            if selectedProduct != nil {
                productNameLabel.isHidden = false
                productNameLabel.text = selectedProduct?.userProductTitle
                
                if selectedProduct?.xRatio == nil {
                    emptyRatioView.isHidden = false
                    tagImageView.isHidden = true
                } else {
                    
                    let x = selectedProduct!.xRatio!.CGFloatValue()! * self.postImageView.frame.width
                    let y = selectedProduct!.yRatio!.CGFloatValue()! * self.postImageView.frame.height
                    DispatchQueue.main.async { [self] in
                        
                        tagImageView.center = CGPoint(x: x, y: y)
                        tagImageView.isHidden = false
                        emptyRatioView.isHidden = true
                        

                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI()
    }
    
    private func updateUI() {
        
        
        
        productList = MakePostManager.shared.postList[postIndex].productList
        if productList.count > 0 {
            emptyProductView.isHidden = true
            productIndex = 0
            selectedProduct = productList.first!
            if selectedProduct?.xRatio == nil {
                emptyRatioView.isHidden = false
            } else {
                emptyRatioView.isHidden = true
            }
        } else {
            productNameLabel.isHidden = true
            emptyProductView.isHidden = false
            emptyRatioView.isHidden = true
        }
    }
    
    private func setupUI() {
        postImageView.image = postImage
    }
    
    private func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(UINib(nibName: "MakePostProductCell", bundle: nil), forCellWithReuseIdentifier: MakePostProductCell.IDENTIFIER)
        productCollectionView.register(UINib(nibName: "MakePostTagPlusCell", bundle: nil), forCellWithReuseIdentifier: "MakePostTagPlusCell")
    }
    
    @IBAction func compBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension MakePostTagVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.productCollectionView {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MakePostTagPlusCell", for: indexPath) as! MakePostTagPlusCell
                
                
                return cell
            } else {
                let product = productList[indexPath.row - 1]
            
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MakePostProductCell.IDENTIFIER, for: indexPath) as! MakePostProductCell
                
                cell.productImageView.kf.setImage(with: URL(string: product.productImageUri ?? ""))
                
                if let selectedProduct = self.selectedProduct {
                    if product.userProductId! == selectedProduct.userProductId! {
                        cell.productImageView.layer.borderColor = XTColor.BLUE_800.getColorWithString().cgColor
                        cell.productImageView.layer.borderWidth = 4.0
                    } else {
                        cell.productImageView.layer.borderWidth = 0.0
                    }
                    
                } else {
                    cell.productImageView.layer.borderWidth = 0.0
                }
                
                if product.xRatio == nil {
                    cell.isTaggedView.isHidden = true
                } else {
                    cell.isTaggedView.isHidden = false
                }
                
                cell.onRemove = {
                    self.productList.remove(at: indexPath.row - 1)
                    MakePostManager.shared.postList[self.postIndex].productList.remove(at: indexPath.row - 1)
                    self.updateUI()
                }
                
                
                return cell
            }
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.productCollectionView {
            return productList.count + 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == self.productCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: 72, height: 72)
            }
            
            return CGSize(width: 76, height: 76)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            if indexPath.row == 0 {
                if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostProductVC") as? MakePostProductVC {
                    viewcontroller.modalPresentationStyle = .fullScreen
                    
                    viewcontroller.postIndex = self.postIndex
                    
                    self.present(viewcontroller, animated: true)
                }
            } else {
                let product = productList[indexPath.row - 1]
                productIndex = indexPath.row - 1
                if self.selectedProduct == nil {
                    self.selectedProduct = product
                    
                } else {
                    if product.userProductId! == self.selectedProduct!.userProductId! {
                        self.selectedProduct = nil
                    } else {
                        self.selectedProduct = product
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            self.selectedProduct = nil
        }
    }
}

extension MakePostTagVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let productIdx = self.productIndex else { return }
        guard let selectedProduct = self.selectedProduct else { return }
        
        let touchPoint = touch.location(in: self.view)
        emptyRatioView.isHidden = true
        tagImageView.isHidden = false
        
        tagImageView.center = touchPoint
        MakePostManager.shared.postList[self.postIndex].productList[productIdx].xRatio = "\(touchPoint.x / self.postImageView.frame.size.width)"
        MakePostManager.shared.postList[self.postIndex].productList[productIdx].yRatio = "\(touchPoint.y / self.postImageView.frame.size.width)"
        
        selectedProduct.xRatio = "\(touchPoint.x / self.postImageView.frame.size.width)"
        selectedProduct.yRatio = "\(touchPoint.y / self.postImageView.frame.size.width)"
        print("tochesBegan = \(touchPoint)")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let productIdx = self.productIndex else { return }
        guard let selectedProduct = self.selectedProduct else { return }
        
        let touchPoint = touch.location(in: self.view)
        emptyRatioView.isHidden = true
        tagImageView.isHidden = false
        tagImageView.center = touchPoint
        MakePostManager.shared.postList[self.postIndex].productList[productIdx].xRatio = "\(touchPoint.x / self.postImageView.frame.size.width)"
        MakePostManager.shared.postList[self.postIndex].productList[productIdx].yRatio = "\(touchPoint.y / self.postImageView.frame.size.width)"
        
        selectedProduct.xRatio = "\(touchPoint.x / self.postImageView.frame.size.width)"
        selectedProduct.yRatio = "\(touchPoint.y / self.postImageView.frame.size.width)"
        print("touchesMoved = \(touchPoint)")
    }
    
    private func setProductTag(_ point: CGPoint,_ productIdx: Int) {
        guard let selectedProduct = self.selectedProduct else { return }
        
        let ratio = MakePostManager.shared.imageRatio!
        
        var xPadding : CGFloat = 0
        var yPadding : CGFloat = 0
        
        if ratio == "1:1" {
            xPadding = 0
            yPadding = 0
        } else if ratio == "4:5" {
            xPadding = self.postImageView.frame.size.width / 10
            yPadding = 0
        } else {
            xPadding = 0
            yPadding = self.postImageView.frame.size.width / 32 * 7
        }
        
        MakePostManager.shared.postList[self.postIndex].productList[productIdx].xRatio = "\(point.x / self.postImageView.frame.size.width)"
        MakePostManager.shared.postList[self.postIndex].productList[productIdx].yRatio = "\(point.y / self.postImageView.frame.size.width)"
        
        selectedProduct.xRatio = "\((point.x - xPadding) / (self.postImageView.frame.size.width - (2 * xPadding)))"
        selectedProduct.yRatio = "\((point.y - yPadding) / self.postImageView.frame.size.width - (2 * yPadding))"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let productIdx = self.productIndex else { return }
        //guard let selectedProduct = self.selectedProduct else { return }
        let touchPoint = touch.location(in: self.view)
        
        let ratio = MakePostManager.shared.imageRatio!
        
        if ratio == "1:1" {
            if touchPoint.y > self.postImageView.frame.maxY {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else if touchPoint.y < self.postImageView.frame.minY {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else {
                setProductTag(CGPoint(x: touchPoint.x, y: touchPoint.y), productIdx)
            }
        } else if ratio == "4:5" {
            if touchPoint.x < (self.postImageView.frame.width / 10) {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else if touchPoint.y > self.postImageView.frame.maxY {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else if touchPoint.y < self.postImageView.frame.minY {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else if touchPoint.x > (self.postImageView.frame.width / 10 * 9) {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else {
                setProductTag(CGPoint(x: touchPoint.x, y: touchPoint.y), productIdx)
            }
        } else {
            let yPadding = self.postImageView.frame.size.width / 32 * 7
            
            if touchPoint.y > self.postImageView.frame.maxY - yPadding {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else if touchPoint.y < self.postImageView.frame.minY + yPadding {
                tagImageView.center = self.postImageView.center
                
                setProductTag(tagImageView.center, productIdx)
            } else {
                setProductTag(CGPoint(x: touchPoint.x, y: touchPoint.y), productIdx)
            }
        }
        
        
    }
}

