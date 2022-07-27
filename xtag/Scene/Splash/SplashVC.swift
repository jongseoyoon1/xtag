//
//  SplashVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/12.
//

import UIKit
import FirebaseAuth

class SplashVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
//            do {
//                try Auth.auth().signOut()
//            } catch let signOutError as NSError {
//                print("Error signing out: %@", signOutError)
//            }

            
            if let user = Auth.auth().currentUser {
                // 로그인 된 경우
                
                HTTPSession.shared.getUser { user, error in
                    UserManager.shared.user = user
                    
                    
                    HTTPSession.shared.getUserProfile(userId: user?.UserId ?? "") { userInfo, error in
                        if error == nil {
                            UserManager.shared.userInfo = userInfo
                            
                            self.getLargeCategory()
                        }
                    }
                    
                }
                
                
            } else {
                // 로그인이 되지 않은 경우
                
                self.gotoLogin()
            }
        }
        
    }
    
    private func getLargeCategory() {
        print("****************************************")
        HTTPSession.shared.categoryLarge { result, error in
            if error == nil {
                guard var largeCategoryList = result else { return }
                var iterCount = 0
                for large in largeCategoryList {
                    HTTPSession.shared.categorySmall(largeCategoryId: large.largeCategoryId!) { smallCategoryResult, error in
                        if error == nil {
                            guard let smallCategoryResult = smallCategoryResult else {
                                return
                            }
                            print("large category = \(largeCategoryList.count)")
                            print("get small category = \(iterCount)")
                            large.smallCategoryList = smallCategoryResult
                            
                            iterCount += 1
                            
                            if largeCategoryList.count == iterCount + 1 {
                                CategoryManager.shared.largeCategoryList = largeCategoryList
                                self.gotoMain()
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
       
    }
    
    private func gotoMain() {
        self.performSegue(withIdentifier: "segue_tab", sender: self)
    }
    
    private func gotoLogin() {
        self.performSegue(withIdentifier: "segue_login", sender: self)
    }
    
}
