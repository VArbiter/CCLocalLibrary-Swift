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
                    return firstWeekdayT - 1; // 0...6 (as index)
                }
                return nil;
            }
            return nil;
        }
    }
    
    var ccDay : Int? {
        get {
            return Calendar.current.dateComponents([.year , .month , .day], from: self).day;
        }
    }
    
    var ccDateWeekDay : Int? {
        get {
            let weekDay : Int? = self.ccFirstWeekdayInThisMonth;
            let day : Int? = self.ccDay;
            
            guard (weekDay != nil && day != nil) else {
                CCLog("Optional variable ccDateWeekDay can't be nil.");
                return nil;
            }
            
            var currentWeekNum : Int = (day! + weekDay! - 1) % 7;
            if currentWeekNum == 0 {
                currentWeekNum = 7;
            }
            return currentWeekNum;
        }
    }
    
    var ccWeekDay : String? {
        get {
            let weekDay : Int? = self.ccDateWeekDay;
            guard (weekDay != nil) else {
                CCLog("Optional variable ccWeekDay can't be nil.");
                return nil;
            }
            
            switch weekDay! {
            case 1:
                return ccLocalizeString("_CC_MON_", "一");
            case 2:
                return ccLocalizeString("_CC_TUE_", "二");
            case 3:
                return ccLocalizeString("_CC_WEN_", "三");
            case 4:
                return ccLocalizeString("_CC_THUR_", "四");
            case 5:
                return ccLocalizeString("_CC_FRI_", "五");
            case 6:
                return ccLocalizeString("_CC_SAT_", "六");
            case 7:
                return ccLocalizeString("_CC_SUN_", "七");
                
            default:
                let formatter : DateFormatter = DateFormatter.init();
                formatter.dateFormat = "yyyy-MM-dd HH:mm";
                let date : Date? = formatter.date(from: "\(self)");
                if let dateT = date {
                    return "\(dateT)";
                } else {
                    return nil;
                }
            }
        }
    }
    
    func ccFirstWeekdayInThisMonthF() -> Int? {
        return self.ccFirstWeekdayInThisMonth;
    }
    func ccDayF() -> Int? {
        return self.ccDay;
    }
    func ccDateWeekDayF() -> Int? {
        return self.ccDateWeekDay;
    }
}
