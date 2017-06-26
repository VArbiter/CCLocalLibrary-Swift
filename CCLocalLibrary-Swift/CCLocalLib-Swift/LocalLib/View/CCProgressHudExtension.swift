//
//  CCProgressHudExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 23/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import UIKit

import MBProgressHUD

extension MBProgressHUD {
    
    enum CCHudType : Int {
        case nonee = 0 , light , dark , darkDeep
    }
    
    func enable() {
        self.isUserInteractionEnabled = true;
    }
    func disable() {
        self.isUserInteractionEnabled = false;
    }
    
    class func ccHideAll() {
        self.ccHideAll(with: nil);
    }
    class func ccHideAll(with view : UIView?) {
        self.ccHideAll(with: view, complete: nil);
    }
    class func ccHideAll(with view : UIView? ,
                         complete closureComplete : CC_Closure_T?) {
        let closure = { (viewR : UIView?) in
            if let viewT = viewR {
                for item in viewT.subviews {
                    if item.isKind(of: MBProgressHUD.self) {
                        MBProgressHUD.ccHideSingleHud(viewT);
                    }
                }
            }
        }
        
        if let viewT = view {
            closure(viewT);
        } else {
            if let windowT = UIApplication.shared.delegate?.window {
                closure(windowT);
            }
        }
    }
    
    class func ccHideSingleHud() {
        self.ccHideSingleHud(nil);
    }
    class func ccHideSingleHud(_ view : UIView?) {
        let closure = { (viewR : UIView?) -> Void in
            if let viewT = viewR {
                CC_Main_Queue_Operation {
                    MBProgressHUD.hide(for: viewT, animated: true);
                }
            }
        }
        
        if let viewT = view {
            closure(viewT);
        }
        if let windowT = UIApplication.shared.delegate?.window {
            closure(windowT) ;
        }
        
    }
    
    class var isCurrentHasHud : Bool {
        get {
            return MBProgressHUD.ccIsCurrentHasHud(nil) > 0;
        }
    }
    
    class func ccIsCurrentHasHud(_ view : UIView?) -> Int {
        let closure = { (viewR : UIView?) -> Int in
            var count : Int = 0;
            if let viewT = viewR {
                for item in viewT.subviews {
                    if item.isKind(of: MBProgressHUD.self) {
                        count += 1;
                    }
                }
            }
            return count;
        }
        
        if let viewT = view {
            return closure(viewT);
        }
        if let windowT = UIApplication.shared.delegate?.window {
            return closure(windowT) ;
        }
        return 0;
    }
    
    class func ccShow(message string : String?) -> MBProgressHUD {
        return self.ccShow(message: string,
                           type: nil);
    }
    class func ccShow(message string : String? ,
                      type : CCHudType? ) -> MBProgressHUD {
        return self.ccShow(message: string,
                           type: type,
                           with: nil);
    }
    class func ccShow(message string : String? ,
                      type : CCHudType? ,
                      with view : UIView? ) -> MBProgressHUD {
        return self.ccShow(title: nil,
                           message: string,
                           type: type,
                           with: view);
    }
    class func ccShow(title stringT : String? ,
                      message stringM : String? ,
                      type : CCHudType? ,
                      with view : UIView? ) -> MBProgressHUD {
        return self.ccShow(title: stringT,
                           message: stringM,
                           type: type,
                           with: view,
                           delay: nil);
    }
    class func ccShow(title stringT : String? ,
                      message stringM : String? ,
                      type : CCHudType? ,
                      with view : UIView? ,
                      delay float : TimeInterval?) -> MBProgressHUD {
        return self.ccShow(title: stringT,
                           message: stringM,
                           type: type,
                           with: view,
                           delay: float,
                           complete: nil);
    }
    class func ccShow(title stringT : String? ,
                      message stringM : String? ,
                      type : CCHudType? ,
                      with view : UIView? ,
                      delay float : TimeInterval? ,
                      complete closureComplete : CC_Closure_T?) -> MBProgressHUD {
        let hud : MBProgressHUD = self.ccDefaultSettings(type: type, view: view);
        hud.label.text = stringT;
        hud.detailsLabel.text = stringM;
        if let floatT = float {
            if floatT > 0 {
                hud.hide(animated: true, afterDelay: floatT);
            }
        }
        
        CC_Safe_Closure(closureComplete) { 
            closureComplete!();
        }
        
        return hud;
    }
    
