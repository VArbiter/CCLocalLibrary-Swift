//
//  ViewController.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let d : Dictionary<String , Any> = ["1":"0"];
        CCLog("\(ccIsDictionaryValued("")) false is the answer");
        CCLog("\(ccIsDictionaryValued(d)) ture is the answer");
        
        /*
        var array : [Any] = [];
        array.stringClass = "\(String.self)";
        if let stringClassT = array.stringClass {
            print("\(stringClassT)");
        }
         */
        
        var arrayAppend : [String] = [];
        arrayAppend.ccAppend("0123456", itemType: "\(String.self)");
        arrayAppend.ccAppend("6543210", itemType: nil, changeObserver: { (item, intTotalCount) in
            
        }) { 
            
        };
        CCLog("\(arrayAppend)");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

