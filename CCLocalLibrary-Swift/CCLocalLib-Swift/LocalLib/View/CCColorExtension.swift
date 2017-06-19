//
//  CCColorExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 19/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UIColor {
    
    var imageColor : UIImage? {
        get {
            return UIImage.ccImage(self);
        }
    }
    
    func ccImageColor() -> UIImage? {
        return self.imageColor;
    }
    
}
