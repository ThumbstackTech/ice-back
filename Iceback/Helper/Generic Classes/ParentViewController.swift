//
//  ParentViewController.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 12/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

class ParentViewController: UIViewController {
    
    @IBOutlet weak var lblUniversalDateTime: GenericLabel!
    
    var timerObj = Timer()
    
    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerObj = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(ParentViewController.updateDateTime) , userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
                
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.navigationController?.navigationBar.barTintColor = navigationTintColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @objc func updateDateTime() {
//        
//        let dateTime = Date.dateFormatFromString(dateStr: Date.todayDate(), withDateFormat: "dd MMM, yyyy h:mm a")
//        
//        if lblUniversalDateTime == nil {
//            NotificationCenter.default
//            .post(name: NSNotification.Name(rawValue: CNotificationCurrentDateTime),
//                  object: dateTime)
//        }
//        else{
//            self.lblUniversalDateTime.text = dateTime
//        }
    }
    
    @objc func backButtonClicked(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}

