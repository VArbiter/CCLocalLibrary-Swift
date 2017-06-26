//
//  CCViewControllerExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func ccDismiss(alertController : UIAlertController? , after delay : Double) {
        self.ccDismiss(alertController: alertController, after: delay, complete: nil);
    }
    func ccDismiss(alertController : UIAlertController? ,
                   after delay : Double ,
                   complete closureComplete : CC_Closure_T? ) {
        guard alertController != nil else {
            return ;
        }
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                alertController?.dismiss(animated: true, completion: closureComplete);
            });
        } else {
            alertController?.dismiss(animated: true,
                                     completion: closureComplete);
        }
    }
    
    class func ccGetCurrentController() -> UIViewController? {
        if let controllerT = self.ccGetCurrentViewController() {
            return controllerT;
        }
        if let controllerRT = self.ccGetCurrentModalController() {
            return controllerRT;
        }
        return nil;
    }
    private class func ccGetCurrentViewController() -> UIViewController? {
        var window : UIWindow? = UIApplication.shared.keyWindow;
        if window?.windowLevel != UIWindowLevelNormal {
            for item in UIApplication.shared.windows {
                if item.windowLevel == UIWindowLevelNormal {
                    window = item;
                    break;
                }
            }
        }
        let viewFront : UIView? = window?.subviews.first;
        let controller : Any? = viewFront?.next;
        
        if "\(UIViewController.self)".compare("\(Mirror.init(reflecting: controller!).subjectType)") == .orderedSame {
            return controller as? UIViewController;
        }
        return window?.rootViewController;
    }
    
    func ccPush(controller : UIViewController!) {
        self.ccPush(controller: controller, isAnimated: true);
    }
    func ccPush(controller : UIViewController!, isAnimated : Bool) {
        if controller.navigationController != nil {
            controller.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(controller, animated: isAnimated);
        }
    }
    
    func ccPresent(controller : UIViewController! ) {
        self.ccPresent(controller: controller,
                       isAnimated: true,
                       complete: nil);
    }
    func ccPresent(controller : UIViewController! ,
                   complete closureComplete : CC_Closure_T? ) {
        self.ccPresent(controller: controller,
                       isAnimated: true,
                       complete: closureComplete);
    }
    func ccPresent(controller : UIViewController! ,
                   isAnimated : Bool ,
                   complete closureComplete : CC_Closure_T? ) {
        controller.providesPresentationContextTransitionStyle = true;
        controller.definesPresentationContext = true;
        controller.modalPresentationStyle = .overCurrentContext;
        self.present(controller,
                     animated: isAnimated,
                     completion: closureComplete);
    }
    
    func ccGoBack() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true);
        }
        if self.presentingViewController != nil {
            self.dismiss(animated: true,
                         completion: nil);
        }
    }
    
    func ccAdd(controller : UIViewController? , isAnimated : Bool) {
        if let controllerT = controller {
            
            guard UIApplication.shared.delegate?.window != nil else {
                return;
            }
            
            let window : UIWindow! = (UIApplication.shared.delegate?.window)!;
            
            for item in window.subviews {
                if item == controllerT.view {
                    return ;
                }
            }
            
            let closure = {
                if let windowT = UIApplication.shared.delegate?.window {
                    windowT?.addSubview(controllerT.view);
                }
            }
            
            if isAnimated {
                controllerT.view.alpha = 0.0;
                closure();
                UIView.animate(withDuration: _CC_ANIMATION_COMMON_DURATION_, animations: {
                    controllerT.view.alpha = 1.0;
                });
            } else {
                closure();
            }
            self.addChildViewController(controllerT);
        }
    }
    
    func ccImagePicker(present type : UIImagePickerController.CCImagePickerPresentType ,
                       complete closureComplete : UIImagePickerController.ClousreComplete ) -> UIImagePickerController? {
        return self.ccImagePicker(present: type,
                                  complete: closureComplete,
                                  cancel: nil,
                                  error: nil);
    }
    
    func ccImagePicker(present type : UIImagePickerController.CCImagePickerPresentType ,
                       complete closureComplete : UIImagePickerController.ClousreComplete ,
                       cancel closureCancel : UIImagePickerController.ClousreCancel ,
                       error closureError : UIImagePickerController.ClosureError) -> UIImagePickerController? {
        
        if _CC_IS_SIMULATOR_ {
            if type == .camera {
                
            }
            return nil;
        }
        
        var imagePicker : UIImagePickerController? = nil ;
        
        let closureDismiss = {
            if let imagePickerT = imagePicker {
                imagePickerT.dismiss(animated: true, completion: nil);
            }
        }
        
        imagePicker = UIImagePickerController.init(present: type, complete: { (imageOriginal, imageEdited, rectEdited, arraySupportType) -> UIImagePickerController.CCImageSaveType? in
            closureDismiss();
            if let closureCompleteT = closureComplete {
                return closureCompleteT(imageOriginal , imageEdited , rectEdited , arraySupportType);
            }
            return .nonee;
        }, cancel: { 
            closureDismiss();
            if let closureCancelT = closureCancel {
                closureCancelT();
            }
        }) { (error) in
            closureDismiss();
            if let closureErrorT = closureError {
                closureErrorT(error);
            }
        };
        
        return imagePicker;
    }
    
}


