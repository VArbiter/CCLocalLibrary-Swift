//
//  CCImageExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 19/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit
import Accelerate
import CoreImage
import QuartzCore

extension UIImage {
    
    class func ccImage(_ color : UIColor?) -> UIImage? {
        return self.ccImage(color, size: 0.0);
    }
    
    class func ccImage(_ color : UIColor? , size : Double? ) -> UIImage? {
        guard (color != nil && size != nil) else {
            return nil;
        }
        
        var sizeT : Double = 1.0
        if size! > 0.0 {
            sizeT = size!;
        }
        
        let rect : CGRect = CGRect.init(x: 0.0, y: 0.0, width: sizeT, height: sizeT);
        UIGraphicsBeginImageContext(rect.size);
        let context : CGContext? = UIGraphicsGetCurrentContext();
        if let contextT = context {
            contextT.setFillColor(color!.cgColor);
            contextT.fill(rect);
            let image : UIImage? = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image;
        }
        UIGraphicsEndImageContext();
        return nil;
    }
    
    /// Sync , not recomended .
    var gaussianBlur : UIImage? {
        get {
            return ccGaussianImageAcc(radius: _CC_GAUSSIAN_BLUR_VALUE_,
                                      iterationCount: 0,
                                      tint: UIColor.white);
        }
    }
    
    func ccGaussianImageAcc(radius : Double ,
                            iterationCount : Int ,
                            tint color : UIColor? ,
                            complete closureComplete : ((UIImage , UIImage?) -> Void)? ) { // original , processed
        let quque : DispatchQueue = DispatchQueue.init(label: "Love.cc.love.home",
                                                       qos: .default,
                                                       attributes: .concurrent,
                                                       autoreleaseFrequency: .inherit,
                                                       target: nil);
        quque.async {
            CC_Safe_Closure(closureComplete, {
                closureComplete!(self , self.ccGaussianImageAcc(radius: radius,
                                                                iterationCount: iterationCount,
                                                                tint: color));
            })
        }
    }
    
    func ccGaussianImageAcc(radius : Double ,
                            iterationCount : Int ,
                            tint color : UIColor? ) -> UIImage? {
        let image : UIImage? = self.copy() as? UIImage;
        guard image != nil else {
            return self;
        }
        
        if (floor(self.size.width) * floor(self.size.height)) < 0 {
            return self;
        }
        
        var intBoxSize : Int = Int(CGFloat(radius) * self.scale);
        intBoxSize = intBoxSize - (intBoxSize % 2) + 1;
        var imageRef : CGImage? = image?.cgImage;
        guard imageRef != nil else {
            return self;
        }
        
        if (imageRef!.bitsPerPixel != 32
            || imageRef?.bitsPerComponent != 8
            || !(imageRef!.bitmapInfo.contains(CGBitmapInfo.alphaInfoMask))) {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
            draw(at: .zero);
            imageRef = UIGraphicsGetImageFromCurrentImageContext()?.cgImage;
            UIGraphicsEndImageContext();
        }
        
        let provider : CGDataProvider? = imageRef!.dataProvider;
        let dataInBitmap : CFMutableData? = (provider?.data as! CFMutableData);
        guard dataInBitmap != nil else {
            return self;
        }
        
        var bufferIn : vImage_Buffer = vImage_Buffer.init(data: CFDataGetMutableBytePtr(dataInBitmap!),
                                                          height: vImagePixelCount(imageRef!.height),
                                                          width: vImagePixelCount(imageRef!.width),
                                                          rowBytes: imageRef!.bytesPerRow);
        
        var bufferOut : vImage_Buffer = vImage_Buffer.init(data: malloc(imageRef!.bytesPerRow * imageRef!.height),
                                                           height: vImagePixelCount(imageRef!.height),
                                                           width: vImagePixelCount(imageRef!.width),
                                                           rowBytes: imageRef!.bytesPerRow);
        
        guard (bufferIn.data != nil && bufferOut.data != nil) else {
            return self;
        }
        
        memcpy(bufferOut.data, CFDataGetBytePtr(dataInBitmap!), min(bufferIn.rowBytes * Int(bufferIn.height), CFDataGetLength(dataInBitmap!)));
        
        var tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&bufferIn,
                                                           &bufferOut,
                                                           nil,
                                                           0,
                                                           0,
                                                           UInt32(intBoxSize),
                                                           UInt32(intBoxSize),
                                                           nil,
                                                           vImage_Flags(kvImageEdgeExtend+kvImageGetTempBufferSize)))
        
        for _ in 0..<iterationCount {
            let error : vImage_Error? = vImageBoxConvolve_ARGB8888(&bufferIn,
                                                                   &bufferOut,
                                                                   &tempBuffer,
                                                                   0,
                                                                   0,
                                                                   UInt32(intBoxSize),
                                                                   UInt32(intBoxSize),
                                                                   nil,
                                                                   vImage_Flags(kvImageEdgeExtend+kvImageGetTempBufferSize));
            guard error == nil else {
                free(bufferIn.data);
                free(bufferOut.data);
                return self;
            }
            
            swap(&bufferIn, &bufferOut);
        }
        
        free(tempBuffer);
        
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB();
        let context : CGContext? = CGContext.init(data: bufferOut.data,
                                                  width: Int(bufferOut.width),
                                                  height: Int(bufferOut.height),
                                                  bitsPerComponent: 8,
                                                  bytesPerRow: bufferOut.rowBytes,
                                                  space: colorSpace,
                                                  bitmapInfo: imageRef!.bitmapInfo.rawValue);
        guard context != nil else {
            return self;
        }
        
        if let colorT = color {
            if colorT.cgColor.alpha > 0.0 {
                context!.setFillColor(colorT.withAlphaComponent(_CC_GAUSSIAN_BLUR_TINT_ALPHA_).cgColor);
                context!.setBlendMode(.plusLighter);
                context!.fill(CGRect.init(x: 0, y: 0, width: Int(bufferOut.width), height: Int(bufferOut.height)));
            }
        }
        
        imageRef = context!.makeImage();
        
        guard imageRef != nil else {
            return self;
        }
        
        /// Part of CoreFoundation is now can be managed by ARC .
        /// Thus , no more releases . ^_^
        
        let imageP = UIImage.init(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation);
        
        free(bufferOut.data);
        
        return imageP;
    }
    
}
