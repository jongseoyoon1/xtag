//
//  XTCommonBottomSheet.swift
//  xtag
//
//  Created by Yoon on 2022/07/31.
//

import UIKit

struct XTBottomSheetAction {
    var title: String
    var type: PopupType
    var handler: (()->Void)?
}

class XTCommonBottomSheet: UIViewController {
    
    public var onCancel: (()->Void)?
    public var actions: [XTBottomSheetAction] = []

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var idx = 1
        var height : CGFloat = 0
        for act in actions {
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: 56)
            
            button.setTitle(act.title, for: [])
            
            if act.type == .ALERT {
                
                button.setTitleColor(XTColor.RED_600.getColorWithString(), for: [])
            } else {
                button.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
            }
            if #available(iOS 14.0, *) {
                button.addAction {
                    guard let handler = act.handler else {
                        return
                    }
                    guard let onCancel = self.onCancel else { return }
                    
                    onCancel()
                    self.dismiss(animated: true)
                    
                    handler()
                }
            } else {
                // Fallback on earlier versions
            }
            button.titleLabel?.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
            
            self.stackView.addArrangedSubview(button)
            height = height + 56
            if idx == actions.count {
                
            } else {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: 1))
                view.backgroundColor = XTColor.GREY_300.getColorWithString()
                
                self.stackView.addArrangedSubview(view)
                height = height + 1
            }
            
            idx += 1
        }
        
        stackViewHeight.constant = height
        view.layoutSubviews()
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        guard let onCancel = onCancel else { return }
        
        self.dismiss(animated: true)
        
        onCancel()
    }
    
    static func create() -> XTCommonBottomSheet {
      let controller = XTCommonBottomSheet(nibName: "XTCommonBottomSheet", bundle: nil)
      return controller
    }
}

@available(iOS 14.0, *)
extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
