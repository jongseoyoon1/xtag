//
//  LoginVC.swift
//  xtag
//
//  Created by Yoon on 2022/05/25.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseMessaging
import FacebookLogin
import CryptoKit
import AuthenticationServices
import SwiftyUserDefaults

class LoginVC: BaseViewController, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
    
    
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func appleLoginBtnPressed(_ sender: Any) {
        startSignInWithAppleFlow()
    }
    
    @IBAction func facebookLoginBtnPressed(_ sender: Any) {
        facebookLogin()
    }
    
    @IBAction func googleLoginBtnPressed(_ sender: Any) {
        googleLogin()
    }
    
    private func loginWithFirebase(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            guard
                let token = result?.user.uid,
                let fcmToken = Messaging.messaging().fcmToken else {
                print("login Error")
                print("=============================")
                print(error)
                print("=============================")
                
                return
            }
            
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                if let error = error {
                    return;
                }
                UserManager.shared.jwt = idToken!
                
                print("*****************")
                print(token)
                print("*****************")
                print(fcmToken)
                print("*****************  jwt")
                print(idToken)
                print("*****************")
                
                SignUpManager.shared.userInfo.providerId = token
                SignUpManager.shared.userInfo.fcmToken = fcmToken
                
                HTTPSession.shared.login(providerId: token, fcmToken: fcmToken) { result, error in
                    if error == nil {
                        UserManager.shared.user = result
                        
                        print("*****************")
                        print("Defaults[jwt] = \(Defaults[\.jwt])")
                        print("*****************")
                        
                        if result?.jwt == nil {
                            //  UserId가 없어 회원가입이 필요한 경우
                            if let viewcontroller = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
                                
                                viewcontroller.modalPresentationStyle = .fullScreen
                                self.present(viewcontroller, animated: true, completion: nil)
                            }
                        } else {
                            // UserId가 있어 로그인 된경우
                            HTTPSession.shared.getUser { user, error in
                                UserManager.shared.user = user
                                
                                
                                HTTPSession.shared.getUserProfile(userId: user?.UserId ?? "") { userInfo, error in
                                    if error == nil {
                                        UserManager.shared.userInfo = userInfo
                                        
                                        if let viewcontroller = UIStoryboard(name: "Tab", bundle: nil).instantiateViewController(withIdentifier: "TabVC") as? TabVC {
                                            
                                            viewcontroller.modalPresentationStyle = .fullScreen
                                            self.present(viewcontroller, animated: true, completion: nil)
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                }
            })
            
            
            
            
        }
    }
    
    private func googleLogin() {
        let signInConfig = GIDConfiguration(clientID: "994684756010-mnlvmu5tqph4f7s9qib66qru87oju25e.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken,
                let email = user?.profile?.email
            else {
                return
            }
            SignUpManager.shared.userInfo.email = email
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            SignUpManager.shared.userInfo.providerType = "google"
            self.loginWithFirebase(credential)
        }
        
    }
    
    private func facebookLogin() {
        let loginManger = LoginManager()
        
        loginManger.logIn(permissions: ["email"], from: self) { result, error in
            if error == nil {
                if AccessToken.current != nil {
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    let email = result?.dictionaryWithValues(forKeys: ["email"])["email"] as! String
                    SignUpManager.shared.userInfo.email = email
                    SignUpManager.shared.userInfo.providerType = "facebook"
                    self.loginWithFirebase(credential)
                } else {
                    
                }
            }
        }
    }
    
    
    // MARK: - For Apple Login
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}


@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            SignUpManager.shared.userInfo.providerType = "apple"
            self.loginWithFirebase(credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    
    
}
