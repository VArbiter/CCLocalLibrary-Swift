//
//  CCScrollViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    convenience init(common frame : CGRect) {
        self.init(common: frame,
                  content: nil);
    }
    
    convenience init(common frame : CGRect ,
                     content size : CGSize? ) {
        self.init(common: frame, content: nil, delegate: nil);
    }
    
    convenience init(common frame : CGRect ,
                     content size : CGSize? ,
                     delegate : UIScrollViewDelegate?) {
        self.init(frame: frame);
        if let sizeT = size {
            self.contentSize = sizeT;
        } else {
            self.contentSize = self.frame.size;
        }
        if let delegateT = delegate {
            self.delegate = delegateT;
        }
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.bounces = false;
        self.isPagingEnabled = true;
        self.isDirectionalLockEnabled = true;
        self.backgroundColor = UIColor.clear;
        self.scrollsToTop = true;
        self.isScrollEnabled = true;
        self.isUserInteractionEnabled = true;
    }
    
}
