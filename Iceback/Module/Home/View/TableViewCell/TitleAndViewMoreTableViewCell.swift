//
//  TitleAndViewMoreTableViewCell.swift
//  Iceback
//
//  Created by Admin on 09/01/24.
//

import UIKit

class TitleAndViewMoreTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblViewMoreTitle: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        btnViewMore.setTitle(BUTTONTITLE.VIEWMORE.localized(), for: .normal)
       lblViewMoreTitle.textColor = AppThemeManager.shared.labelColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        
    }
}
