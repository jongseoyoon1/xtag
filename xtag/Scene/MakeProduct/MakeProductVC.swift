//
//  MakeProductVC.swift
//  xtag
//
//  Created by Yoon on 2022/06/28.
//

import UIKit

class MakeProductVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.addDashedBorder(strokeColor: .black, lineWidth: 5)
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
    }
    
}