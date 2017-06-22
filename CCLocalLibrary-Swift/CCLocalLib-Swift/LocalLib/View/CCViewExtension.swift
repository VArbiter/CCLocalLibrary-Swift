//
//  CCViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UIView {
    
    var size : CGSize {
        set {
            var frame : CGRect = self.frame;
            frame.size = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size;
        }
    }
    var origin : CGPoint {
        set {
            var frame : CGRect = self.frame;
            frame.origin = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin;
        }
    }
    
    var width : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.size.width = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size.width
        }
    }
    var height : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.size.height = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size.height;
        }
    }
    
    var x : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.origin.x = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin.x;
        }
    }
    var y : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.origin.y = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin.y;
        }
    }
    
    var centerX : CGFloat {
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y);
        }
        get {
            return self.center.x;
        }
    }
    var centerY : CGFloat {
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue);
        }
        get {
            return self.center.y;
        }
    }
    
    var inCenterX : CGFloat {
        get {
            return self.frame.size.width * 0.5;
        }
    }
    var inCenterY : CGFloat {
        get {
            return self.frame.size.height * 0.5;
        }
    }
    var inCenter : CGPoint {
        get {
            return CGPoint.init(x: self.frame.size.width * 0.5,
                                y: self.frame.size.height * 0.5);
        }
    }
    
    var top : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.origin.y = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin.y;
        }
    }
    var left : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.origin.x = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin.x;
        }
    }
    var bottom : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.origin.y = newValue - self.frame.size.height;
            self.frame = frame;
        }
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
    }
    var right : CGFloat {
        set {
            var frame : CGRect = self.frame;
            frame.origin.x = newValue - self.frame.size.width;
            self.frame = frame;
        }
        get {
            return self.frame.origin.x + self.frame.size.width;
        }
    }
    
    class func ccViewFromXib() -> Any? {
        return self.ccViewFromXib(with: nil);
    }
    class func ccViewFromXib(with bundle : Bundle?) -> Any? {
        var bundleR : Bundle = Bundle.main;
        if let bundleT = bundle {
            bundleR = bundleT;
        }
        return bundleR.loadNibNamed("\(self)", owner: nil, options: nil)?.first;
    }
    
    func ccAddTapGesture(action closure : (() -> Void)? ) {
        self.ccAddTapGesture(taps: 1,
                             action: closure);
    }
    func ccAddTapGesture(taps count : Int ,
                         action closure : (() -> Void)? ) {
        self.isUserInteractionEnabled = true;
        let tapGR : UITapGestureRecognizer = UITapGestureRecognizer.init(taps: count) { (sender) in
            CC_Safe_UI_Closure(closure, { 
                closure!();
            })
        }
        self.addGestureRecognizer(tapGR);
    }
    
}
