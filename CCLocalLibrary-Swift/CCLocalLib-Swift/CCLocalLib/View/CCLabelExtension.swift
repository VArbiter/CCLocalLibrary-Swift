//
//  CCLabelExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(common frame : CGRect) {
        self.init(frame: frame);
        self.numberOfLines = 0;
        self.font = UIFont.systemFont(ofSize: _CC_DEFAULT_FONT_SIZE_);
        self.textAlignment = .left;
        self.textColor = UIColor.black;
        self.backgroundColor = UIColor.clear;
        self.lineBreakMode = .byTruncatingTail;
    }
    
    var autoHeight : CGFloat {
        get {
            return self.ccAutoHeight(text: self.text,
                                     width: self.frame.size.width);
        }
    }
    
    func ccAutoHeight(text string : String? , width : CGFloat) -> CGFloat {
        guard string != nil else {
            return 0.0;
        }
        let stringT = string! as NSString;
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle.init();
        style.lineBreakMode = self.lineBreakMode;
        let dictionaryAttributes : [String : Any] = [NSFontAttributeName : self.font ,
                                                     NSParagraphStyleAttributeName : style];
        return stringT.boundingRect(with: CGSize.init(width: width,
                                                      height: UIScreen.main.bounds.size.height * 10.0),
                                    options: [.usesFontLeading , .usesLineFragmentOrigin],
                                    attributes: dictionaryAttributes,
                                    context: nil).size.height;
    }
    
    class func ccAutoHeight(text string: String? ,
                            width : CGFloat) -> CGFloat{
        return self.ccAutoHeight(text: string,
                                 font: UIFont.systemFont(ofSize: _CC_DEFAULT_FONT_SIZE_),
                                 mode: .byTruncatingTail,
                                 width: width);
    }
    
    class func ccAutoHeight(text string: String? ,
                            font : UIFont? ,
                            mode : NSLineBreakMode ,
                            width : CGFloat) -> CGFloat {
        guard string != nil else {
            return 0.0;
        }
        var fontT : UIFont = UIFont.systemFont(ofSize: _CC_DEFAULT_FONT_SIZE_);
        if let _  = font {
            fontT = font!;
        }
        let stringT = string! as NSString;
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle.init();
        style.lineBreakMode = mode;
        let dictionaryAttributes : [String : Any] = [NSFontAttributeName : fontT ,
                                                     NSParagraphStyleAttributeName : style];
        return stringT.boundingRect(with: CGSize.init(width: width,
                                                      height: UIScreen.main.bounds.size.height * 10.0),
                                    options: [.usesFontLeading , .usesLineFragmentOrigin],
                                    attributes: dictionaryAttributes,
                                    context: nil).size.height;
    }
    
}
