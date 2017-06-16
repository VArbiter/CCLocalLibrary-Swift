//
//  CCArrayExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 14/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import Foundation

//private var _CC_ASSOCIATE_KEY_STRING_CLASS_ : Void?;
//private var _CC_ASSOCIATE_KEY_CLOSURE_CHANGE_ : Void?;
//private var _CC_ASSOCIATE_KEY_CLOSURE_COMPLETE_ : Void?;

extension Array {
    
    /// properties "stringClass , closureChange , closureComplete" is not recomended to set, therefore I comment out it .
    /// Cause with some differences of OC , one is that the swift Array is a struct and extension Array just add a property to struct ,
    /// and a struct , by all means , not a class , use a same value . kinda flyweight , huh?
    /*
    var stringClass : String? {
        set (value) {
            objc_setAssociatedObject(self, &_CC_ASSOCIATE_KEY_STRING_CLASS_, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASSOCIATE_KEY_STRING_CLASS_) as? String;
        }
    };
    
    var closureChange : ((Any , Int) -> Void)? {
        set (value) {
            objc_setAssociatedObject(self, &_CC_ASSOCIATE_KEY_CLOSURE_CHANGE_, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASSOCIATE_KEY_CLOSURE_CHANGE_) as? ((Any, Int) -> Void);
        }
    }
    
    var closureComplete : (() -> Void)? {
        set (value) {
            objc_setAssociatedObject(self, &_CC_ASSOCIATE_KEY_CLOSURE_COMPLETE_, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASSOCIATE_KEY_CLOSURE_COMPLETE_) as? (() -> Void);
        }
    }
     */
    
    /// Swift is a type-safe language .
    /// Therefore , these function has no effect . but , the monitor of change is an exception
    /// On the other thought , why I need these monitor ?
    /*
    mutating func ccAppend<T : Equatable>(_ item : T?) { // make self (Array) mutable .
        self.ccAppend(item, itemType: nil);
    }
    mutating func ccAppend<T : Equatable>(_ item : T?, itemType clazz : String?) {
        self.ccAppend(item, itemType: clazz, changeObserver: nil, complete: nil);
    }
    mutating func ccAppend<T : Equatable>(_ item : T?,
                           itemType clazz : String? ,
                           changeObserver closureChange : ((Any , Int) -> Void)? ,
                           complete closureComplete : (() -> Void)? ) {
        var isCanAdd : Bool = false;
        
        guard (item != nil) else {
            return ;
        }
        
        let mirror : Mirror = Mirror.init(reflecting: item!); // reflect : get the item type
        if let clazzT = clazz {
            isCanAdd = "\(mirror.subjectType)" == clazzT;
        } else {
            isCanAdd = true;
        }
        if isCanAdd {
            if let itemT = (item as? Element) {
                self.append(itemT);
                if let closureChangeT = closureChange {
                    closureChangeT(itemT , self.count);
                }
                if let closureCompleteT = closureComplete {
                    closureCompleteT();
                }
            }
        }
    }
    
    mutating func ccAppend<T : Equatable>(_ items : [T]?) {
        self.ccAppend(items, objectType: nil);
    }
    mutating func ccAppend<T : Equatable>(_ items : [T]? , objectType clazz : String?) {
//      self.ccAppend(items, itemType: clazz, changeObserver: nil, complete: nil);
    }
    mutating func ccAppend<T : Equatable>(_ items : [T]? ,
                           objectType clazz : String?,
                           changeObserver closureChange : ((Any , Int) -> Void)? ,
                           complete closureComplete : (() -> Void)? ) {
        guard (items != nil) else {
            return ;
        }
        
        for object in items! {
            var isCanAdd : Bool = false;
            let mirror : Mirror = Mirror.init(reflecting: object);
            if let clazzT = clazz {
                isCanAdd = "\(mirror.subjectType)" == clazzT;
            } else {
                isCanAdd = true;
            }
            if isCanAdd {
                if let objectT = (object as? Element) {
//                    self.append(object);
                    if let closureChangeT = closureChange {
                        closureChangeT(object , self.count);
                    }
                }
            }
        }
        if let closureCompleteT = closureComplete {
            closureCompleteT();
        }
    }
     */
    
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
                           complete closureComplete : (() -> Void)? ) {
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
                              complete closureComplete : (() -> Void)? ) {
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
