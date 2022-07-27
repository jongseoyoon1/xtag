//
//  MakePostVC.swift
//  xtag
//
//  Created by Yoon on 2022/07/23.
//

import UIKit

class MakePostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func compBtnPressed(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakePostSelectCategoryVC") as? MakePostSelectCategoryVC {
            
            viewcontroller.modalPresentationStyle = .automatic
            self.present(viewcontroller, animated: true)
        }
    }
}
