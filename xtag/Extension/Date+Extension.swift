//
//  Date+Extension.swift
//  balance
//
//  Created by 홍필화 on 2021/05/27.
//

import UIKit

extension Date
{
    mutating func addDays(n: Int)
    {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth(month: Date) -> Date {
        return Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year,.month], from: month))!
    }

    
    func getAllDays() -> [Date] {
        var days = [Date]()
        
        let calendar = Calendar.current
//        let pastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
//        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
//        print("calendar: \(calendar) pastMonth \(pastMonth) nextMonth\(nextMonth)")
//
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        
//        print("range: \(range)")
        
        var day = firstDayOfTheMonth(month: self)
        
        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }
//        print("days: \(days)")
        return days
    }
    
    
}


