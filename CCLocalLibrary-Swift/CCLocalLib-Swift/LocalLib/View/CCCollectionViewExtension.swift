//
//  CCCollectionViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit
import MJRefresh

extension UICollectionView {
    
    convenience init?(_ frame : CGRect? ,
                     forLayout layout : UICollectionViewLayout? ,
                     forDelegateDataSource delegateDataSource : Any?) {
        self.init(frame,
                  forLayout: layout,
                  forDelegate: delegateDataSource,
                  forDataSource: delegateDataSource);
    }
    
    convenience init?(_ frame : CGRect? ,
                     forLayout layout : UICollectionViewLayout? ,
                     forDelegate delegate : Any?,
                     forDataSource dataSource : Any?) {
        guard layout != nil else {
            return nil;
        }
        var frameR : CGRect = CGRect.zero;
        if let frameT = frame {
            frameR = frameT;
        }
        self.init(frame: frameR, collectionViewLayout: layout!);
        self.backgroundColor = UIColor.clear;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        
        if let delegateT = delegate {
            self.delegate = delegateT as? UICollectionViewDelegate;
        }
        if let dataSourceT = dataSource {
            self.dataSource = dataSourceT as? UICollectionViewDataSource;
        }
    }
    
    /// Loading functions
    
    func ccLoad(refreshing closureRefreshing : (() -> CCViewEndLoadType)? ,
                loading closureLoading : (() -> CCViewEndLoadType)? ) {
        if let closureRefreshingT = closureRefreshing {
            let customHeader : CCCustomHeader = CCCustomHeader.init();
            customHeader.refreshingBlock = { [unowned self] in
                if closureRefreshingT() != CCViewEndLoadType.manualEnd {
                    self.mj_header.endRefreshing();
                }
            };
            self.mj_header = customHeader;
        }
        if let closureLoadingT = closureLoading {
            let customFooter : CCCustomFooter = CCCustomFooter.init();
            customFooter.refreshingBlock = { [unowned self] in
                switch closureLoadingT() {
                case .noMoreData:
                    self.mj_footer.endRefreshing();
                case .manualEnd:
                    CCLog("ManualEnd");
                default:
                    self.mj_footer.endRefreshing();
                }
            };
            self.mj_footer = customFooter;
        }
    }
    
    func ccHeaderEndRefreshing() {
        self.mj_header.endRefreshing();
    }
    
    func ccFooterEndLoading(_ type : CCViewEndLoadType?) {
        if let typeT = type {
            switch typeT {
            case .noMoreData:
                self.mj_footer.endRefreshingWithNoMoreData();
            default:
                self.mj_footer.endRefreshing();
            }
        }
    }
    
    func ccEndLoading() {
        self.ccHeaderEndRefreshing();
        self.ccFooterEndLoading(.nonee);
    }
    
    func ccResetLoadMoreStatus() {
        self.mj_footer.resetNoMoreData();
    }
    
    /// When use functions below to regist a cell ,
    /// hightly recomdend to INIT a new cell when collectionView can't find one in reuse pool ,
    /// prevent crash if you want to ask.
    
    func ccRegist(nib stringNib : String?) {
        guard stringNib != nil else {
            return;
        }
        
        self.register(.init(nibName: stringNib!, bundle: .main), forCellWithReuseIdentifier: stringNib!);
    }
    
    func ccRegist(class stringClass : String?) {
        guard stringClass != nil else {
            return;
        }
        
        if let stringClassT = NSClassFromString(stringClass!) {
            self.register(stringClassT, forCellWithReuseIdentifier: stringClass!);
        }
    }
    
    /// Functions below is used for hide animate ,
    /// like flash white in collectionView (specific).
    
    fileprivate func ccReloadData() {
        self.ccReloadSections(IndexSet.init(integer: 0));
    }
    
    fileprivate func ccReloadSections(_ indexSet : IndexSet?) {
        guard indexSet != nil else {
            return;
        }
        
        CC_Main_Queue_Operation {
            UIView.setAnimationsEnabled(false);
            self.performBatchUpdates({ [unowned self] in
                self.reloadSections(indexSet!);
            }, completion: { (isComplete) in
                UIView.setAnimationsEnabled(true);
            })
        }
    }
    
}

/// Use these functions when the array instance is a datasource for collectionView .
extension Array {
    
    func ccReloadData(with collectionView : UICollectionView?) {
        if let collectionViewT = collectionView {
            if self.count > 0 {
                collectionViewT.ccReloadData();
            } else {
                collectionViewT.reloadData();
            }
        }
    }
    
    func ccReloadSections(with collectionView : UICollectionView? ,
                      sections indexSet : IndexSet?) {
        if let collectionViewT = collectionView {
            collectionViewT.ccReloadSections(indexSet);
        }
    }
    
}
