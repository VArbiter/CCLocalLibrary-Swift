//
//  CCStringExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var ccDecimalValue : Decimal? {
        get {
            if self.isStringValued {
                let decimalNumber : Decimal? = Decimal.init(string: self);
                if let decimalNumberT = decimalNumber {
                    if decimalNumberT.isDecimalValued {
                        return decimalNumberT;
                    }
                    return nil;
                }
                return nil;
            }
            return nil;
        }
    }
    
    var ccTimeStick : String? {
        get {
            let formatter : DateFormatter = DateFormatter.init();
            formatter.dateFormat = "yyyy-MM-dd HH:mm";
            if let dateT = formatter.date(from: self) {
                let interval : TimeInterval = dateT.timeIntervalSince(dateT);
                if ((interval / (60 * 60 * 24 * 30)) >= 1) {
                    return formatter.string(from: dateT);
                }
                if ((interval / (60 * 60 * 24)) >= 1) {
                    return "\(interval / (60 * 60 * 24)) " + ccLocalizeString("_CC_DAYS_AGO_", "天前");
                }
                if (interval / 60 * 60) >= 1 {
                    return "\(interval / 60 * 60) " + ccLocalizeString("_CC_HOURS_AGO_", "小时前");
                }
                if (interval / 60) > 1{
                    return "\(interval / 60) " + ccLocalizeString("_CC_MINUTES_AGO_", "分钟前");
                }
                return ccLocalizeString("_CC_AGO_", "刚刚");
            }
            return nil;
        }
    }
    
    var ccIntDays : Int? {
        get {
            let formatter : DateFormatter = DateFormatter.init();
            formatter.dateFormat = "yyyy-MM-dd HH:mm";
            if let dateT = formatter.date(from: self) {
                return Int(dateT.timeIntervalSince(dateT) / (60 * 60 * 24));
            }
            return nil;
        }
    }
    
    var ccTimeStickWeekDays : String? {
        get {
            let formatter : DateFormatter = DateFormatter.init();
            formatter.dateFormat = "yyyy-MM-dd HH:mm";
            if let dateT = formatter.date(from: self) {
                return dateT.ccWeekDay;
            }
            return nil;
        }
    }
    
    var ccDate : Date? {
        get {
            let formatter : DateFormatter = DateFormatter.init();
            formatter.dateFormat = "yyyy-MM-dd HH:mm";
            return formatter.date(from: self);
        }
    }
    
    var ccMD5Encrypted : String? {
        get {
            guard self.isStringValued else {
                return nil;
            }
            
            if let c = self.cString(using: .utf8) {
                let stringLength : CUnsignedInt = CUnsignedInt(self.lengthOfBytes(using: .utf8));
                let digstLength : Int = Int(CC_MD5_DIGEST_LENGTH);
                let md5 : UnsafeMutablePointer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digstLength);
                CC_MD5(c, stringLength, md5);
                var stringResult : String = "";
                for i in 0..<digstLength {
                    stringResult = stringResult.appendingFormat("%02x", md5[i]);
                }
                md5.deinitialize();
                return stringResult;
            }
            return nil;
        }
    }
    
    var ccMAttributeString : NSMutableAttributedString? {
        get {
            if self.isStringValued {
                return NSMutableAttributedString.init(string: self);
            }
            return nil;
        }
    }
    
    func ccMAttributeStringWith(_ color : UIColor?) -> NSMutableAttributedString? {
        if let colorT = color {
            return NSMutableAttributedString.ccAttributeWith(colorT, withString: self);
        }
        return self.ccMAttributeString;
    }
    
}

/// Use file name to find , return the first file that be found , nil if not
extension String {
    /// Functions below , unavailable with images in Assets.xcassets.
    
    /// Search with main Bundle .
    var ccPath : String? {
        get {
            return self.ccPathF(nil, type: nil);
        }
    }
    
    /// Search with sandbox .
    var ccPathS : String? {
        get {
            return String.ccPathSandBox(NSHomeDirectory(), fileName: self)?.first;
        }
    }
    
    var ccData : Data? {
        get {
            if let pathT = self.ccPath {
                if let urlT = ccURL(pathT, true) {
                    do {
                        return try Data.init(contentsOf:urlT);
                    }
                    catch {
                        CCLog(error);
                    }
                }
            }
            return nil;
        }
    }
    
    /// Search with specific bundle
    func ccPathF(_ bundle : Bundle? , type : String?) -> String? {
        let bundleR : Bundle? = bundle;
        if let bundleT = bundleR {
            return bundleT.path(forResource: self, ofType: type);
        }
        return Bundle.main.path(forResource: self, ofType: type);
    }
    
    /// Search with sand box
    func ccPathSandBox() -> String? {
        return String.ccPathSandBox(nil, fileName: self)?.first;
    }
    
    static func ccPathSandBox(_ stringPath : String? , fileName stringName : String) -> [String]? {
        var stringPathR : String? = stringPath;
        if stringPathR == nil {
            stringPathR = NSHomeDirectory();
        }
        var array : [String] = [];
        let fileManager : FileManager = FileManager.default;
        if let arrayT = fileManager.subpaths(atPath: stringPathR!) {
            for (_ , itemPath) in arrayT.enumerated() {
                if let directoryEnumeratorT = fileManager.enumerator(atPath: itemPath) {
                    for item in directoryEnumeratorT.allObjects {
                        if stringName.compare(item as! String) == ComparisonResult.orderedSame {
                            array.append(itemPath.appending(item as! String));
                        }
                    }
                }
            }
            return array;
        }
        return nil;
    }
    
}
