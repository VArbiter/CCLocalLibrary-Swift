//
//  CCCustomFooter.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 19/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit
import MJRefresh

class CCCustomFooter: MJRefreshAutoFooter {

    /// Custom .
    
    private var _state : MJRefreshState? {
        didSet {
            if let stateT = _state {
                switch stateT {
                case .pulling: CCLog("pull");
                case .noMoreData: CCLog("noMoreData");
                case .refreshing: CCLog("refreshing");
                case .willRefresh: CCLog("willRefresh");
                default:
                    CCLog("idle");
                }
            }
        }
    }
    
    override var state: MJRefreshState {
        set {
            if self._state == newValue {
                return ;
            }
            self._state = newValue;
        }
        get {
            return self._state!;
        }
    }
    
    override func prepare() {
        super.prepare();
        
        //TODO: - CODE
    }
    
    override func placeSubviews() {
        super.placeSubviews();
        
        //TODO: - CODE
    }
    
    //MARK: - Moniter
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change);
    }
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change);
    }
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change);
    }

}
