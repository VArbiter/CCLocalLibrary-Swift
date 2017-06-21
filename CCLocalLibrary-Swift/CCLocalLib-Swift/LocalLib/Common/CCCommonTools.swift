//
//  CCCommonTools.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 20/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import AssetsLibrary
import AVFoundation
import Photos

open class CCCommonTools : NSObject {
    
    class var isAllowAccessToAlbum : Bool {
        get {
            if #available(iOS 9.0, *) {
                let author : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus();
                return !(author == PHAuthorizationStatus.restricted || author == PHAuthorizationStatus.denied);
            } else {
                let author : ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus();
                return !(author == ALAuthorizationStatus.restricted || author == ALAuthorizationStatus.denied) ;
            }
        }
    }
    
    class var isAllowAccessToCamera : Bool {
        get {
            let author : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo);
            return !(author == AVAuthorizationStatus.restricted || author == AVAuthorizationStatus.denied);
        }
    }
    
    class func ccGuideToCameraSettings() {
        let url : URL? = URL.init(string: UIApplicationOpenSettingsURLString);
        if let urlT = url {
            if UIApplication.shared.canOpenURL(urlT) {
                if #available(iOS 10.0 , *) {
                    UIApplication.shared.open(urlT, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(urlT);
                }
            }
        }
    }
    
//MARK: - Timer
    private var timer : DispatchSourceTimer? ;
    
    convenience init(timer interval : Int ,
                     action closureAction : (() -> Bool)? ,
                     cancel closureCancel : (() -> Void)? ) {
        self.init(timer: interval,
                  onMain: true,
                  action: closureAction,
                  cancel: closureCancel);
    }
    
    convenience init(timer interval : Int ,
                     onMain isMain : Bool , // is on main thread , when reload
                     action closureAction : (() -> Bool)? ,
                     cancel closureCancel : (() -> Void)? ) {
        self.init();
        
        if let timerT = self.timer {
            timerT.cancel();
            self.timer = nil;
        }
        
        let queue : DispatchQueue = DispatchQueue.global(qos: .default);
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: queue);
        self.timer!.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .seconds(interval));
        self.timer!.setEventHandler(handler: { [unowned self] in
            guard closureAction != nil else {
                return ;
            }
            let closureT = {
                if closureAction!() {
                    self.timer?.cancel();
                }
            }
            if isMain {
                CC_Safe_UI_Closure(closureAction, { 
                    closureT();
                })
            } else {
                CC_Safe_Closure(closureAction, { 
                    closureT();
                })
            }
        });
        self.timer!.resume();
        
        self.timer!.setCancelHandler(handler: {
            guard closureCancel != nil else {
                return;
            }
            if isMain {
                CC_Safe_UI_Closure(closureCancel, { 
                    closureCancel!();
                })
            } else {
                CC_Safe_Closure(closureCancel, { 
                    closureCancel!();
                })
            }
        })
    }
}
