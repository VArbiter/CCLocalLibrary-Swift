//
//  CCNavigationItemExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

private var _CC_ASOCIATE_KEY_ITEM_OFFSET_ : Void?;

extension UINavigationItem {
    
    func ccOffsetL(item : UIBarButtonItem) {
        self.ccOffset(spacing: _CC_NAVIGATION_ITEM_OFFSET_DEFAULT_,
                      item: item,
                      left: true);
    }
    func ccOffsetR(item : UIBarButtonItem) {
        self.ccOffset(spacing: _CC_NAVIGATION_ITEM_OFFSET_DEFAULT_,
                      item: item,
                      left: false);

    }
    
    func ccOffset(spacing offset : CGFloat ,
                  item : UIBarButtonItem ,
                  left isLeft : Bool) {
        if isLeft {
            self.setLeftBarButtonItems(item.ccArrayItems(width: offset),
                                       animated: false);
        } else {
            self.setRightBarButtonItems(item.ccArrayItems(width: offset),
                                        animated: false);
        }
    }
    
}


extension UIBarButtonItem {
    
    fileprivate func ccArrayItems(width : CGFloat) -> [UIBarButtonItem] {
        var widthT = width;
        if widthT >= 0 {
            widthT = _CC_NAVIGATION_ITEM_OFFSET_DEFAULT_;
        }
        let item : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace,
                                                          target: nil,
                                                          action: nil);
        item.width = widthT;
        return [item,self];
    }
    
}
