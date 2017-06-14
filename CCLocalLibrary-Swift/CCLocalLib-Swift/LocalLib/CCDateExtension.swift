//
//  CCDateExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

extension Date {
    
    var ccFirstWeekdayInThisMonth : Int? {
        get {
            var calender : Calendar = Calendar.current;
            calender.firstWeekday = 1; //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
            var comp : DateComponents = calender.dateComponents([.year , .month , .day], from: self);
            comp.day = 1;
            let firstDayOfMonthDate : Date? = calender.date(from: comp);
            if let firstDayOfMonthDateT = firstDayOfMonthDate {
                let firstWeekday : Int? = calender.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDateT);
                if let firstWeekdayT = firstWeekday {
                    return firstWeekdayT - 1;
                }
                return nil;
            }
            return nil;
        }
    }
    
    func ccFirstWeekdayInThisMonthF() -> Int? {
        return self.ccFirstWeekdayInThisMonth;
    }
}
