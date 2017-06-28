//
//  CCTimeIntervalExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var ccTimeSince1970 : String {
        get {
            let date : Date = Date.init(timeIntervalSince1970: self);
            let formatter : DateFormatter = DateFormatter.init();
            formatter.dateFormat = "yyyy-MM-dd HH:mm";
            return formatter.string(from: date);
        }
    }
    
    
}
