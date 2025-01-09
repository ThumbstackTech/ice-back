//
//  ReportViewModel.swift
//  Iceback
//
//  Created by apple on 15/04/24.
//

import Foundation

class ReportViewModel {
    
     var HUD = SVProgress()
    
    var createReportDelegate:CreateReportDelegate!
    var reportListDelegate : ReportListDelegate!
    var reportDetailDelegate : ReportDetailDelegate!
    
    
    func createReport(subject: String, detail: String, key : String?){
        
        let param = ["subject":subject, "detail":detail, "key": key] as [String : Any]
        
        ReportManager.sharedInstance.createReport(param: param) { [self] data in
            self.HUD.hide()
            self.createReportDelegate.createReportSuccess(data)
        } errorCompletion: { error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error , withDelegate: nil)
        }
    }
    
    //Start - 19-4-24
    func report(pageCount: Int){
        if pageCount == 1 {
            HUD.show()
        }
        ReportManager.sharedInstance.reportList(pageCount: pageCount) { [self] data in
            
            self.HUD.hide()
            self.reportListDelegate.reportListSucess(data)
        } errorCompletion: { error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
            
        }
    } // end = 19-4-24
    
    func viewReport(id : Int){
        
        HUD.show()
        let param : [String : Any] = ["id": id]
        
        ReportManager.sharedInstance.reportView(param: param) { [self] data in
            self.HUD.hide()
            self.reportDetailDelegate.reportDetailSuccess(data)
        } errorCompletion: { error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
        }
    }
}
