//
//  CCObjectExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension NSObject {
    
    class var stringClass : String {
        get {
            return NSStringFromClass(self);
        }
    }
    
    var stringValue : String {
        get {
            return String.init(format: "%@", self);
        }
    }
    
    var isNull : Bool {
        get {
            if self.isEqual(NSNull.init()) {
                return false;
            }
            return true;
        }
    }
    
}

func ccIsStringValuedC(_ string : Any?) -> Bool {
    guard (string != nil) else {
        return false;
    }
    
    let stringC = string as? String;
    if let stringT = stringC {
        return stringT.ccIsStringValued();
    }
    return false;
}

func ccIsArrayValued(_ array : Any?) -> Bool {
    guard (array != nil) else {
        return false;
    }
    
    let arrayC = array as? [Any];
    if let arrayT = arrayC {
        return arrayT.ccIsArrayValued();
    }
    return false;
}

func ccIsDictionaryValued(_ dictionary : Any?) -> Bool {
    guard (dictionary != nil) else {
        return false;
    }
    
    let dictionaryC = dictionary as? Dictionary<String, Any>;
    if let dictionaryT = dictionaryC {
        return dictionaryT.ccIsDictionaryValued();
    }
    return false;
}

func ccIsDecimalValued(_ decimal : Any?) -> Bool {
    guard (decimal != nil) else {
        return false;
    }
    
    let decimalC = decimal as? Decimal ;
    if let decimalT = decimalC {
        return decimalT.ccIsDecimalValued();
    }
    return false;
}

extension String {
    
    var isStringValued : Bool {
        get {
            if self.characters.count > 0 {
                return true;
            }
            return false;
        }
    }
    
    func ccIsStringValued() -> Bool {
        return self.isStringValued;
    }
    
}

extension Array {
    
    var isArrayValued : Bool {
        get {
            if self.count > 0 {
                return true;
            }
            return false;
        }
    }
    
    func ccIsArrayValued() -> Bool {
        return self.isArrayValued;
    }
    
}

extension Dictionary {
    
    var isDictionaryValued : Bool {
        get {
            if (self.keys.count > 0
                && self.values.count > 0
                && self.values.count == self.keys.count) {
                return true;
            }
            return false;
        }
    }
    
    func ccIsDictionaryValued() -> Bool {
        return self.isDictionaryValued;
    }
    
}

extension Decimal {
    
    var isDecimalValued : Bool {
        get {
            if (self.isNaN
                || self.isZero
                || self.isInfinite){
                return false;
            }
            return true;
        }
    }
    
    func ccIsDecimalValued() -> Bool {
        return self.isDecimalValued;
    }
    
}
