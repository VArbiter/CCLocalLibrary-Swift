//
//  CCWebViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 23/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {
    
    convenience init(common frame : CGRect) {
        self.init(common: frame, delegete: nil);
    }
    
    convenience init(common frame : CGRect ,
                     delegete : WKNavigationDelegate?) {
        self.init(common: frame, configuration: nil, delegete: delegete);
    }
    
    convenience init(common frame : CGRect ,
                     configuration config : WKWebViewConfiguration? ,
                     delegete : WKNavigationDelegate?) {
        if let configT = config {
            self.init(frame: frame, configuration: configT);
        } else {
            self.init(frame: frame);
        }
        self.navigationDelegate = delegete;
        self.autoresizingMask = [.flexibleWidth , .flexibleHeight];
        self.autoresizesSubviews =  true;
        self.allowsBackForwardNavigationGestures = true;
        self.scrollView.alwaysBounceVertical = true;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    
    func ccLoad(common string : String?) -> WKNavigation? {
        if let stringT = string {
            if (stringT.hasPrefix("http://")
                || stringT.hasPrefix("https://")) {
                return self.ccLoad(request: stringT);
            } else {
                return self.ccLoad(html:stringT);
            }
        }
        return nil;
    }
    
    func ccLoad(request string : String?) -> WKNavigation? {
        if let stringT = string {
            if stringT.isStringValued {
                if let urlT = URL.init(string: stringT) {
                    return self.load(URLRequest.init(url: urlT));
                }
            }
        }
        return nil;
    }
    func ccLoad(html string : String?) -> WKNavigation? {
        if let stringT = string {
            if stringT.isStringValued {
                return self.loadHTMLString(stringT, baseURL: nil);
            }
        }
        return nil;
    }
    
}
