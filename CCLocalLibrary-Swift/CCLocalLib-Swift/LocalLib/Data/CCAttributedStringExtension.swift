//
//  CCAttributedStringExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    class func ccAttributeWith(_ color : UIColor? ,withString string : String?) -> NSMutableAttributedString? {
        if let stringT = string {
            guard stringT.isStringValued else {
                return nil;
            }
            if let colorT = color {
                return NSMutableAttributedString.init(string: stringT,
                                                      attributes: [NSForegroundColorAttributeName : colorT]);
            } else {
                return NSMutableAttributedString.init(string: stringT);
            }
        }
        return nil;
    }
    
    func ccMAppend(_ attributedString : NSAttributedString?) -> NSMutableAttributedString? {
        if let attributedStringT = attributedString {
            if attributedStringT.isAttributedStringValued {
                self.append(attributedStringT);
            }
            return self;
        }
        return self;
    }
    
}

extension NSAttributedString {
    
    var isAttributedStringValued : Bool {
        get {
            return self.length > 0;
        }
    }
    
    func ccAppend(_ attributedString : NSAttributedString?) -> NSAttributedString? {
        if let attributedStringT = attributedString {
            if attributedStringT.isAttributedStringValued {
                if let attributedStringM = (self.mutableCopy() as? NSMutableAttributedString) {
                    attributedStringM.append(attributedStringT);
                    return attributedStringM;
                }
                return self;
            }
            return self;
        }
        return self;
    }
    
}
