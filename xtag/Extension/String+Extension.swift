//
//  String+Extension.swift
//  balance
//
//  Created by 윤종서 on 2021/04/06.
//

import UIKit

extension String {
    
    // func
    // validateEmail : email 형식 (@ . 포함 여부) 체크
    
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    func removeAllWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension String {
    func getRatioRx() -> Int {
        let splitString = self.split(separator: ":")
        let rx = Int(String(splitString[0]))
        let ry = Int(String(splitString[1]))
        
        return rx!
    }
    
    func getRatioRy() -> Int {
        let splitString = self.split(separator: ":")
        let rx = Int(String(splitString[0]))
        let ry = Int(String(splitString[1]))
        
        return ry!
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
