//
//  XTMainNavigationBar.swift
//  xtag
//
//  Created by Yoon on 2022/06/07.
//

import UIKit
import Combine

enum MainNavigationState {
    case ALL
    case MY
    case FOLLOWING
}
@IBDesignable
class XTMainNavigationBar: XIBView {
    
    public var state: MainNavigationState = .ALL {
        didSet {
            handleSelection(state)
        }
    }
    @IBOutlet weak var smallCategoryView: UIView!
    @IBOutlet weak var smallCategoryLabel: UILabel!
    
    @IBOutlet weak var allProductButton: XTCommonButton!
    @IBOutlet weak var myProductButton: XTCommonButton!
    @IBOutlet weak var followingProductButton: XTCommonButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoryToggleButton: UIButton!
    
    public var onAllProductButton: (()->Void)?
    public var onMyProductButton: (()->Void)?
    public var onFollowingProductButton: (()->Void)?
    
    private var subscriptions = Set<AnyCancellable>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupButtons()
        setupTitle()
    }
    
    override func loadInit(_ view: UIView) {
        
        setupButtons()
        setupTitle()
    }
    
    private func setupButtons() {
        allProductButton.didTab = { [self] in
            state = .ALL
            
            if onAllProductButton != nil {
                onAllProductButton!()
            }
        }
        
        myProductButton.didTab = { [self] in
            state = .MY
            
            if onMyProductButton != nil {
                onMyProductButton!()
            }
        }
        
        followingProductButton.didTab = { [self] in
            state = .FOLLOWING
        
            if onFollowingProductButton != nil {
                onFollowingProductButton!()
            }
        }
    }
    
    private func setupTitle() {
        let publisher = CategoryManager.shared.$mainSelectedSmallCategory
        publisher.sink { smallCategoryModel in
            if let smallCategoryModel = smallCategoryModel {
                self.stackView.isHidden = true
                self.smallCategoryView.isHidden = false
                self.smallCategoryLabel.isHidden = false
                self.smallCategoryLabel.text = smallCategoryModel.smallCategoryName
            } else {
                self.stackView.isHidden = false
                self.smallCategoryView.isHidden = true
                self.smallCategoryLabel.isHidden = true
            }
        }
        .store(in: &subscriptions)
    }
    
    private func handleSelection(_ state: MainNavigationState) {
        
        switch state {
        case .ALL:
            allProductButton.isSelected = true
            myProductButton.isSelected = false
            followingProductButton.isSelected = false
        case .MY:
            allProductButton.isSelected = false
            myProductButton.isSelected = true
            followingProductButton.isSelected = false
        case .FOLLOWING:
            allProductButton.isSelected = false
            myProductButton.isSelected = false
            followingProductButton.isSelected = true
        }
    }

    @IBAction func categoryToggleBtnPressed(_ sender: Any) {
        categoryToggleButton.isSelected = !categoryToggleButton.isSelected
        
        CategoryManager.shared.bottomBarIsOpen = categoryToggleButton.isSelected
        CategoryManager.shared.isOpen = categoryToggleButton.isSelected
    }
    @IBAction func deleteSmallCategoryPressed(_ sender: Any) {
        CategoryManager.shared.mainSelectedSmallCategory = nil
    }
}
