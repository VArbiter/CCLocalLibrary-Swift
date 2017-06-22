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
    
    typealias ClosureError = ((NSError?) -> Void)?;
    /// original , edited , cropRect , support types (if images exists) / unsupport types (images are not exist).
    typealias ClousreComplete = ((UIImage? , UIImage? , CGRect? , [CCImagePickerSupportType]) -> CCImageSaveType?)?;
    typealias ClousreCancel = (() -> Void)?;
    
    private var closureComplete : ClousreComplete {
        set {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_COMPLETE_CLOSURE_, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_COMPLETE_CLOSURE_) as? ((UIImage?, UIImage?, CGRect?, [CCImagePickerSupportType]) -> CCImageSaveType?)
        }
    }
    private var closureError : ClosureError {
        set {
            objc_setAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_ERROR_CLOSURE_, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASOCIATE_KEY_IMAGEPICKER_ERROR_CLOSURE_) as? ((NSError?) -> Void);
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
    private class func ccSupportType() -> [CCImagePickerSupportType] {
        if (!CCCommonTools.isAllowAccessToAlbum || !CCCommonTools.isAllowAccessToCamera) {
            return [.nonee];
        }
        var array : [CCImagePickerSupportType] = [];
        if self.isSourceTypeAvailable(.photoLibrary) {
            array.append(.photoLibrary);
        }
        if self.isSourceTypeAvailable(.savedPhotosAlbum) {
            array.append(.photosAlbum);
        }
        if self.isSourceTypeAvailable(.camera) {
            array.append(.camera);
        }
        if array.count == 3 {
            return [.all];
        }
        else if array.count == 0 {
            return [.nonee];
        }
        return array;
    }
    
    convenience init?(complete closureComplete : ClousreComplete) {
        self.init(present: .photosAlbum,
                  complete: closureComplete,
                  cancel: nil,
                  saveError: nil)
    }
    
    convenience init?(present type : CCImagePickerPresentType ,
                     complete closureComplete : ClousreComplete ,
                     cancel closureCancel : ClousreCancel ,
                     saveError closureError : ClosureError) {
        let arraySupport = UIImagePickerController.ccSupportType();
        if arraySupport.contains(.nonee) {
            CC_Safe_UI_Closure(closureComplete, { 
                let _ = closureComplete!(nil , nil , nil , arraySupport);
            });
            return nil;
        }
        self.init();
        
        let isSupportAll : Bool = arraySupport.contains(.all);
        var typeUnsupport : CCImagePickerSupportType = .nonee;
        
        switch type {
        case .camera:
            if (isSupportAll || arraySupport.contains(.camera)) {
                self.sourceType = .camera;
                self.cameraCaptureMode = .photo;
                self.showsCameraControls = true;
            } else {
                typeUnsupport = .camera;
            }
        case .photosAlbum:
            if (isSupportAll || arraySupport.contains(.photosAlbum)) {
                self.sourceType = .savedPhotosAlbum;
            } else {
                typeUnsupport = .photosAlbum;
            }
        case .photoLibrary:
            if (isSupportAll || arraySupport.contains(.photoLibrary)) {
                self.sourceType = .photoLibrary;
            } else {
                typeUnsupport = .photoLibrary;
            }
        default:
            return nil;
        }
        
        if typeUnsupport.rawValue > 0 {
            CC_Safe_UI_Closure(closureComplete, {
                let _ = closureComplete!(nil , nil , nil , arraySupport);
            });
            return nil;
        }
        
        self.delegate = self;
        self.allowsEditing = true;
        self.closureComplete = closureComplete;
        self.closureCancel = closureCancel;
        self.closureError = closureError;
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        CC_Safe_UI_Closure(self.closureComplete) {
            if let typeSaveT = self.closureComplete!(info["UIImagePickerControllerOriginalImage"] as? UIImage,
                                                     info["UIImagePickerControllerEditedImage"] as? UIImage,
              info["UIImagePickerControllerCropRect"] as? CGRect,
                                                                   UIImagePickerController.ccSupportType()) {
                
                let closureOriginal = {
                    UIImageWriteToSavedPhotosAlbum(info["UIImagePickerControllerOriginalImage"] as! UIImage,
                                                   self,
                                                   #selector(self.image(_:didFinishSavingWith:contextInfo:)),
                                                   nil);
                }
                let closureEdited = {
                    UIImageWriteToSavedPhotosAlbum(info["UIImagePickerControllerOriginalImage"] as! UIImage,
                                                   self,
                                                   #selector(self.image(_:didFinishSavingWith:contextInfo:)),
                                                   nil);
                }
                
                switch typeSaveT {
                case .original:
                    closureOriginal();
                case .edited:
                    closureEdited();
                case .all:
                    closureOriginal();
                    closureEdited();
                default:
                    return ;
                }
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        CC_Safe_UI_Closure(self.closureCancel) { 
            self.closureCancel!();
        }
    }
    
    @objc private func image(_ image : UIImage , didFinishSavingWith error : NSError? , contextInfo : UnsafeMutableRawPointer?) {
        if let errorT = error {
            CC_Safe_UI_Closure(self.closureError, { 
                self.closureError!(errorT);
            })
        }
    }

}
