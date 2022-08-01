//
//  XTCommonPopup.swift
//  xtag
//
//  Created by Yoon on 2022/07/31.
//

import UIKit

enum PopupType {
    case COMMON
    case ALERT
}


class XTCommonPopup: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    public var popupType : PopupType = .COMMON
    
    public var onConfirm: (()->Void)?
    public var onCancel: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
    }

    private func setupButton() {
        if popupType == .COMMON {
            confirmButton.backgroundColor = XTColor.GREY_900.getColorWithString()
            confirmButton.setTitleColor(.white, for: [])
        } else {
            confirmButton.backgroundColor = XTColor.RED_600.getColorWithString()
            confirmButton.setTitleColor(.white, for: [])
        }
    }

    @IBAction func confirmBtnPressed(_ sender: Any) {
        guard let onConfirm = onConfirm else {
            return
        }
        guard let onCancel = onCancel else {
            return
        }

        self.dismiss(animated: true) {
            onCancel()
            onConfirm()
        }
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        guard let onCancel = onCancel else {
            return
        }

        onCancel()
        
        self.dismiss(animated: true)
    }
    
    static func create() -> XTCommonPopup {
      let controller = XTCommonPopup(nibName: "XTCommonPopup", bundle: nil)
      return controller
    }
}
