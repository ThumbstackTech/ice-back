//
//  ReportIssueDetailVC.swift
//  Iceback
//
//  Created by Admin on 11/04/24.
//

import UIKit

class ReportIssueDetailVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var lblAdminReplyDescription: UILabel!
    @IBOutlet weak var lblAdminReplyDate: UILabel!
    @IBOutlet weak var imgAdminReply: UIImageView!
    @IBOutlet weak var lblReportTitle: UILabel!
    @IBOutlet weak var lblIssueSubject: UILabel!
    @IBOutlet weak var lblReportIssueDate: UILabel!
    @IBOutlet weak var constUserViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constAdminViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgUserIssue: UIImageView!
    @IBOutlet weak var lblIssueDescription: UILabel!
    @IBOutlet weak var viewAdminReply: UIView!
    @IBOutlet weak var viewUserIssue: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var viewAdminImage: UIView!
    
    //MARK: - Constant & Variables
    var arrViewReport : [ReportListData] = []
    var reportViewModel = ReportViewModel()
    var intReportId : Int = 0
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
       initialSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - SetupController
    func setUpController() {
        reportViewModel.reportDetailDelegate = self
        reportViewModel.viewReport(id: intReportId )
    }

   func initialSetUp() {
      setLabelTextColor(labelColor: AppThemeManager.shared.labelColor)

      func setLabelTextColor(labelColor: UIColor) {

         lblReportTitle.textColor = AppThemeManager.shared.titleColor
         lblIssueDescription.textColor = labelColor
         lblAdminReplyDate.textColor = labelColor
         lblReportIssueDate.textColor = labelColor
         lblAdminReplyDescription.textColor = labelColor
      }
   }
}

//MARK: - Button Actions
extension ReportIssueDetailVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - ReportListDelegate
extension ReportIssueDetailVC : ReportDetailDelegate {
    func reportDetailSuccess(_ arrData: [ReportListData]) {
      dPrint("arrData = \(arrData.count)")
        if !arrData.isEmpty {
            lblReportTitle.text = LABELTITLE.REPORTDETAIL.localized() + "\(arrData.first?.issueNumber ?? 0)"
            arrViewReport = arrData
           lblIssueSubject.setColorOnAttributedString(fullText: arrData.first?.issueSubject ?? "", changeText: LABELTITLE.SUBJECT, labelColor: AppThemeManager.shared.labelColor)
            lblIssueSubject.attributedText = Utility.userActivitiesDescription(str: arrData.first?.issueSubject ?? "", title: LABELTITLE.SUBJECT)
            lblIssueSubject.setLineSpacing(lineSpacing: 4)
            let objUserData = arrData.filter({$0.issue_type == "user"}).first
            let objAdminData = arrData.filter({$0.issue_type == "admin"}).first
            
            if let objUser = objUserData {
                viewUserIssue.isHidden = false
                lblIssueDescription.text = objUser.issueDetail
                lblReportIssueDate.text = Common.getDateFormattedFromString(dateStr: objUser.created_at, recievedDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz" ,convertedDateFormat: "dd/MM/yyyy - HH:mm")
                lblIssueDescription.setLineSpacing(lineSpacing: 4)
                if objUser.issueImage == "" {
                    constUserViewHeight.constant = 0
                } else {
                    constUserViewHeight.constant = 150
                    imgUserIssue.sd_setImage(with: URL(string: objUser.issueImage), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
                }
            }
            
            if let objAdmin = objAdminData {
                viewAdminReply.isHidden = objAdmin.issueDetail.isEmpty ? true : false
                lblAdminReplyDescription.text = objAdmin.issueDetail
                lblAdminReplyDate.text = Common.getDateFormattedFromString(dateStr: objAdmin.updated_at, recievedDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz" ,convertedDateFormat: "dd/MM/yyyy - HH:mm")
                lblAdminReplyDescription.setLineSpacing(lineSpacing: 4)
                if objAdmin.issueImage == "" {
                    constAdminViewHeight.constant = 0
                } else {
                    constAdminViewHeight.constant = 150
                    imgAdminReply.sd_setImage(with: URL(string: objAdmin.issueImage ), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
                }
            }
        }
    }
}
