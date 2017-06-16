//
//  CCDecimalExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 15/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

extension Decimal {
    
    var ccTransferToString : String {
        get {
            return "\(self)";
        }
    }
    
    var ccRounding : String {
        get {
            return self.ccRoundingAfterPoint(_CC_DECIMAL_POINT_POSITION_);
        }
    }
    
    var ccRoundingDecimal : Decimal {
        get {
            return self.ccRoundingDecimalAfterPoint(_CC_DECIMAL_POINT_POSITION_);
        }
    }
    
    func ccRoundingF() -> String {
        return self.ccRounding;
    }
    func ccRoundingAfterPoint(_ position : Int16) -> String {
        return self.ccRoundingAfterPoint(position, roundMode: .plain);
    }
    func ccRoundingAfterPoint(_ position : Int16 ,roundMode mode : RoundingMode) -> String {
        return self.ccRoundingDecimalAfterPoint(position, roundMode: mode).ccTransferToString;
    }
    
    func ccRoundingDecimalF() -> Decimal {
        return self.ccRoundingDecimal;
    }
    func ccRoundingDecimalAfterPoint(_ position : Int16) -> Decimal {
        return self.ccRoundingDecimalAfterPoint(position, roundMode: .plain);
    }
    func ccRoundingDecimalAfterPoint(_ position : Int16, roundMode mode : RoundingMode) -> Decimal {
        let behavior : NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: mode,
                                                                            scale: position,
                                                                            raiseOnExactness: false,
                                                                            raiseOnOverflow: false,
                                                                            raiseOnUnderflow: false,
                                                                            raiseOnDivideByZero: false);
        let decimal : NSDecimalNumber = self as NSDecimalNumber;
        return decimal.rounding(accordingToBehavior: behavior) as Decimal;
    }
    
    func ccMuti(_ decimal : Decimal) -> Decimal? {
        if (self.isDecimalValued && decimal.isDecimalValued) {
            let decimalT = decimal as NSDecimalNumber ;
            return decimalT.multiplying(by: (self as NSDecimalNumber)) as Decimal;
        }
        return nil;
    }
    func ccDevide(_ decimal : Decimal) -> Decimal? {
        if (self.isDecimalValued && decimal.isDecimalValued) {
            guard !decimal.isZero else {
                CCLog("0 can't be treated as a divisor.");
                return nil;
            }
            let decimalT = decimal as NSDecimalNumber;
            return decimalT.dividing(by: (self as NSDecimalNumber), withBehavior: nil) as Decimal;
        }
        return nil;
    }
    
}
