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
    
    convenience init(name : String?) {
        self.init(name, isFile: false, rendaring: .alwaysOriginal);
    }
    
    convenience init(file : String?) {
        self.init(file, isFile: true, rendaring: .alwaysOriginal);
    }
    
    private convenience init(_ string : String? ,
                             isFile : Bool ,
                             rendaring mode : UIImageRenderingMode) {
        if isFile {
            self.init(file: string);
        } else {
            self.init(name: string);
        }
        self.withRenderingMode(mode);
    }
    
    var width : CGFloat {
        get {
            return self.size.width;
        }
    }
    var height : CGFloat {
        get {
            return self.size.height;
        }
    }
    func ccZoom(equal scale : CGFloat?) -> CGSize {
        if let scaleT = scale {
            if scaleT > 0.0 {
                let ratio : CGFloat = self.height / self.width ;
                let ratioWidth : CGFloat = self.width * scaleT;
                let ratioHeight : CGFloat = ratioWidth * ratio;
                return CGSize.init(width: ratioWidth, height: ratioHeight);
            }
        }
        return self.size;
    }
    
    /// Type of image , PNG / JPEG
    func ccType(with data : Data?) -> CCImageType {
        guard data != nil else {
            return .unknow;
        }
        
        let dataT : NSData = data as NSData!;
        var c : UInt8 = 0;
        dataT.getBytes(&c, length: 1);
        switch c {
        case 0xFF:
            return .jpeg;
        case 0x89:
            return .png;
        case 0x49:
            fallthrough;
        case 0x4D:
            return .tiff;
        case 0x52:
            if dataT.length < 12 {
                return .unknow;
            }
            
        default:
            return .unknow;
        }
        return .unknow;
    }
    
    func ccImageData(_ closure : ((CCImageType , Data?) -> Void)? ) -> Data? {
        
        let closureT = { (type : CCImageType ,data : Data?) in
            if let closureR = closure {
                closureR(type , data);
            }
        }
        
        var data : Data? = UIImagePNGRepresentation(self);
        if data != nil {
            closureT(.png , data);
            return data;
        }
        data = UIImageJPEGRepresentation(self, _CC_IMAGE_JPEG_COMPRESSION_QUALITY_);
        if data != nil {
            closureT(.jpeg , data);
            return data;
        }
        closureT(.unknow , data);
        return nil;
    }
    
    /// COLOR
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
    
    /// Sync , not recomended . But on the other hand , CI makes it more smooth.
    var gaussianBlurAcc : UIImage? {
        get {
            return ccGaussianImageAcc(radius: _CC_GAUSSIAN_BLUR_VALUE_ ,
                                      iterationCount: _CC_GAUSSIAN_BLUR_ITERATION_COUNT_,
                                      tint: UIColor.clear);
        }
    }
    
    func ccGaussianImageAcc(complete closureComplete : ((UIImage , UIImage?) -> Void)? ) {
        self.ccGaussianImageAcc(radius: _CC_GAUSSIAN_BLUR_VALUE_,
                                iterationCount: _CC_GAUSSIAN_BLUR_ITERATION_COUNT_,
                                tint: UIColor.clear,
                                complete: closureComplete);
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
        if (floor(self.size.width) * floor(self.size.height)) <= 0 {
            return self;
        }
        
        var intBoxSize : UInt32 = UInt32(CGFloat(radius) * self.scale);
        intBoxSize = intBoxSize - (intBoxSize % 2) + 1;
        
        var imageRef : CGImage? = self.cgImage;
        guard imageRef != nil else {
            return self;
        }
        
        if (imageRef!.bitsPerPixel != 32
            || imageRef!.bitsPerComponent != 8
            || !(imageRef!.bitmapInfo.contains(CGBitmapInfo.alphaInfoMask))) {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
            draw(at: .zero);
            imageRef = UIGraphicsGetImageFromCurrentImageContext()?.cgImage;
            UIGraphicsEndImageContext();
        }
        
        guard imageRef != nil else {
            return self;
        }
        
        var bufferIn : vImage_Buffer = vImage_Buffer();
        bufferIn.height = vImagePixelCount(imageRef!.height);
        bufferIn.width = vImagePixelCount(imageRef!.width);
        bufferIn.rowBytes = imageRef!.bytesPerRow;
        
        var bufferOut : vImage_Buffer = vImage_Buffer();
        bufferOut.height = vImagePixelCount(imageRef!.height);
        bufferOut.width = vImagePixelCount(imageRef!.width);
        bufferOut.rowBytes = imageRef!.bytesPerRow;
        
        /// "malloc" && "free" is C language ,
        /// therefore , they must MATCH to each other ONE BY ONE ,
        /// to avoid the memory leak of course,
        /// and be careful of wild pointer (Over released can cause crash).
        
        let bytes = bufferOut.rowBytes * Int(bufferOut.height);
        bufferIn.data = malloc(bytes);
        bufferOut.data = malloc(bytes);
        
        guard (bufferIn.data != nil && bufferOut.data != nil) else {
            free(bufferIn.data);
            free(bufferOut.data);
            return self;
        }
        
        let tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&bufferOut,
                                                           &bufferIn,
                                                           nil,
                                                           0,
                                                           0,
                                                           intBoxSize,
                                                           intBoxSize,
                                                           nil,
                                                           vImage_Flags(kvImageEdgeExtend+kvImageGetTempBufferSize)))
        
        let provider : CGDataProvider? = imageRef!.dataProvider;
        let dataInBitmap : CFData? = provider?.data;
        
        guard dataInBitmap != nil else {
            return self;
        }
        
        memcpy(bufferOut.data,
               CFDataGetBytePtr(dataInBitmap!),
               min(bytes, CFDataGetLength(dataInBitmap!)));
        
        for _ in 0..<iterationCount {
            let error : vImage_Error? = vImageBoxConvolve_ARGB8888(&bufferOut,
                                                                   &bufferIn,
                                                                   tempBuffer,
                                                                   0,
                                                                   0,
                                                                   UInt32(intBoxSize),
                                                                   UInt32(intBoxSize),
                                                                   nil,
                                                                   vImage_Flags(kvImageEdgeExtend));
            guard error == kvImageNoError else {
                free(tempBuffer);
                free(bufferOut.data);
                free(bufferIn.data);
                return self;
            }
            
            swap(&bufferIn.data, &bufferOut.data);
        }
        
        free(bufferIn.data);
        free(tempBuffer);
        
        let colorSpace : CGColorSpace? = imageRef!.colorSpace;
        guard colorSpace != nil else {
            return self;
        }
        
        let context : CGContext? = CGContext.init(data: bufferOut.data,
                                                  width: Int(bufferOut.width),
                                                  height: Int(bufferOut.height),
                                                  bitsPerComponent: 8,
                                                  bytesPerRow: bufferOut.rowBytes,
                                                  space: colorSpace!,
                                                  bitmapInfo: imageRef!.bitmapInfo.rawValue);
        guard context != nil else {
            return self;
        }
        
        if let colorT = color {
            if colorT.cgColor.alpha > 0.0 {
                context!.setFillColor(colorT.withAlphaComponent(_CC_GAUSSIAN_BLUR_TINT_ALPHA_).cgColor);
                context!.setBlendMode(.plusLighter);
                context!.fill(CGRect.init(x: 0,
                                          y: 0,
                                          width: Int(bufferOut.width),
                                          height: Int(bufferOut.height)));
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
    
//MARK: - gaussian with Core Image
    
    /// Sync , tooooooo slow . NOT RECOMENDED .
    var gaussianBlurCI : UIImage? {
        get {
            return self.ccGaussianImageCI(radius: _CC_GAUSSIAN_BLUR_VALUE_);
        }
    }
    
    func ccGaussianImageCI(complete closureComplete : ((UIImage , UIImage?) -> Void)? ) {
        let quque : DispatchQueue = DispatchQueue.init(label: "Love.cc.love.home",
                                                       qos: .default,
                                                       attributes: .concurrent,
                                                       autoreleaseFrequency: .inherit,
                                                       target: nil);
        quque.async {
            CC_Safe_Closure(closureComplete, {
                closureComplete!(self , self.ccGaussianImageCI(radius: _CC_GAUSSIAN_BLUR_VALUE_));
            })
        }
    }
    
    func ccGaussianImageCI(radius : Double?) -> UIImage? {
        let context : CIContext = CIContext.init(options: [kCIContextPriorityRequestLow : true]); /// don't let it cost to much resources of GPU .
        let imageIn : CIImage? = CIImage.init(image: self);
        guard imageIn != nil else {
            return self;
        }
        
        let filter : CIFilter? = CIFilter.init(name: "CIGaussianBlur");
        guard filter != nil else {
            return self;
        }
        filter!.setValue(imageIn, forKey: kCIInputImageKey);
        filter!.setValue(radius, forKey: kCIInputRadiusKey);
        
        let imageR : CIImage? = filter!.value(forKey: kCIOutputImageKey) as? CIImage;
        guard  imageR != nil else {
            return self;
        }
        let imageO : CGImage? = context.createCGImage(imageR!,
                                                      from: CGRect.init(origin: CGPoint.zero,
                                                                        size: CGSize.init(width: imageR!.extent.size.width,
                                                                                          height: imageR!.extent.size.height)));
        guard imageO != nil else {
            return self;
        }
        
        return UIImage.init(cgImage: imageO!);
    }
    
}

