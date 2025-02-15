//
//  SideMenuDataModel.swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 09/01/24.
//

import UIKit

class MenuListCell: BaseTableViewCell {

    @IBOutlet weak var switchEnable: UISwitch!
    @IBOutlet weak var lblTitle: UILabel!
   @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      viewBackground.backgroundColor = AppThemeManager.shared.secondaryColor
       lblTitle.textColor = AppThemeManager.shared.labelColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setup<T>(_ object: T) {
        if let objSideMenu = object as? String {
            lblTitle.text = objSideMenu.localized()
        }
    }
}
