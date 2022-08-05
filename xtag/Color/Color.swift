//
//  Color.swift
//  xtag
//
//  Created by Yoon on 2022/05/25.
//

import Foundation
import UIKit

struct XTColor {
    public static let BLUE_800 = "Blue800"
    public static let GREY_100 = "Grey100"
    public static let GREY_200 = "Grey200"
    public static let GREY_300 = "Grey300"
    public static let GREY_400 = "Grey400"
    public static let GREY_500 = "Grey500"
    public static let GREY_600 = "Grey600"
    public static let GREY_800 = "Grey800"
    public static let GREY_900 = "Grey900"
    public static let RED_600 = "Red600"
    public static let RED_700 = "Red700"
    public static let FLUORESCENT_YELLOW = "FluorescentYellow"
    public static let YELLOW_500 = "Yellow500"
}

extension String {
    func getColorWithString() -> UIColor {
        return UIColor(named: self) ?? UIColor.clear
        
    }
}
