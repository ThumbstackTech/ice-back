//
//  NotificationTableViewCell.swift
//  Iceback
//
//  Created by Admin on 01/04/24.
//

import UIKit

class NotificationTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblNotificationDescription: UILabel!
    @IBOutlet weak var lblNotificationDate: UILabel!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       initializeSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   func initializeSetUp() {
      setLabelTextColor(labelColor: AppThemeManager.shared.labelColor)

      func setLabelTextColor(labelColor: UIColor) {
         lblNotificationTitle.textColor = labelColor
         lblNotificationDate.textColor = labelColor
         lblNotificationDescription.textColor = labelColor
      }
   }
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objNotificationDataModel = object as? NotifcationData {
            lblNotificationTitle.text = objNotificationDataModel.title
           lblNotificationDate.text = Common.getDateFormattedFromString(dateStr: objNotificationDataModel.createdAt, recievedDateFormat: DateFormat.FullDateHHMMSSZZZ, convertedDateFormat: DateFormat.DDMMYYYY) 
            lblNotificationDescription.text = objNotificationDataModel.description
        }
    }
}
