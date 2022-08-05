//
//  HTTPSession+User.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import Foundation
import Alamofire

extension HTTPSession {
    private enum Post: Router {
        case feed(smallCategoryId: String?, page: Int?, size: Int?)
        case getMyFeed(smallCategoryId: String)
        case getPostDetail(postId: String)
        case likePost(postId: String)
        case getPostAlbum(userId: String, smallCategoryId: String)
        case getPostComment(postId: String)
        case getPostReply(postCommentId: String)
        case writeComment(postId: String, comment:String)
        case writeReply(postCommentId: String, comment:String)
        case uploadPost
        case feedFollowings(page: String, size: String)
        case updatePost(postId: String, smallCategoryIdList: [String], postBodyContentList: [String])
        
        var path: String {
            switch self {
            case .feed(let smallCategoryId,let page,let size):
                var id = ""
                if smallCategoryId != nil {
                    id = smallCategoryId!
                }
                return "post/feed?smallCategoryId=\(id)"
            case .getPostDetail(let postId):
                return "post/\(postId)"
            case .getMyFeed(let smallCategoryId):
                return "post/feed/category?smallCategoryId=\(smallCategoryId)"
            case .likePost(let postId):
                return "post/\(postId)/like"
            case .getPostAlbum(let userId, let smallCategoryId):
                return "post/album/\(userId)?smallCategoryId=\(smallCategoryId)"
            case .getPostComment(let postId):
                return "post/comment/\(postId)"
            case .getPostReply(let postCommentId):
                return "post/comment/\(postCommentId)/reply"
            case .writeComment(let postId, let comment):
                return "post/comment/\(postId)"
            case .writeReply(let postCommentId, let comment):
                return "post/comment/\(postCommentId)/reply"
            case .uploadPost:
                return "post"
            case .feedFollowings(let page,let size):
                return "post/feed/followings?page=\(page)&size=\(size)"
            case .updatePost(let postId, let smallCategoryIdList, let postBodyContentList):
                return "post/\(postId)"
            default:
                return ""
            }
        }
        
        
        var method: HTTPMethod {
            switch self {
            case .feed:
                return .get
            case .getMyFeed:
                return .get
            case .getPostDetail:
                return .get
            case .likePost:
                return .patch
            case .getPostAlbum:
                return .get
            case .getPostReply:
                return .get
            case .writeComment:
                return .post
            case .writeReply:
                return .post
            case .uploadPost:
                return .post
            case .feedFollowings:
                return .get
            case .updatePost:
                return .patch
            default:
                return .get
            }
        }
        
        var paramaters: Parameters? {
            var param = Parameters()
            
            switch self {
            case .feed(let smallCategoryId,let page,let size):
                //param["smallCategoryId"] = smallCategoryId
                //param["page"] = page
                //param["size"] = size
                break
            case .writeComment(let postId, let comment):
                param["comment"] = comment
            case .writeReply(let postCommentId, let comment):
                param["comment"] = comment
            case .uploadPost:
                break
            case .updatePost(let postId, let smallCategoryIdList, let postBodyContentList):
                param["smallCategoryIdList"] = smallCategoryIdList
                param["postBodyContentList"] = postBodyContentList
            default: break
            }
            
            return param
        }
        
        
    }
    
