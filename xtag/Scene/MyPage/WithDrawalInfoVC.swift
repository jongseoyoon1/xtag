//
//  WithDrawalInfoVC.swift
//  xtag
//
//  Created by Yoon on 2022/08/06.
//

import UIKit
import FirebaseAuth

class WithDrawalInfoVC: UIViewController {
    
    @IBOutlet weak var withDrawalButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    public var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkBtnPreesed(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        
        if !checkButton.isSelected {
            withDrawalButton.setTitleColor(XTColor.GREY_500.getColorWithString(), for: [])
            withDrawalButton.backgroundColor = XTColor.GREY_100.getColorWithString()
        } else {
            withDrawalButton.setTitleColor(.white, for: [])
            withDrawalButton.backgroundColor = XTColor.GREY_900.getColorWithString()
        }
    }
    
    @IBAction func withDrawalBtnPreesed(_ sender: Any) {
        if checkButton.isSelected {
            
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
            HTTPSession.shared.withDrawal(content: content) { _, _ in
                if let splashVC = UIStoryboard(name: "Splash", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC {
                    UIApplication.shared.windows.first!.rootViewController = splashVC
                    UIApplication.shared.windows.first!.makeKeyAndVisible()
                }
            }
            
           
        }
    }
    
}
