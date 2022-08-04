//
//  MakePostAlbumVC.swift
//  xtag
//
//  Created by Yoon on 2022/08/04.
//

import UIKit
import Photos

class MakePostAlbumVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var makePostSelectImageVC: MakePostSelectImageVC!
    public var makePostAddImageVC: MakePostAddImageVC!
    public var userCollections = PHFetchResult<PHAssetCollection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableview()
    }
    
    private func setupTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func fetchThumbnail(collection: PHCollection, targetSize: CGSize, completion: @escaping (UIImage?) -> ()) {
        
        func fetchAsset(asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> ()) {
            let options = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            // We could use PHCachingImageManager for better performance here
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options, resultHandler: { (image, info) in
                completion(image)
            })
        }
        
        func fetchFirstImageThumbnail(collection: PHAssetCollection, targetSize: CGSize, completion: @escaping (UIImage?) -> ()) {
            // We could sort by creation date here if we want
            let assets = PHAsset.fetchAssets(in: collection, options: PHFetchOptions())
            if let asset = assets.firstObject {
                fetchAsset(asset: asset, targetSize: targetSize, completion: completion)
            } else {
                completion(nil)
            }
        }
        
        if let collection = collection as? PHAssetCollection {
            let assets = PHAsset.fetchKeyAssets(in: collection, options: PHFetchOptions())
            
            if let keyAsset = assets?.firstObject {
                fetchAsset(asset: keyAsset, targetSize: targetSize) { (image) in
                    if let image = image {
                        completion(image)
                    } else {
                        fetchFirstImageThumbnail(collection: collection, targetSize: targetSize, completion: completion)
                    }
                }
            } else {
                fetchFirstImageThumbnail(collection: collection, targetSize: targetSize, completion: completion)
            }
        } else if let collection = collection as? PHCollectionList {
            // For folders we get the first available thumbnail from sub-folders/albums
            // possible improvement - make a "tile" thumbnail with 4 images
            let inner = PHCollection.fetchCollections(in: collection, options: PHFetchOptions())
            inner.enumerateObjects { (innerCollection, idx, stop) in
                self.fetchThumbnail(collection: innerCollection, targetSize: targetSize, completion: { (image) in
                    if image != nil {
                        completion(image)
                        stop.pointee = true
                    } else if idx >= inner.count - 1 {
                        completion(nil)
                    }
                })
            }
        } else {
            // We shouldn't get here
            completion(nil)
        }
    }

    
}

extension MakePostAlbumVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.selectionStyle = .none
        let collection = self.userCollections[indexPath.row]
        print(collection)
        
        cell.titleLabel.text = collection.localizedTitle
        cell.countLabel.text = "\(collection.estimatedAssetCount)"
        fetchThumbnail(collection: collection, targetSize: CGSize(width: 300, height: 300)) { image in
            cell.albumImageView.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let collection = self.userCollections[indexPath.row]
        if makePostSelectImageVC != nil {
            
            makePostSelectImageVC.updateAlbum(localIdentifier: collection.localIdentifier, collection: collection)
        }
        
        if makePostAddImageVC != nil {
            
            makePostAddImageVC.updateAlbum(localIdentifier: collection.localIdentifier, collection: collection)
        }
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCollections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


