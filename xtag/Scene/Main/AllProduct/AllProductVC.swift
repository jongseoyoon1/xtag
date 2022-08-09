//
//  AllProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/06.
//

import UIKit
import Combine

class AllProductVC: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var postList: [PostModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPublisher()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getPost()
        
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
        
        collectionView.contentInset = UIEdgeInsets.zero
    }
    
    private func getPost() {
        if CategoryManager.shared.mainSelectedSmallCategory == nil {
            HTTPSession.shared.feed(smallCategoryId: nil, page: nil, size: nil) { result, error in
                if error == nil {
                    guard let result = result else {
                        return
                    }

                    self.postList = result
                }
            }
        } else {
            
        }
        
    }
    
    private func setupPublisher() {
        let publisher = CategoryManager.shared.$mainSelectedSmallCategory
        publisher.sink { smallCategoryModel in
            if let smallCategoryModel = smallCategoryModel {
                self.updatePost(smallCategoryId: smallCategoryModel.smallCategoryId ?? "")
            } else {
                self.updatePost(smallCategoryId: "")
            }
        }
        .store(in: &subscriptions)
    }
    
    private func updatePost(smallCategoryId: String) {
        HTTPSession.shared.feed(smallCategoryId: smallCategoryId, page: nil, size: nil) { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }

                self.postList = result
            }
        }
    }

}

extension AllProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let post = postList[indexPath.row]
        let ratio = post.postImageRatio
        let rx = CGFloat(ratio!.getRatioRx())
        let ry = CGFloat(ratio!.getRatioRy())
        
        let width = (self.view.frame.size.width - 2) / 2
        var height = width * ry / rx
        
        if rx == 0 || ry == 0 {
            height = width
        }
        
        print("rx = \(rx) ry = \(ry)")
        print("width = \(width) hieght = \(height)")
        
        return height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        let post = postList[indexPath.row]
        
        cell.setupCell(userName: post.userName ?? "", profileImageUri: post.userCdnImageUri ?? "", postImageUri: post.postCdnImageUri ?? "")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = postList[indexPath.row]
        let ratio = post.postImageRatio
        let rx = CGFloat(ratio!.getRatioRx())
        let ry = CGFloat(ratio!.getRatioRy())
        
        let width = (self.view.frame.size.width - 2) / 2
        var height = width * rx / ry
        
        if ratio! == "1:1" {
            height = width
        } else if ratio! == "4:5" {
            height = width / 4 * 5
        } else {
            height = width / 16 * 9
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        if let viewController = UIStoryboard(name: "UserPost", bundle: nil).instantiateViewController(withIdentifier: "UserPostVC") as? UserPostVC {
            MainNavigationBar.isHidden = true
            viewController.modalPresentationStyle = .fullScreen
            viewController.postId = post.postId ?? ""
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
}



