//
//  CCImagePickerControllerExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 20/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

private var _CC_ASOCIATE_KEY_IMAGEPICKER_COMPLETE_CLOSURE_ : Void?;
private var _CC_ASOCIATE_KEY_IMAGEPICKER_ERROR_CLOSURE_ : Void?;
private var _CC_ASOCIATE_KEY_IMAGEPICKER_CANCEL_CLOSURE_ : Void?;

extension UIImagePickerController : UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    enum CCImagePickerSupportType : Int {
        case nonee = 0 , all , camera , photoLibrary , photosAlbum
    }
    
    enum CCImagePickerPresentType : Int {
        case nonee , camera , photoLibrary , photosAlbum
    }
    
    enum CCImageSaveType : Int {
        case nonee = 0 , original , edited , all
    }
    
    typealias ClosureError = ((NSError) -> Void)?;
    /// original , edited , cropRect , support types (if images exists) / unsupport types (images are not exist).
    typealias ClousreComplete = ((UIImage , UIImage , CGRect , Array<CCImagePickerSupportType>) -> CCImageSaveType?)?;
    typealias ClousreCancel = (() -> Void)?;
    
    private var closureComplete : ClousreComplete {
        set {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_COMPLETE_CLOSURE_, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_COMPLETE_CLOSURE_) as? ((UIImage, UIImage, CGRect, Array<UIImagePickerController.CCImagePickerSupportType>) -> UIImagePickerController.CCImageSaveType?)
        }
    }
    private var closureError : ClosureError {
        set {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_ERROR_CLOSURE_, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_ERROR_CLOSURE_) as? ((NSError) -> Void);
        }
    }
    private var closureCancel : ClousreCancel {
        set {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_CANCEL_CLOSURE_, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_CANCEL_CLOSURE_) as? (() -> Void);
        }
    }
    
    /// support types (if images exists) / unsupport types (images are not exist)
    private func ccSupportType() -> Array<CCImagePickerSupportType> {
        
    }
    
    convenience init(present type : CCImagePickerPresentType ,
                     complete closureComplete : ClousreComplete ,
                     cancel closureCancel : ClousreCancel ,
                     saveError closureError : ClosureError) {
        
    }

}
