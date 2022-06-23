//
//  UITableView+Extension.swift
//  balance
//
//  Created by 윤종서 on 2021/07/14.
//

import UIKit

extension UITableView {
    
    func nextResponder(index: Int){
//        print("Tag", index)
        var currIndex = index
//        for i in index+1..<index+100{
            if let view = self.superview?.superview?.viewWithTag(index + 1){
                
                (view as! CustomPicker).textField.becomeFirstResponder()
                
                view.backgroundColor = #colorLiteral(red: 0.595538497, green: 0.9845094085, blue: 0.6062263846, alpha: 0.5)
//                view.borderColor = .red
//                view.borderwidth = 3
//                currIndex = i
//                break
            }
//        }
        
        let ind = IndexPath(row: Int(currIndex / 2), section: 0)
        if let nextCell = self.cellForRow(at: ind){
            self.scrollRectToVisible(nextCell.frame, animated: true)
        }
    }
    
    func keyboardRaised(height: CGFloat){
        self.contentInset.bottom = height
        self.scrollIndicatorInsets.bottom = height
    }
    
    func keyboardClosed(){
        self.contentInset.bottom = 0
        self.scrollIndicatorInsets.bottom = 0
        self.scrollRectToVisible(CGRect.zero, animated: true)
    }
    
}
