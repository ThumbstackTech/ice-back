//
//  HowItWorksStepsTableViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit

class HowItWorksStepsTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblStepTitle: UILabel!
    @IBOutlet weak var lblStepNo: UILabel!
   @IBOutlet weak var viewBackground: UIView!
    
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
    
    override func layoutSubviews() {
        GCDMainThread.async { [self] in
            lblStepNo.clipsToBounds = true
            lblStepNo.circleCorner = true
        }
    }
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objHowItWorks = object as? HowItWorksItem {
            lblStepNo.text = "0\(tag + 1)"
            lblStepTitle.text = objHowItWorks.title
        }
    }

   func initializeSetUp() {
      lblStepNo.textColor = AppThemeManager.shared.labelColor
     lblStepNo.backgroundColor = AppThemeManager.shared.secondaryColor
      lblStepTitle.textColor = AppThemeManager.shared.labelColor
      lblStepTitle.font = AppThemeManager.shared.setTextFont(fontWeight: .bold)
      viewBackground.backgroundColor = AppThemeManager.shared.backgroundColor
   }
}
