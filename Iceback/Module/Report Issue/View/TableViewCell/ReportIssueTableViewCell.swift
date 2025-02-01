//
//  ReportIssueTableViewCell.swift
//  Iceback
//
//  Created by Admin on 10/04/24.
//

import UIKit

class ReportIssueTableViewCell: BaseTableViewCell {

   @IBOutlet weak var lblIssueDate: UILabel!
   @IBOutlet weak var lblIssueSubject: UILabel!
   @IBOutlet weak var lblIssueId: UILabel!
   @IBOutlet weak var viewDash: UIView!

   var subj = "Subject: "


   override func awakeFromNib() {
      super.awakeFromNib()
      initiaSetUp()
   }

   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
   }

   override func layoutSubviews() {
      GCDMainThread.async { [self] in
         viewDash.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 2)
      }
   }


   func initiaSetUp() {
      lblIssueId.textColor = AppThemeManager.shared.labelColor
      lblIssueDate.textColor = AppThemeManager.shared.labelColor
      lblIssueSubject.textColor = AppThemeManager.shared.labelColor
   }

   //MARK: - Setup Data
   override func setup<T>(_ object: T) {
      if let objPagiList = object as? ReportListData {
         lblIssueSubject.attributedText = Utility.userActivitiesDescription(str: objPagiList.issueSubject, title: LABELTITLE.SUBJECT)
         lblIssueId.text = "ID\(objPagiList.issueNumber)"
         lblIssueDate.text = Common.getDateFormattedFromString(dateStr: objPagiList.created_at, recievedDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz", convertedDateFormat: "dd/MM/yyyy")
         lblIssueSubject.setLineSpacing(lineSpacing: 4)
      }

   }
}

