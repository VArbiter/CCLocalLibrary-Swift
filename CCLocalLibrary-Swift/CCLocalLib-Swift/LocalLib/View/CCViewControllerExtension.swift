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
                   complete closureComplete : (() -> Void)? ) {
        guard alertController != nil else {
            return ;
        }
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                alertController?.dismiss(animated: true, completion: {
                    if let closureCompleteT = closureComplete {
                        closureCompleteT();
                    }
                })
            });
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
    private class func ccGetCurrentModalController() -> UIViewController? {
        
    }
    
}


