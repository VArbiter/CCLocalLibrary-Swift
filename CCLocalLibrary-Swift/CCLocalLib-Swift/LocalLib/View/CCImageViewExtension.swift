//
//  CCImageViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    convenience init(common frame : CGRect) {
        self.init(common: frame, image: nil, userInterAction: false);
    }
    
    convenience init(common frame : CGRect , image : UIImage? , userInterAction isEnable : Bool) {
        self.init(frame: frame);
        if let imageT = image {
            self.image = imageT;
        }
        self.isUserInteractionEnabled = isEnable;
        self.backgroundColor = UIColor.clear;
        self.contentMode = .scaleAspectFill;
    }
    
    func ccGussianImage() {
        self.ccGussianImage(complete: nil);
    }
    
    func ccGussianImage(complete closure : (() -> Void)? ) {
        self.ccGussianImage(blur: _CC_GAUSSIAN_BLUR_VALUE_,
                            complete: closure);
    }
    
    func ccGussianImage(blur value : Double , complete closure : (() -> Void)? ) {
        guard self.image != nil else {
            return ;
        }
        self.image!.ccGaussianImageAcc(radius: value, iterationCount: 0, tint: UIColor.white) { [unowned self] (imageOrigin, imageProcessed) in
            if let imageProcessedT = imageProcessed {
                self.image = imageProcessedT;
                CC_Safe_Closure(closure, {
                    closure!();
                })
            }
        }
    }
    
}

extension Array {
    
    func ccAnimate(frame : CGRect) -> UIImageView? {
        guard self.isArrayValued else {
            return nil;
        }
        
        let colosure = { () -> [UIImage] in
            var array : [UIImage] = [];
            for item in self {
                let mirror : Mirror = Mirror.init(reflecting: item);
                if "\(mirror.subjectType)".compare("\(String.self)") == ComparisonResult.orderedSame {
                    let image : UIImage? = UIImage.init(named: (item as! String));
                    guard image != nil else {
                        continue;
                    }
                    array.append(image!);
                }
                else if "\(mirror.subjectType)".compare("\(UIImage.self)") == ComparisonResult.orderedSame {
                    array.append((item as! UIImage));
                }
            }
            return array;
        }
        
        let imageView : UIImageView = UIImageView.init(common: frame);
        imageView.animationImages = colosure();
        imageView.animationRepeatCount = Int(INTMAX_MAX);
        imageView.startAnimating();
        return imageView;
    }
    
}


/// Loading image for strong network
extension UIImageView {
    
    func ccLoadingImage(url string : String? ) {
        self.ccLoadingImage(url: string,
                            holder: nil);
    }
    
    func ccLoadingImage(url string : String? ,
                        holder imageH : UIImage? ) {
        self.ccLoadingImage(url: string,
                            holder: imageH,
                            complete: nil);
    }
    
    func ccLoadingImage(url string : String? ,
                        holder imageH : UIImage? ,
                        complete closureComplete : CompletionHandler? ){
        self.ccLoadingImage(url: string,
                            holder: imageH,
                            progress: nil,
                            complete: closureComplete);
    }
    
    func ccLoadingImage(url string : String? ,
                        holder imageH : UIImage? ,
                        progress closureProgress : DownloadProgressBlock? ,
                        complete closureComplete : CompletionHandler?) {
        guard (string != nil)else {
            return;
        }
        if !(string!.isStringValued) {
            return ;
        }
        
        let closure = { (image : UIImage?) -> Bool in
            if let imageT = image {
                self.image = imageT;
                return true;
            }
            return false;
        }
        
        var image : UIImage? = ImageCache.default.retrieveImageInMemoryCache(forKey: string!);
        if closure(image) {
            return ;
        }
        image = ImageCache.default.retrieveImageInDiskCache(forKey: string!);
        if closure(image) {
            return;
        }
        
        if CCNetworkMoniter.sharedInstance.environmentType == .strong {
            self.kf.setImage(with: ccURL(string!, false),
                             placeholder: image,
                             options: nil,
                             progressBlock:closureProgress,
                             completionHandler: closureComplete);
        }
    }
    
}
