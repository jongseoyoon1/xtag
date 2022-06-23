//
//  UITabBar+extension.swift
//  balance
//
//  Created by 윤종서 on 2021/03/18.
//

import UIKit

// func
// clearShadow : 기본 탭바 스타일 초기화

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
}
