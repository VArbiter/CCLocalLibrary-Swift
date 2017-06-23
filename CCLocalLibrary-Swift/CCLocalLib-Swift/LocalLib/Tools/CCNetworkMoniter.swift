//
//  CCNetworkMoniter.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 23/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation
import CoreTelephony

import Alamofire
import AlamofireNetworkActivityIndicator

let _CC_NETWORK_STATUS_CHANGE_NOTIFICATION_ : String = "CC_NETWORK_STATUS_CHANGE_NOTIFICATION";
let _CC_NETWORK_STATUS_KEY_NEW_ : String = "CC_NETWORK_STATUS_KEY_NEW";
let _CC_NETWORK_STATUS_KEY_OLD_ : String = "CC_NETWORK_STATUS_KEY_OLD";

class CCNetworkMoniter : NSObject {    
    
    enum CCNetworkType : Int {
        case unknow = -1 , Fail , WLAN , WiFi , x2G , x3G , x4G // number can't be a prefix .
    }
    enum CCNetworkEnvironment : Int {
        case unknow = 0 , notReached , weak , strong
    }
    
    /// Shared instance
    static let sharedInstance : CCNetworkMoniter = CCNetworkMoniter.sharedNetworkMoniter();
    private class func sharedNetworkMoniter() -> CCNetworkMoniter {
        return CCNetworkMoniter.init();
    }
    private override init() {
        super.init();
        self.ccDefaultSetting();
    }
    
    private lazy var array_x2G : [String] = {
        return [CTRadioAccessTechnologyEdge ,
                CTRadioAccessTechnologyGPRS ,
                CTRadioAccessTechnologyCDMA1x];
    }()
    private lazy var array_x3G : [String] = {
        return [CTRadioAccessTechnologyHSDPA ,
                CTRadioAccessTechnologyWCDMA ,
                CTRadioAccessTechnologyHSUPA ,
                CTRadioAccessTechnologyCDMAEVDORev0 ,
                CTRadioAccessTechnologyCDMAEVDORevA ,
                CTRadioAccessTechnologyCDMAEVDORevB ,
                CTRadioAccessTechnologyeHRPD];
    }()
    private lazy var array_x4G : [String] = {
        return [CTRadioAccessTechnologyLTE];
    }()
    
    private lazy var reachabilityManager : NetworkReachabilityManager? = {
        return NetworkReachabilityManager.init();
    }()
    private lazy var activityManager : NetworkActivityIndicatorManager = {
        return NetworkActivityIndicatorManager.shared;
    }()
    private lazy var netwotkInfo : CTTelephonyNetworkInfo = {
        return CTTelephonyNetworkInfo.init();
    }()
    
    var environmentType : CCNetworkEnvironment {
        get {
            let status : Int = UserDefaults.standard.value(forKey: _CC_NETWORK_STATUS_KEY_NEW_) as! Int;
            if status <= 0 {
                return .notReached;
            }
            if (status == 1 || status == 3 || status == 4) {
                return .weak;
            }
            if (status == 2 || status == 5) {
                return .strong
            }
            return .unknow;
        }
    }
    
    private func ccDefaultSetting() {
        self.activityManager.isEnabled = true;
        UserDefaults.standard.set(CCNetworkType.unknow.rawValue, forKey: _CC_NETWORK_STATUS_KEY_NEW_);
        UserDefaults.standard.synchronize();
    }
    
    func ccEnableMoniter() {
        self.reachabilityManager?.listener = { [unowned self] (status) in
            self.ccCaptureCurrentEnvironment(status: status);
        }
        self.reachabilityManager?.startListening();
    }
    
    private func ccCaptureCurrentEnvironment(status : NetworkReachabilityManager.NetworkReachabilityStatus) {
        var environmet : CCNetworkType = .unknow;
        if let stringAccessT = self.netwotkInfo.currentRadioAccessTechnology {
            if UIDevice.current.systemVersion.floatValue > 7.0 {
                if self.array_x4G.contains(stringAccessT) {
                    environmet = .x4G;
                }
                else if self.array_x3G.contains(stringAccessT) {
                    environmet = .x3G;
                }
                else if self.array_x2G.contains(stringAccessT) {
                    environmet = .x2G;
                }
            }
        }
        else {
            switch status {
            case .unknown:
                environmet = .unknow;
            case .reachable(.ethernetOrWiFi):
                environmet = .WiFi;
            case .reachable(.wwan):
                environmet = .WLAN;
            default:
                environmet = .Fail;
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: _CC_NETWORK_STATUS_CHANGE_NOTIFICATION_),
                                        object: nil,
                                        userInfo: [_CC_NETWORK_STATUS_KEY_NEW_ : environmet,
                                                   _CC_NETWORK_STATUS_KEY_OLD_ : UserDefaults.standard.value(forKey: _CC_NETWORK_STATUS_KEY_NEW_) ?? CCNetworkType.unknow]);
        UserDefaults.standard.set(environmet.rawValue, forKey: _CC_NETWORK_STATUS_KEY_NEW_)
        UserDefaults.standard.synchronize();
    }
    
}
