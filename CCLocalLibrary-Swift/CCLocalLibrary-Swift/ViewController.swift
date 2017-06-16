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
        
        
        var arrayInt : [Double] = [0.0 , 0.0 , 0.1 , 0.2];
        arrayInt.ccRemove(0.0);
        CCLog(arrayInt);
        
        let mText : NSMutableAttributedString = NSMutableAttributedString.init();
        mText.append(NSMutableAttributedString.init());
        
        var dict : Dictionary? = Dictionary.init(dictionaryLiteral: (0 , "0")); // key , value
        dict?.ccSet("3", forKey: 3);
        dict?.ccSet("4", forKey: 4, observerChange: { (key, value) in
            CCLog("\(key) , \(String(describing: value))");
        }, complete: { (key, value, keys, values) in
            CCLog("\(key) , \(String(describing: value)) , \(String(describing: keys)) , \(String(describing: values)) ");
        });
    
        if let p = "admin".ccMD5Encrypted {
            CCLog(p);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

