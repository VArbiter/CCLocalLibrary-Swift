//
//  CCGestureRecognizerExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 20/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

private var _CC_ASOCIATE_KEY_GESTURE_CLOSURE_CLICK_ : Void?;

extension UIGestureRecognizer {
    
    var closureClick : ((UIGestureRecognizer) -> Void)? {
        set {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_GESTURE_CLOSURE_CLICK_, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_GESTURE_CLOSURE_CLICK_) as? ((UIGestureRecognizer) -> Void);
        }
    }
    
    @objc fileprivate func ccGestureAction(_ sender : UIGestureRecognizer) {
        CC_Safe_UI_Closure(self.closureClick) { 
            self.closureClick!(sender);
        }
    }
    
}

extension UITapGestureRecognizer {
    
    convenience init(closureClick : ((UIGestureRecognizer) -> Void)? ) {
        self.init(taps: 1, closureClick: closureClick);
    }
    
    convenience init(taps : Int , closureClick : ((UIGestureRecognizer) -> Void)? ) {
        self.init();
        self.numberOfTapsRequired = 1;
        self.closureClick = closureClick;
        self.addTarget(self, action: #selector(ccGestureAction(_:)));
    }
    
}

extension UILongPressGestureRecognizer {
    
    convenience init(closureClick : ((UIGestureRecognizer) -> Void)? ) {
        self.init();
        self.numberOfTapsRequired = 1;
        self.closureClick = closureClick;
        self.addTarget(self, action: #selector(ccGestureAction(_:)));
    }
    
}
