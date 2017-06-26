//
//  CCArrayExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

extension Array {
    
    func ccValueAt(_ index : Int) -> Any? {
        return self.ccValueAt(index, closure: nil);
    }
    
    func ccValueAt(_ index : Int, closure : ((_ item : Any) -> Void)?) -> Any? {
        if self.isArrayValued {
            if self.count > index {
                if let closureT = closure {
                    closureT(self[index]);
                }
                return self[index];
            }
            return nil;
        }
        return nil;
    }
    
    mutating func ccRemove<T : Equatable>(_ item : T?) {
        self.ccRemove(item, itemType: nil);
    }
    mutating func ccRemove<T : Equatable>(_ item : T? , itemType clazz : String?) {
        self.ccRemove(item, itemType: clazz, changeObserver: nil, complete: nil);
    }
    mutating func ccRemove<T : Equatable>(_ item : T? ,
                           itemType clazz : String? ,
                           changeObserver closureChange : ((Any , Int , Int) -> Void)? , // item , index before delete (but already change with next delete action) , totalCount
                           complete closureComplete : CC_Closure_T? ) {
        guard (item != nil) else {
            return;
        }
        
        var isCanRemove : Bool = false;
        let mirror : Mirror = Mirror.init(reflecting: item!);
        if let clazzT = clazz {
            isCanRemove = "\(mirror.subjectType)" == clazzT;
        } else {
            isCanRemove = true;
        }
        
        if isCanRemove {
            if self.isArrayValued {
                if let arrayIndexT = self.ccFindAllItemIndexWith(item) {
                    for index in arrayIndexT {
                        self.remove(at: index);
                        if let closureChangeT = closureChange {
                            closureChangeT(item!, index , self.count);
                        }
                    }
                    if let closureCompleteT = closureComplete {
                        closureCompleteT();
                    }
                }
            }
        }
    }
    
    /// Where the "removeAll" functions existing below , not recomended to use .
    mutating func ccRemoveAll(itemType clazz : String? ,
                              comfirm closure : @escaping (Any , Bool) -> Bool ) {
        self.ccRemoveAll(itemType: clazz,
                         comfirm: closure,
                         changeObserver: nil,
                         complete: nil);
    }
    mutating func ccRemoveAll(itemType clazz : String? ,
                              comfirm closure : ((Any , Bool) -> Bool)? ,
                              changeObserver closureChange : ((Any , Int , Int) -> Void)? ,
                              complete closureComplete : CC_Closure_T? ) {
        guard (self.count > 0) else {
            return ;
        }
        
        for i in 0..<self.count {
            let object : AnyHashable? = self.ccValueAt(i) as? AnyHashable;
            guard (object != nil) else {
                return;
            }
            
            var isCanRemove : Bool = false;
            let mirror : Mirror = Mirror.init(reflecting: object!);
            if let clazzT = clazz {
                isCanRemove = "\(mirror.subjectType)" == clazzT;
            } else {
                isCanRemove = true;
            }
            
            if isCanRemove {
                if let arrayT = self.ccFindAllItemIndexWith(object) {
                    if let closureT = closure {
                        if closureT(object! , isCanRemove) {
                            for index in arrayT {
                                self.remove(at: index);
                                if let closureChangeT = closureChange {
                                    closureChangeT(object! , index , self.count);
                                }
                            }
                        }
                    }
                }
            }
        }
        if let closureCompleteT = closureComplete {
            closureCompleteT();
        }
        
    }
    
    /// once remove a object , all indexs for items will be changed .
    /// find all indexs for specific item .
    func ccFindAllItemIndexWith<T : Equatable>(_ item : T? ) -> [Int]? {
        return Array.ccFindAllItemIndexIn(self as? [T], item: item);
    }
    
    static func ccFindAllItemIndexIn<T : Equatable>(_ array : [T]? , item : T? ) -> [Int]? {
        guard (array != nil && item != nil) else {
            return nil;
        }
        
        var arrayIndex : [Int] = [];
        var arrayCorrect : [Int] = [];
        
        for (index , _) in array!.enumerated() {
            if array![index] == item {
                arrayIndex.append(index);
            }
        }
        if !arrayIndex.isArrayValued {
            return nil;
        }
        
        for (index , value) in arrayIndex.enumerated() {
            let indexCorrect : Int = value - index;
            arrayCorrect.append(indexCorrect);
        }
        return arrayCorrect;
    }
    
}

//MAEK: - Reload

import UIKit

/// Use these functions when the array instance is a datasource for collectionView || tableView.
extension Array {
    
    func ccReload(_ view : AnyObject?) {
        self.ccReload(view, sections: [0]);
    }
    
    func ccReload(_ view : AnyObject? ,
                  sections : [Int]?) {
        if let viewT = view as? UITableView {
            if self.isArrayValued {
                if let arrayT = sections {
                    viewT.ccReload(sections: arrayT);
                } else {
                    viewT.ccReload(sections: [0]);
                }
            } else {
                viewT.reloadData();
            }
        }
        else if let viewR = view as? UICollectionView {
            if self.isArrayValued {
                if let arrayT = sections {
                    viewR.ccReloadSections(arrayT);
                } else {
                    viewR.ccReloadSections([0]);
                }
            } else {
                viewR.reloadData();
            }
        }
    }
    
}
