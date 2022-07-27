//
//  UIAlertAction+Extension.swift
//  xtag
//
//  Created by Yoon on 2022/07/20.
//

import Foundation
import UIKit
extension UIAlertAction {
    var titleTextColor: UIColor? {
        get { return self.value(forKey: "titleTextColor") as? UIColor }
        set { self.setValue(newValue, forKey: "titleTextColor") }
    }
    
    var titleAttributedTextWithFont: NSMutableAttributedString? {
        get { return self.value(forKey: "attributedTitle") as? NSMutableAttributedString}
        set { self.setValue(newValue, forKey: "attributedTitle") }
    }
}

extension UIAlertController{
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for i in self.actions {
            let attributedText = NSMutableAttributedString(string: "신고", attributes: [
                .font: UIFont(name: XTFont.PRETENDARD_EXTRABOLD, size: 13)!,
                .foregroundColor: XTColor.GREY_500.getColorWithString(),
                
            ])

            guard let label = (i.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            label.attributedText = attributedText
        }

    }

    
}
