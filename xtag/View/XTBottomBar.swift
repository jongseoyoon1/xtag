//
//  XTBottomBar.swift
//  xtag
//
//  Created by Yoon on 2022/06/12.
//

import UIKit

class XTBottomBar: XIBView {
    
    var delegate: XTBottomBarDelegate?
    @IBOutlet weak var myPageButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func loadInit(_ view: UIView) {
        
        
    }

    @IBAction func plusBtnPressed(_ sender: Any) {
        if let delegate = delegate {
            delegate.onPlus()
        }
        
        activeButton.isSelected = !activeButton.isSelected
        NavigationManager.shared.activeBottomBar = activeButton.isSelected
        
    }
    @IBAction func mainBtnPressed(_ sender: Any) {
        if let delegate = delegate {
            delegate.onMain()
        }
        activeButton.isSelected = false
        NavigationManager.shared.activeBottomBar = false
    }
    @IBAction func myPageBtnPressed(_ sender: Any) {
        if let delegate = delegate {
            delegate.onMyPage()
        }
        activeButton.isSelected = false
        NavigationManager.shared.activeBottomBar = false
    }
}

protocol XTBottomBarDelegate {
    func onPlus()
    func onMain()
    func onMyPage()
}