    private class func ccDefaultSettings(type : CCHudType) -> MBProgressHUD{
        return self.ccDefaultSettings(type: nil, view: nil);
    }
    private class func ccDefaultSettings(type : CCHudType? ,
                                         view : UIView?) -> MBProgressHUD {
        return self.ccDefaultSettings(type: type,
                                      view: view,
                                      isIndicatorEnable: false);
    }
    private class func ccDefaultSettings(type : CCHudType? ,
                                         view : UIView? ,
                                         isIndicatorEnable : Bool) -> MBProgressHUD{
        let closure = { (viewR : UIView?) -> MBProgressHUD in
            if let viewT = viewR {
                let hud : MBProgressHUD = MBProgressHUD.showAdded(to: viewT,
                                                                  animated: true);
                if !isIndicatorEnable {
                    hud.mode = .text;
                }
                hud.isUserInteractionEnabled = false;
                if let typeT = type {
                    switch typeT {
                    case .light:
                        hud.contentColor = UIColor.black;
                    case .darkDeep:
                        hud.bezelView.style = .solidColor ;
                        fallthrough;
                    case .dark:
                        hud.contentColor = UIColor.white;
                        hud.bezelView.backgroundColor = UIColor.black;
                    default:
                        break;
                    }
                }
                return hud;
            }
            return MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!,
                                           animated: true);
        }
        
        if let viewT = view {
            return closure(viewT);
        }
        if let windowT = UIApplication.shared.delegate?.window {
            return closure(windowT) ;
        }
        return closure(UIApplication.shared.keyWindow!);
    }
    
    ///Indicator
    class func ccShowIndicator(after float : TimeInterval ) -> MBProgressHUD {
        return self.ccShowIndicator(after: float,
                                    message: nil,
                                    type: nil);
    }
    class func ccShowIndicator(after float : TimeInterval ,
                               with view : UIView? ,
                               message stringM : String? ) -> MBProgressHUD {
        return self.ccShowIndicator(after: float,
                                    with: view,
                                    title: nil,
                                    message: stringM,
                                    type: nil);
    }
    class func ccShowIndicator(after float : TimeInterval ,
                               message stringM : String? ,
                               type : CCHudType? ) -> MBProgressHUD {
        return self.ccShowIndicator(after: float,
                                    with: nil,
                                    title: nil,
                                    message: stringM,
                                    type: nil);
    }
    class func ccShowIndicator(after float : TimeInterval ,
                               with view : UIView? ,
                               title stringT : String? ,
                               message stringM : String? ,
                               type : CCHudType? ) -> MBProgressHUD {
        let closure = { (viewR : UIView?) -> MBProgressHUD in
            if let viewT = viewR {
                let hud : MBProgressHUD = self.ccDefaultSettings(type: type,
                                                                 view: viewT,
                                                                 isIndicatorEnable: true);
                if float > 0 {
                    hud.hide(animated: true, afterDelay: float);
                }
                hud.detailsLabel.text = stringM;
                
                return hud;
            }
            return MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!,
                                           animated: true);
        }
        
        if let viewT = view {
            return closure(viewT);
        }
        if let windowT = UIApplication.shared.delegate?.window {
            return closure(windowT) ;
        }
        return closure(UIApplication.shared.keyWindow!);
    }
}

/// for MBProgressHud
extension UIView {
    
    var isHasHud : Bool {
        get {
            return MBProgressHUD.ccIsCurrentHasHud(self) > 0;
        }
    }
    
    /// can't auto dismiss by a timer .
    func ccShowIndicator() -> MBProgressHUD{
        return self.ccShowIndicator(type: nil);
    }
    
    func ccShowIndicator(type : MBProgressHUD.CCHudType?) -> MBProgressHUD{
        return self.ccShowIndicator(type: type, message: nil);
    }
    
    func ccShowIndicator(type : MBProgressHUD.CCHudType? ,
                         message stringM : String?) -> MBProgressHUD {
        return MBProgressHUD.ccShowIndicator(after: -1,
                                             with: self,
                                             title: nil,
                                             message: stringM,
                                             type: nil);
    }
    
    func ccHide() {
        MBProgressHUD.ccHideAll(with: self);
    }
    
    func ccShow(message stringM : String?) -> MBProgressHUD {
        return self.ccShow(message: stringM, type: nil);
    }
    
    func ccShow(message stringM : String? ,
                type : MBProgressHUD.CCHudType?) -> MBProgressHUD {
        return MBProgressHUD.ccShow(message: stringM,
                                    type: type,
                                    with: self);
    }
    
}
