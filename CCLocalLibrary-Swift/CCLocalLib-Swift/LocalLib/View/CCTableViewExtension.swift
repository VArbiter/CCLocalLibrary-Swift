//
//  CCTableViewExtension.swift
//  CCLocalLibrary-Swift
//
//  Created by 冯明庆 on 22/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    
    convenience init(common frame : CGRect ) {
        self.init(common: frame, delegateDataSource: nil);
    }
    
    convenience init(common frame : CGRect ,
                     delegate : UITableViewDelegate? ,
                     dataSource : UITableViewDataSource? ) {
        self.init(common: frame,
                  style: .plain,
                  delegate: delegate,
                  dataSource: dataSource);
    }
    
    convenience init(common frame : CGRect ,
                     delegateDataSource : Any? ){
        self.init(common: frame,
                  style: .plain,
                  delegateDataSource: delegateDataSource);
    }
    
    convenience init(common frame : CGRect ,
                     style : UITableViewStyle ,
                     delegateDataSource : Any? ) {
        self.init(common: frame,
                  style: style,
                  delegate: delegateDataSource as? UITableViewDelegate,
                  dataSource: delegateDataSource as? UITableViewDataSource);
    }
    
    convenience init(common frame : CGRect ,
                     style : UITableViewStyle ,
                     delegate : UITableViewDelegate? ,
                     dataSource : UITableViewDataSource? ) {
        self.init(frame: frame, style: style);
        if let delegateT = delegate {
            self.delegate = delegateT;
        }
        if let dataSourceT = dataSource {
            self.dataSource = dataSourceT;
        }
        
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        self.separatorStyle = .none;
        self.backgroundColor = UIColor.clear;
        self.bounces = true;
    }
    
    func ccRegist(nib string : String) {
        self.ccRegist(nib: string, bundle: Bundle.main);
    }
    func ccRegist(nib string : String , bundle : Bundle?) {
        self.register(UINib.init(nibName: string,
                                 bundle: bundle),
                      forCellReuseIdentifier: string);
    }
    func ccRegist(class string : String) {
        self.register(NSClassFromString(string),
                      forCellReuseIdentifier: string);
    }
    
    func ccUpdating(_ closure : CC_Closure_T) {
        self.beginUpdates();
        CC_Safe_UI_Closure(closure) { 
            closure();
        }
        self.endUpdates();
    }
    
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
    
    func ccReload(section : Int) {
        self.ccReload(sections: [section]);
    }
    func ccReload(sections : [Int]) {
        var index : IndexSet = IndexSet.init();
        for item in sections {
            index.insert(item);
        }
        self.reloadSections(index, with: .automatic);
    }
    
}

extension Array {
    
    func ccReload(tableView : UITableView , section : Int) {
        if self.isArrayValued {
            tableView.ccReload(section: section);
        }
    }

    func ccReload(tableView : UITableView) {
        if self.isArrayValued {
            tableView.ccReload(section: 0);
        } else {
            tableView.reloadData();
        }
    }
    
}

class CCTableViewDelegate : NSObject , UITableViewDelegate {
    
    var closureCellHeight : ((UITableView , IndexPath) -> CGFloat)? ;
    var closureSectionHeaderHeight : ((UITableView , Int) -> CGFloat)? ;
    var closureSectionHeader : ((UITableView , Int) -> UIView?)? ;
    var closureDidSelect : ((UITableView , IndexPath) -> Bool)? ;
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let closureCellHeightT = self.closureCellHeight {
            return closureCellHeightT(tableView , indexPath) ;
        }
        return 45.0;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let closureSectionHeaderHeightT = self.closureSectionHeaderHeight {
            return closureSectionHeaderHeightT(tableView , section) ;
        }
        return 0.0;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let closureSectionHeaderT = self.closureSectionHeader {
            return closureSectionHeaderT(tableView , section) ;
        }
        return nil;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let closureDidSelectT = self.closureDidSelect {
            if closureDidSelectT(tableView , indexPath) {
                tableView.deselectRow(at: indexPath, animated: false);
            }
        }
    }
    
    deinit {
        CCLogFunctionInfo();
    }
    
}

class CCTableViewDataSource : NSObject , UITableViewDataSource {
    
    var closureSections : ((UITableView) -> Int)? ;
    var closureRowsInSection : ((UITableView , Int) -> Int)? ;
    var closureCellIdentifier : ((UITableView , IndexPath) -> String)? ;
    var closureConfigureCell : ((UITableView , UITableViewCell? , IndexPath) -> UITableViewCell)? ;
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let closureSectionsT = self.closureSections {
            return closureSectionsT(tableView);
        }
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let closureRowsInSectionT = self.closureRowsInSection {
            return closureRowsInSectionT(tableView , section);
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.closureConfigureCell != nil else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "CELL_ID");
        }
        
        if let closureCellIdentifierT = self.closureCellIdentifier {
            let stringIdentifier : String = closureCellIdentifierT(tableView , indexPath);
            let cell = tableView.dequeueReusableCell(withIdentifier: stringIdentifier,
                                                     for: indexPath);
            return self.closureConfigureCell!(tableView , cell , indexPath);
        } else {
            let stringIdentifier : String = "CELL_ID";
            var cell = tableView.dequeueReusableCell(withIdentifier: stringIdentifier);
            if let cellT = cell {
                return self.closureConfigureCell!(tableView , cellT , indexPath);
            } else {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: stringIdentifier);
                return self.closureConfigureCell!(tableView , cell , indexPath);
            }
        }
    }
    
    deinit {
        CCLogFunctionInfo();
    }
    
}
