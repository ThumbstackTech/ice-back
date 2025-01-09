//
//  UserActivitiesTableViewCell.swift
//  Iceback
//
//  Created by Admin on 08/05/24.
//

import UIKit

class UserActivitiesTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblDealName: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var constDealsNameTop: NSLayoutConstraint!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objActivity = object as? Activity {
          
            let date = Common.getDateFormattedFromString(dateStr: objActivity.createdAt, recievedDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz", convertedDateFormat: "dd/MM/yyyy - HH:mm")
            lblDate.attributedText = Utility.userActivitiesDescription(str: date ?? "", title: "Date")
            lblShopName.attributedText = Utility.userActivitiesDescription(str: objActivity.store?.name ?? "", title: "Shop")
            
            if objActivity.deal != nil {
                constDealsNameTop.constant = 10
                lblDealName.attributedText = Utility.userActivitiesDescription(str: objActivity.deal?.name ?? "", title: "Deal")
                lblDealName.setLineSpacing(lineSpacing: 4)
            }else {
                constDealsNameTop.constant = 0
            }
        }
    }
}
