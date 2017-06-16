//
//  CCDictionaryExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 15/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func ccDictionaryWith(_ stringJson : String?) -> Dictionary? {
        guard (stringJson != nil) else {
            CCLog("String has no effect value.");
            return nil;
        }
        
        let dataJson : Data? = stringJson?.data(using: .utf8);
        guard (dataJson != nil) else {
            CCLog("Transfer string to data failed.");
            return nil;
        }
        do {
            let dictionary : Dictionary? = try JSONSerialization.jsonObject(with: dataJson!, options: .mutableContainers) as? Dictionary;
            if let dictionaryT = dictionary {
                return dictionaryT;
            }
            return nil;
        } catch {
            CCLog("\(error)");
        }
        return nil;
    }
    
    mutating func ccSet(_ value : Dictionary.Value? , forKey key : Dictionary.Key?) {
        self.ccSet(value, forKey: key, observerChange: nil, complete: nil);
    }
    mutating func ccSet(_ value : Dictionary.Value? ,
                        forKey key : Dictionary.Key? ,
                        observerChange closureChange : ((AnyHashable , Any?) -> Void)?,
                        complete closureComplete : ((AnyHashable , Any? , [AnyHashable]? , [Any]?) -> Void)? ) { // key , value , allKeys , allValues
        if let keyT = key {
            if let valueT = value {
                self.updateValue(valueT, forKey: keyT)
            } else {
                self.removeValue(forKey: keyT);
            }
            
            if let closureChangeT = closureChange {
                closureChangeT(keyT , value);
            }
            if let closureCompleteT = closureComplete {
                closureCompleteT(keyT , value , Array(self.keys) , Array(self.values));
            }
        }
    }
    
}
