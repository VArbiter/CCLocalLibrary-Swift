//
//  CCAlertViewControllerExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(message stringMessage : String? ) {
        self.init(title: nil, message: stringMessage);
    }
    
    
    convenience init(title stringTitle : String? ,
                     message stringMessage : String?) {
        self.init(title: stringTitle,
                  message: stringMessage,
                  confirmButton: nil,
                  cancelButton: nil,
                  comfirmAction: nil,
                  cancelAction: nil);
    }
    
    convenience init(title stringTitle : String? ,
                     message stringMessage : String? ,
                     comfirmAction closureConfirm : CC_Closure_T? ,
                     cancelAction closureCancel : CC_Closure_T?) {
        self.init(title: stringTitle,
                  message: stringMessage,
                  confirmButton: ccLocalizeString("_CC_CONFIRM_", "确认"),
                  cancelButton: ccLocalizeString("_CC_CANCEL_", "取消"),
                  comfirmAction: closureConfirm,
                  cancelAction: closureCancel);
    }
    
    convenience init(title stringTitle : String? ,
                     message stringMessage : String? ,
                     confirmButton stringConfirmTitle : String? ,
                     cancelButton stringCancelTitle : String? ,
                     comfirmAction closureConfirm : CC_Closure_T? ,
                     cancelAction closureCancel : CC_Closure_T? ) {
        self.init(title: stringTitle, message: stringMessage, preferredStyle: .alert);
        
        if let stringConfirmT = stringConfirmTitle {
            let actionConfirm : UIAlertAction = UIAlertAction.init(title: stringConfirmT, style: .destructive, handler: { (action) in
                if let closureConfrimT = closureConfirm {
                    closureConfrimT();
                }
            })
            self.addAction(actionConfirm);
        }
        
        if let stringCancelT = stringCancelTitle {
            let actionCancel : UIAlertAction = UIAlertAction.init(title: stringCancelT, style: .cancel, handler: { (action) in
                if let closureCancelT = closureCancel {
                    closureCancelT();
                }
            })
            self.addAction(actionCancel);
        }
    }
    
//MARK: - Action Sheet
    
    /// cancel will always be 0
    /// confirm will always be 1
    /// others will be start with 2 (even if you don't have both cancel && confirm buttons)
    
    convenience init(confirm stringConfirm : String? ,
                     cancel stringCancel : String? ,
                     actionIndex closureClick : ((Int , String?) -> Void)? ){
        self.init(confirm: stringConfirm,
                  cancel: stringCancel,
                  buttons: nil,
                  actionIndex: closureClick);
    }
    
    convenience init(confirm stringConfirm : String? ,
                     cancel stringCancel : String? ,
                     buttons arrayButtons : [String]? ,
                     actionIndex closureClick : ((Int , String?) -> Void)? ){
        self.init(sheet: nil,
                  message: nil,
                  confirm: stringConfirm,
                  cancel: stringCancel,
                  buttons: arrayButtons,
                  actionIndex: closureClick);
    }
    
    convenience init(sheet stringTitle : String? ,
                     message stringMessage : String? ,
                     confirm stringConfirm : String? ,
                     cancel stringCancel : String? ,
                     buttons arrayButtons : [String]? ,
                     actionIndex closureClick : ((Int , String?) -> Void)? ) {
        self.init(title: stringTitle, message: stringMessage, preferredStyle: .actionSheet);
        
        let closureR = { (index : Int , stringTitleR : String?) -> Void in
            if let closureClickT = closureClick {
                closureClickT(index , stringTitleR);
            }
        }
        
        if let stringCancelT = stringCancel {
            let actionCancel : UIAlertAction = UIAlertAction.init(title: stringCancelT, style: .cancel, handler: { (action) in
                closureR(0 , stringCancelT);
            })
            self.addAction(actionCancel);
        }
        if let stringConfirmT = stringConfirm {
            let actionConfirm : UIAlertAction = UIAlertAction.init(title: stringConfirmT, style: .destructive, handler: { (action) in
                closureR(1 , stringConfirmT);
            })
            self.addAction(actionConfirm);
        }
        
        if let arrayButtonsT = arrayButtons {
            for (index , item) in arrayButtonsT.enumerated() {
                let model : CCAlertActionModel = CCAlertActionModel.init(stringTitle: item, index: (index + 2));
                let actionR : UIAlertAction = UIAlertAction.init(title: item, style: .default, handler: { (action) in
                    closureR(action.modelAction.index , action.modelAction.stringTitle);
                })
                actionR.modelAction = model;
                self.addAction(actionR);
            }
        }
    }
    
}

private var _CC_ASSOCIATE_KEY_ALERT_ACTION_MODEL_ : Void?;

fileprivate extension UIAlertAction {
    
    var modelAction : CCAlertActionModel {
        set {
            objc_setAssociatedObject(self,
                                     &_CC_ASSOCIATE_KEY_ALERT_ACTION_MODEL_,
                                     newValue,
                                     .OBJC_ASSOCIATION_ASSIGN);
        }
        get {
            return objc_getAssociatedObject(self, &_CC_ASSOCIATE_KEY_ALERT_ACTION_MODEL_) as! CCAlertActionModel;
        }
    }
}

fileprivate struct CCAlertActionModel {
    var stringTitle : String?;
    var index : Int = -1;
}
