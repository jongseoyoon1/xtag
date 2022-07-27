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
        case getMyFeed
        case getPostDetail(postId: String)
        case likePost(postId: String)
        case getPostAlbum(userId: String, smallCategoryId: String)
        case getPostComment(postId: String)
        case getPostReply(postCommentId: String)
        case writeComment(postId: String, comment:String)
        case writeReply(postCommentId: String, comment:String)
        
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
            case .getMyFeed:
                return "post/feed/category"
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
            default: break
            }
            
            return param
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
    
    func getMyFeed(completion: @escaping([PostModel]?, Error?) -> Void) {
        
        request(request: Post.getMyFeed).responseJSON { response in
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

