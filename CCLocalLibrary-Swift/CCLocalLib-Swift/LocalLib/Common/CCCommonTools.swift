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
    
    convenience init(timer interval : TimeInterval ,
                     action closureAction : (() -> Void)? ,
                     cancel closureCancel : (() -> Void)? ) {
        self.init();
    }
    
    func ccCancelTimer() {
        
    }
    
    private func ccCancelTimerAction() {
        
    }
}
