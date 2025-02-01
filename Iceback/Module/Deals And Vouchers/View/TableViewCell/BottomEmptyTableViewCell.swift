//
//  BottomEmptyTableViewCell.swift
//  Iceback
//
//  Created by Admin on 14/05/24.
//

import UIKit

class BottomEmptyTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       lblNoDataAvailable.textColor = AppThemeManager.shared.labelColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let strEmptyMessage = object as? String {
            lblNoDataAvailable.text = strEmptyMessage.localized()
        }
    }
}
