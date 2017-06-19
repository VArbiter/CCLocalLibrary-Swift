//
//  CCCommonDefine.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 15/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

enum CCViewEndLoadType : Int {
    case nonee = 0, end , noMoreData , endRefresh , manualEnd
}

enum CCImageType : Int {
    case nonee = 0, jpeg , png , unknow
}

let _CC_DECIMAL_POINT_POSITION_ : Int16 = 2;

let _CC_DEFAULT_FONT_SIZE_ : CGFloat = 11.0;
let _CC_DEFAULT_FONT_TITLE_SIZE_ : CGFloat = 13.0;
let _CC_SYSTEM_FONT_SIZE_ : CGFloat = 17.0;

let _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ : CGFloat = 400.0;
let _CC_IMAGE_JPEG_COMPRESSION_QUALITY_ : CGFloat = 1.0;
let _CC_GAUSSIAN_BLUR_VALUE_ : Double = 0.0;
let _CC_GAUSSIAN_BLUR_TINT_ALPHA_ : CGFloat = 0.25;
