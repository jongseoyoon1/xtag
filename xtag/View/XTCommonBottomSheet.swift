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
        
        for act in actions {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: 56))
            button.setTitle(act.title, for: [])
            
            if act.type == .ALERT {
                
                button.setTitleColor(XTColor.RED_600.getColorWithString(), for: [])
            } else {
                button.setTitleColor(XTColor.GREY_900.getColorWithString(), for: [])
            }
            
            button.titleLabel?.font = UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 14)
            
            self.stackView.addArrangedSubview(button)
        }
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
