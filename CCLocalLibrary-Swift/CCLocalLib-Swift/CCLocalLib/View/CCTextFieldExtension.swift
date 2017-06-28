//
//  CCTextFieldExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(common frame : CGRect ) {
        self.init(common: frame, delegate: nil);
    }
    
    convenience init(common frame : CGRect ,
                     delegate : UITextFieldDelegate? ) {
        self.init(frame: frame);
        self.textColor = UIColor.black;
        self.clearsOnBeginEditing = true;
        self.clearButtonMode = .whileEditing;
        self.font = UIFont.systemFont(ofSize: _CC_DEFAULT_FONT_SIZE_);
        if let delegateT = delegate {
            self.delegate = delegateT;
        }
    }
    
    func ccRightView(imageName string : String?) {
        guard string != nil else {
            return;
        }
        
        let image : UIImage? = ccImage(string!)?.withRenderingMode(.alwaysOriginal);
        if let imageT = image {
            let imageView : UIImageView = UIImageView.init(image: imageT);
            imageView.contentMode = .scaleAspectFit;
            imageView.sizeToFit();
            self.rightViewMode = .always;
            self.rightView = imageView;
        }
    }
    
    func ccResignFirstResponder() {
        if self.canResignFirstResponder {
            self.resignFirstResponder();
        }
    }
    
}
