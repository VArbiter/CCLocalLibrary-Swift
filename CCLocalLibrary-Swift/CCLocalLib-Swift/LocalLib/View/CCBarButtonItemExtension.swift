//
//  CCBarButtonItemExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

private var _CC_ASSOCIATE_KEY_CLOSURE_CLICK : Void?;

extension UIBarButtonItem {
    
    var closureClick : ((UIBarButtonItem) -> Void)? {
        set (value) {
            objc_setAssociatedObject(self, &_CC_ASSOCIATE_KEY_CLOSURE_CLICK, value, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASSOCIATE_KEY_CLOSURE_CLICK) as? ((UIBarButtonItem) -> Void);
        }
    }
    
    convenience init(with imageName : String?) {
        self.init(with: imageName, clickAction: nil);
    }
    convenience init(with imageName : String? ,
                     clickAction closureClick : ((UIBarButtonItem) -> Void)?) {
        self.init(with: imageName, itemStyle: .plain, clickAction: closureClick);
    }
    convenience init(with imageName : String? ,
                     itemStyle style : UIBarButtonItemStyle ,
                     clickAction closureClick : ((UIBarButtonItem) -> Void)? ) {
        var image : UIImage? = nil;
        if let imageNameT = imageName {
            if imageNameT.isStringValued {
                image = UIImage.init(named: imageNameT)?.resizableImage(withCapInsets: .init(top: 0, left: 30, bottom: 0, right: 0));
            }
        }
        self.init(image: image, style: style, target: nil, action: nil);
        self.target = self;
        self.action = #selector(ccBarButtonAction(_:));
    }
    
    @objc private func ccBarButtonAction(_ sender : UIBarButtonItem) {
        CC_Safe_Closure(self.closureClick) {
            self.closureClick!(sender);
        };
    }
    
}
