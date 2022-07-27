//
//  SceneDelegate.swift
//  xtag
//
//  Created by Yoon on 2022/05/25.
//

import UIKit
import FacebookCore
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLinks, error in
                
                // Dynamic Link 처리
                print(dynamicLinks)
                // Optional(<FIRDynamicLink: 0x2808c94f0, url [https://exdeeplinkjake.page.link/navigation&ibi=com.jake.sample.ExDeeplink], match type: unique, minimumAppVersion: N/A, match message: (null)>)
                
                self.patchDeeplink(url: incomingURL)
                if let dynamicLinks = dynamicLinks {
                    
                    
                }
            }
        }
    }
    
    
}



extension SceneDelegate {
    func patchDeeplink(url: URL) {
        
        deepLinkGotoProfile(url: url)
        
//        guard let deep_link_value = url.valueOf("id") else { return }
//
//        switch deep_link_value {
//        case "profile":
//            break
//        default:
//            return
//        }
        
        
    }
    
    func deepLinkGotoProfile(url: URL) {
        guard let link_url = URL(string: url.valueOf("link")!) else { return }
        guard let user_id = link_url.valueOf("id") else { return }
        
        let rootVC =   UIApplication.shared.keyWindow?.rootViewController
        let presentVC = rootVC?.presentedViewController
        
        if let userProfileVC = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC {
            
            userProfileVC.userId = user_id
            userProfileVC.modalPresentationStyle = .fullScreen
            
            if let vc = presentVC {
                vc.present(userProfileVC, animated: true, completion: nil)
            } else {
                if let root = rootVC {
                    root.present(userProfileVC, animated: true, completion: nil)
                }
            }
            
        }
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

