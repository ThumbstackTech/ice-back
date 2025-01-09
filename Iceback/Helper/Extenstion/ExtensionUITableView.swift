//
//  ExtensionUITableView.swift
//  RCTalk
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import UIKit

extension UITableView {

    var pullToRefreshControl: UIRefreshControl? {
        get {
            if #available(iOS 10.0, *) {
                return self.refreshControl
            } else {
                return self.viewWithTag(9876) as? UIRefreshControl
            }
        } set {
            if #available(iOS 10.0, *) {
                self.refreshControl = newValue
            } else {
                if let refreshControl = newValue {
                    refreshControl.tag = 9876
                    self.addSubview(refreshControl)
                }
            }
        }
    }
    
    func lastIndexPath() -> IndexPath?
    {
        let sections = self.numberOfSections
        
        if (sections<=0){
            return nil
        }
        
        let rows = self.numberOfRows(inSection: sections-1)
        
        if (rows<=0){return nil}
        
        return IndexPath(row: rows-1, section: sections-1)
    }
    
    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let cellName = String(describing: T.self)
        
        if Bundle.main.path(forResource: cellName, ofType: "nib") != nil {
            let nib = UINib(nibName: cellName, bundle: Bundle.main)
            
            register(nib, forCellReuseIdentifier: cellName)
        } else {
            register(T.self, forCellReuseIdentifier: cellName)
        }
    }
    
}

extension UITableView {
  func showLoadingFooter() {
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))

    self.tableFooterView = spinner
    self.tableFooterView?.isHidden = false
  }
  
  func hideLoadingFooter() {
    self.tableFooterView?.isHidden = true
    self.tableFooterView = nil
  }
}
