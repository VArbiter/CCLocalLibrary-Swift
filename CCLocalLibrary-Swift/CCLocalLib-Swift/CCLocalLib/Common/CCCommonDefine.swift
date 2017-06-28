//
//  CCCommonDefine.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 15/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import UIKit

enum CCViewEndLoadType : Int {
    case nonee = 0, end , noMoreData , endRefresh , manualEnd
}

var _CC_IS_SIMULATOR_ : Bool {
    get {
        if TARGET_OS_SIMULATOR > 0{
            return true;
        }
        return false;
    }
}

typealias CC_Closure_T = (() -> Void)

/// Set "DEBUG" in the "Swift Compiler - Custom Flags" section,
/// "Other Swift Flags" line. 
/// Then add the DEBUG symbol with the -D DEBUG entry.

var _CC_DEBUG_MODE_ : Bool {
    get {
#if DEBUG
    return true;
#else
    return false;
#endif
    }
}

let _CC_DECIMAL_POINT_POSITION_ : Int16 = 2;

let _CC_DEFAULT_FONT_SIZE_ : CGFloat = 11.0;
let _CC_DEFAULT_FONT_TITLE_SIZE_ : CGFloat = 13.0;
let _CC_SYSTEM_FONT_SIZE_ : CGFloat = 17.0;

let _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ : CGFloat = 400.0; // kb
let _CC_IMAGE_JPEG_COMPRESSION_QUALITY_ : CGFloat = 1.0;
let _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SCALE_ : CGFloat = 0.1;

let _CC_GAUSSIAN_BLUR_VALUE_ : Double = 4;
let _CC_GAUSSIAN_BLUR_ITERATION_COUNT_ : Int = 2;
let _CC_GAUSSIAN_BLUR_TINT_ALPHA_ : CGFloat = 0.25;

let _CC_NAVIGATION_ITEM_OFFSET_DEFAULT_ : CGFloat = -16.0;

let _CC_ANIMATION_COMMON_DURATION_ : TimeInterval = 0.3;
let _CC_ANIMATION_FAST_DURATION_ : TimeInterval = 0.05;
let _CC_PROGRESS_TIMER_INTERVAL_ : TimeInterval = 0.05;

let _CC_ALERT_DISSMISS_COMMON_DURATION_ : TimeInterval = 2.0;

let _CC_NAVIGATION_BAR_HEIGHT_ : Double = 44.0;
let _CC_NAVIGATION_HEIGHT_ : Double = 64.0;
let _CC_TABBAR_HEIGHT_ : Double = 49.0;
