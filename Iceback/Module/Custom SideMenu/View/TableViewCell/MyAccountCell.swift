//
//  MyAccountCell.swift
//  DashCam
//
//  Created by Admin on 29/04/22.
//

import UIKit

class MyAccountCell: BaseTableViewCell {

    @IBOutlet weak var imgLanguageSelect: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewDashLine: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        GCDMainThread.async { [self] in
            viewDashLine.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 4)
            viewDashLine.alpha = 0.5
        }
    }
    
    override func setup<T>(_ object: T) {
        if let objLanguageSelect = object as? SelectLanguageModel {
            lblTitle.text = objLanguageSelect.SelectLanguage
            imgLanguageSelect.image =  objLanguageSelect.isSelect ? IMAGES.ICN_LANGUAGE_SELECTED : IMAGES.ICN_LANGUAGE_UNSELECTED
        }
    }
}
