//
//  MyProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/06.
//

import UIKit
import Combine

class FollowingProductVC: UIViewController {
    
    private var isPaging = false
    private var page = "0"
    private var size = "20"
    
    private var subscriptions = Set<AnyCancellable>()

    private var postList: [PostModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        setupCollectionView()
        getPost()
        setupPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
        HTTPSession.shared.feedFollowings(page: "", size: "") { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }

                self.postList = result
            }
        }
    }
    
    private func setupPublisher() {
        let publisher = CategoryManager.shared.$mainSelectedSmallCategory
        publisher.sink { smallCategoryModel in
            if let smallCategoryModel = smallCategoryModel {
                self.page = "0"
                self.updatePost(smallCategoryId: smallCategoryModel.smallCategoryId ?? "")
            } else {
                self.page = "0"
                self.updatePost(smallCategoryId: "")
            }
        }
        .store(in: &subscriptions)
    }
    
    private func updatePost(smallCategoryId: String) {
        HTTPSession.shared.feed(smallCategoryId: smallCategoryId, page: page, size: size) { result, error in
            if error == nil {
                guard let result = result else {
                    return
                }

                if self.page == "0" {
                    self.postList = result
                } else {
                    self.postList.append(contentsOf: result)
                    self.collectionView.reloadData()
                }
                
                self.isPaging = false
            }
        }
    }

}



extension FollowingProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , CustomLayoutDelegate {
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
        
        let width = (UIScreen.main.bounds.width - 2 ) / 2//(self.view.frame.size.width - 2) / 2
        var height = width * rx / ry
        
        if rx == 0 || ry == 0 {
            height = width
        }
        
        print("rx = \(rx) ry = \(ry)")
        print("width = \(width) hieght = \(height)")
        
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


extension FollowingProductVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        
        
        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            
            if isPaging == false {
                
                var pageIdx = Int(self.page)!
                pageIdx += 1
                self.page = "\(pageIdx)"
                isPaging = true
                getPost()
            }
        }
    }
}