    func updatePost(postId: String, smallCategoryIdList: [String], postBodyContentList: [String], completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Post.updatePost(postId: postId, smallCategoryIdList: smallCategoryIdList, postBodyContentList: postBodyContentList)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    
                    completion(dict,nil)
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func uploadPost(image:[Data],upload_progress: @escaping(Progress, UploadRequest)->Void, completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        var filedata:[FileData] = []
        
        var param :[String:Any] = [:]
        /* image Ratio */
        param["imageRatio"] = MakePostManager.shared.imageRatio!
        
        /* small Category Ids */
        var smallCategoryIdList: [String] = []
        
        for category in MakePostManager.shared.selectedCategory {
            smallCategoryIdList.append(category.smallCategoryId!)
        }
        param["smallCategoryIdList"] = smallCategoryIdList
        
        /* post Body ContentList */
        var postBodyContentList: [String] = []
        
        for post in MakePostManager.shared.postList {
            postBodyContentList.append(post.content ?? "")
        }
        param["postBodyContentList"] = postBodyContentList
        
        /* user Product Info List */
        var userProductInfoList: [[[String:Any]]] = []
        for post in MakePostManager.shared.postList {
            
            var userProductInfoListChild : [[String:Any]] = []
            for product in post.productList {
                var productInfo : [String: String] = [:]
                productInfo["userProductId"] = product.userProductId!
                productInfo["xRatio"] = product.xRatio ?? "0.0"
                productInfo["yRatio"] = product.yRatio ?? "0.0"
                
                userProductInfoListChild.append(productInfo)
            }
            
            userProductInfoList.append(userProductInfoListChild)
        }
        
        param["userProductInfoLists"] = userProductInfoList
        
        var filenameList : [String] = []
        for (i, img) in image.enumerated() {
            let imageVar = "imageFileList"
            let filename = "imageFileList_\(Date())[\(i)].png"
            filenameList.append(filename)
            filedata.append(FileData(data: img,
                                     name: imageVar,
                                     filename: filename,
                                     mimeType: .image))
        }
        
        //param["imageFileList"] = filenameList
        
        
        
        upload(Post.uploadPost,
               filedata: filedata, param: param, uploadProgress: upload_progress) { (response, err) in
                completion(response, err)
        }
    }
    
    func writeReply(postCommentId: String, comment: String,completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Post.writeReply(postCommentId: postCommentId, comment:comment)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        completion(result,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func writeComment(postId: String, comment: String,completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Post.writeComment(postId: postId, comment:comment)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        completion(result,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getPostReply(postCommentId: String, completion: @escaping([ReplytModel]?, Error?) -> Void) {
        
        request(request: Post.getPostReply(postCommentId: postCommentId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [ReplytModel] = []
                        
                        for rst in result {
                            let post = ReplytModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }  
                        completion(tempPostList,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    
    func getPostComment(postId: String, completion: @escaping([CommentModel]?, Error?) -> Void) {
        
        request(request: Post.getPostComment(postId: postId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [CommentModel] = []
                        
                        for rst in result {
                            let post = CommentModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }
                        
                        completion(tempPostList,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func likePost(postId: String, completion: @escaping(Dictionary<String, Any>?, Error?) -> Void) {
        
        request(request: Post.likePost(postId: postId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        completion(result,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getPostDetail(postId: String, completion: @escaping(PostDetailModel?, Error?) -> Void) {
        
        request(request: Post.getPostDetail(postId: postId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? Dictionary<String, Any> {
                        
                        completion(PostDetailModel(JSON: result as! [String:Any]),nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func feedFollowings(page: String, size: String, completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Post.feedFollowings( page: page, size: size)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [PostModel] = []
                        
                        for rst in result {
                            let post = PostModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }
                        
                        completion(tempPostList,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func feed(smallCategoryId: String?, page: Int?, size: Int?, completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Post.feed(smallCategoryId: smallCategoryId, page: page, size: size)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [PostModel] = []
                        
                        for rst in result {
                            let post = PostModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }
                        
                        completion(tempPostList,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getMyFeed(smallCategoryId: String, completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Post.getMyFeed(smallCategoryId: smallCategoryId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [PostModel] = []
                        
                        for rst in result {
                            let post = PostModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }
                        
                        completion(tempPostList,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
    
    func getPostAlbum(userId: String, smallCategoryId: String, completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Post.getPostAlbum(userId:userId, smallCategoryId: smallCategoryId)).responseJSON { response in
            switch response.result {
            case .success(let result):
                if let dict = result as? Dictionary<String, Any> {
                    if let result = dict["result"] as? [Dictionary<String, Any>] {
                        var tempPostList : [PostModel] = []
                        
                        for rst in result {
                            let post = PostModel(JSON: rst as! [String:Any])
                            tempPostList.append(post!)
                        }
                        
                        completion(tempPostList,nil)
                    }
                    
                    
                } else {
                    completion(nil, nil)
                }
                
                
                
            case .failure(let error):
                print("error message = \(error)")
                completion(nil, error)
            }
        
        }
    }
}

