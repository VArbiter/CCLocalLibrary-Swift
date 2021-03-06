//
//  ViewController.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// for testing ...

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black;
        
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(with: "ic_launcher_144") { (sender) in
            CCLog("CLICK_LEFT " + "\(sender)");
        };
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(with: "ic_launcher_144") { (sender) in
            CCLog("CLICK_RIGHT " + "\(sender)");
        };
        
        let button : UIButton = UIButton.init(system: .init(x: 100, y: 100, width: 50, height: 50), clickAction: { (sender) in
            CCLog("CLICK_BUTTON " + "\(sender)");
        });
        button.backgroundColor = UIColor.brown;
        self.view.addSubview(button);
        
        let image : UIImage = UIImage.init(named: "0ZG63407-0")!.gaussianBlurCI!;
        let imageView : UIImageView = UIImageView.init(image: image);
        imageView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 200), size: image.ccZoom(equal: 0.4));
        self.view.addSubview(imageView);
        let imageA : UIImage = UIImage.init(named: "0ZG63407-0")!.gaussianBlurAcc!;
        let imageViewA : UIImageView = UIImageView.init(image: imageA);
        imageViewA.frame = CGRect.init(origin: CGPoint.init(x: 0,
                                                            y: imageView.frame.origin.y + imageView.frame.size.height),
                                       size: imageA.ccZoom(equal: 0.4));
        self.view.addSubview(imageViewA);
        
        CCNetworkMoniter.sharedInstance.ccEnableMoniter();
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ccNotification(_:)),
                                               name: NSNotification.Name(rawValue: _CC_NETWORK_STATUS_CHANGE_NOTIFICATION_),
                                               object: nil);
        
        "s".s("s").s("s");
    }
    
    @objc private func ccNotification(_ sender : Notification) {
        CCLog(sender.userInfo![_CC_NETWORK_STATUS_KEY_OLD_]);
        CCLog(sender.userInfo![_CC_NETWORK_STATUS_KEY_NEW_]);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
