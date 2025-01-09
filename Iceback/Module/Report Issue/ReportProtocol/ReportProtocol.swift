//
//  ReportProtocol.swift
//  Iceback
//
//  Created by apple on 15/04/24.
//

import Foundation

protocol CreateReportDelegate{
    func createReportSuccess(_ arrData: ReportListData)
    
}

protocol ReportListDelegate {
    func reportListSucess(_ arrData: [ReportListData])
}

protocol ReportDetailDelegate {
    func reportDetailSuccess(_ arrData: [ReportListData])
}


protocol AppendCreateReportIssueDelegate {
    func appendReportIssueData(_ objData: ReportListData)
}
