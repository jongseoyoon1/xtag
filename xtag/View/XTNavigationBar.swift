//
//  XtagNavigationBar.swift
//  xtag
//
//  Created by Yoon on 2022/05/25.
//

import UIKit

@IBDesignable
class XTNavigationBar: XIBView {
    

    @IBInspectable
    public var isBackButton: Bool = false {
        didSet {
            backButton.isHidden = !isBackButton
        }
    }
    
    @IBInspectable
    public var isDismissButton: Bool = false {
        didSet {
            dismissButton.isHidden = !isDismissButton
        }
    }
    
    @IBInspectable
    public var isMoreButton: Bool = false {
        didSet {
            moreButton.isHidden = !isMoreButton
        }
    }
    
    @IBInspectable
    public var isImageTitle: Bool = false {
        didSet {
            imageTitleView.isHidden = !isImageTitle
        }
    }
    
    
    private var backButton: UIButton = {
        let btn = UIButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "chevron-left"), for: [])
        btn.isHidden = true
        btn.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
        
        return btn
    }()
    
    private var dismissButton: UIButton = {
        let btn = UIButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "close"), for: [])
        btn.isHidden = true
        btn.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
        
        return btn
    }()
    
    private var moreButton: UIButton = {
        let btn = UIButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "chevron-left"), for: [])
        btn.isHidden = true
        btn.addTarget(self, action: #selector(onMore), for: .touchUpInside)
        
        return btn
    }()
    
    private var imageTitleView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isHidden = true
        
        return stackView
    }()
    
    private var imageTitleImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private var imageTitleLabel: UILabel = {
        let lb = UILabel()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: XTFont.PRETENDARD_REGULAR, size: 16)
        lb.textColor = UIColor(named: XTColor.GREY_900)
        
        return lb
    }()
    
    var delegate: XTNavigationBarDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup UI
        setupUI()
        
        // Set StackView
        imageTitleView.addArrangedSubview(imageTitleImageView)
        imageTitleView.addArrangedSubview(imageTitleLabel)
    }
    
    override func loadInit(_ view: UIView) {
        
        // Setup UI
        setupUI()
        
        // Set StackView
        imageTitleView.addArrangedSubview(imageTitleImageView)
        imageTitleView.addArrangedSubview(imageTitleLabel)
        
    }
    
    private func setupUI() {
        self.layoutIfNeeded()
        
        self.backgroundColor = .clear
        
        self.addSubview(imageTitleView)
        self.addSubview(backButton)
        self.addSubview(moreButton)
        self.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            imageTitleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageTitleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            dismissButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            dismissButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    @objc private func onDismiss() {
        delegate?.onDismiss()
    }
    
    @objc private func onMore() {
        delegate?.onMore()
    }
    
}

protocol XTNavigationBarDelegate {
    func onDismiss()
    func onMore()
}
