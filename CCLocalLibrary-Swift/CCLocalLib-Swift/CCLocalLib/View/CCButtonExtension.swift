//
//  CCButtonExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

private var _CC_ASOCIATE_KEY_BUTTON_CLOSURE_CLICK_ : Void?;

extension UIButton {
    
    var closureClickP : ((UIButton) -> Void)? {
        set (value) {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_BUTTON_CLOSURE_CLICK_, value, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_BUTTON_CLOSURE_CLICK_) as? ((UIButton) -> Void);
        }
    }
    
    convenience init(system frame: CGRect?) {
        self.init(with: frame, itemType: .system, image: nil, clickAction: nil);
    }
    
    convenience init(custom frame: CGRect?) {
        self.init(with: frame, itemType: .custom, image: nil, clickAction: nil);
    }
    
    convenience init(system frame: CGRect? , clickAction closureClick : ((UIButton) -> Void)?) {
        self.init(with: frame, itemType: .system, image: nil, clickAction: closureClick);
    }
    
    convenience init(custom frame: CGRect? , clickAction closureClick : ((UIButton) -> Void)?) {
        self.init(with: frame, itemType: .custom, image: nil, clickAction: closureClick);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     image stringImageName : String? ,
                     clickAction closureClick : ((UIButton) -> Void)? ){
        self.init(with: frame,
                  itemType: type,
                  normalImage: stringImageName,
                  selectedImage: nil,
                  clickAction: closureClick);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     normalImage stringNormalImageName : String? ,
                     selectedImage stringSelectedImageName : String? ){
        self.init(with: frame,
                  itemType: type,
                  normalImage: stringNormalImageName,
                  selectedImage: stringSelectedImageName,
                  clickAction: nil);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     title stringTitle : String?,
                     clickAction closureClick : ((UIButton) -> Void)?) {
        self.init(with: frame,
                  itemType: type,
                  normalTitle: stringTitle,
                  selectedTitle: nil,
                  clickAction: closureClick);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     normalImage stringNormalImageName : String? ,
                     selectedImage stringSelectedImageName : String? ,
                     clickAction closureClick : ((UIButton) -> Void)? ){
        self.init(with: frame,
                  itemType: type,
                  normalTitle: nil,
                  selectedTitle: nil,
                  normalImage: stringNormalImageName,
                  selectedImage: stringSelectedImageName,
                  clickAction: closureClick);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     normalTitle stringNormalTitle : String?,
                     selectedTitle stringSelectedTitle : String?) {
        self.init(with: frame,
                  itemType: type,
                  normalTitle: stringNormalTitle,
                  selectedTitle: stringSelectedTitle,
                  clickAction: nil);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     normalTitle stringNormalTitle : String?,
                     selectedTitle stringSelectedTitle : String?,
                     clickAction closureClick : ((UIButton) -> Void)?) {
        self.init(with: frame,
                  itemType: type,
                  normalTitle: stringNormalTitle,
                  selectedTitle: stringSelectedTitle,
                  normalImage: nil,
                  selectedImage: nil,
                  clickAction: closureClick);
    }
    
    convenience init(with frame : CGRect? ,
                     itemType type : UIButtonType ,
                     normalTitle stringNormalTitle : String?,
                     selectedTitle stringSelectedTitle : String? ,
                     normalImage stringNormalImageName : String? ,
                     selectedImage stringSelectedImageName : String? ,
                     clickAction closureClick : ((UIButton) -> Void)? ) {
        self.init(with: frame,
                  itemType: type,
                  normalTitle: stringNormalTitle,
                  selectedTitle: stringSelectedTitle,
                  normalImage: stringNormalImageName,
                  selectedImage: stringSelectedImageName);
        self.closureClickP = closureClick;
        self.addTarget(self,
                       action: #selector(ccButtonAction(_:)),
                       for: .touchUpInside)
    }
    
    convenience init (with frame : CGRect? ,
                      itemType type : UIButtonType ,
                      normalTitle stringNormalTitle : String?,
                      selectedTitle stringSelectedTitle : String? ,
                      normalImage stringNormalImageName : String? ,
                      selectedImage stringSelectedImageName : String? ) {
        self.init(type: type);
        self.titleLabel?.font = UIFont.systemFont(ofSize: _CC_DEFAULT_FONT_SIZE_);
        self.backgroundColor = UIColor.clear;
        if let frameT = frame {
            self.frame = frameT;
        }
        if let stringNormalTitleT = stringNormalTitle {
            self.setTitle(stringNormalTitleT, for: .normal);
        }
        if let stringSelectedTitleT = stringSelectedTitle {
            self.setTitle(stringSelectedTitleT, for: .selected);
        }
        if let stringNormalImageNameT = stringNormalImageName {
            if let image = ccImage(stringNormalImageNameT) {
                self.setImage(image, for: .normal);
            }
        }
        if let stringSelectedImageNameT = stringSelectedImageName {
            if let image = ccImage(stringSelectedImageNameT) {
                self.setImage(image, for: .selected);
            }
        }
    }
    
    @objc private func ccButtonAction(_ sender : UIButton) {
        CC_Safe_UI_Closure(self.closureClickP) {
            self.closureClickP!(sender);
        }
    }
    
}
