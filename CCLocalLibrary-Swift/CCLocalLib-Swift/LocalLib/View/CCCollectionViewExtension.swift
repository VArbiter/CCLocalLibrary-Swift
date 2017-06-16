//
//  CCCollectionViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 16/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UICollectionView {
    
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
