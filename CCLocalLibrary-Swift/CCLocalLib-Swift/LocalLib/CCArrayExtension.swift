//
//  CCArrayExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

extension Array {
    
    func ccValueAt(_ index : Int) -> Any? {
        if self.isArrayValued {
            if self.count > index {
                return self[index];
            }
        }
        return nil;
    }
    
    func ccValueAt(_ index : Int, closure : @escaping (_ item : Any) -> Void) {
        if self.isArrayValued {
            if self.count > index {
                closure(self[index]);
            }
        }
    }
    
}
