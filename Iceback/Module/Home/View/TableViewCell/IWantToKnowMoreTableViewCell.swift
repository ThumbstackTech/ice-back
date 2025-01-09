//
//  IWantToKnowMoreTableViewCell.swift
//  Iceback
//
//  Created by Admin on 10/01/24.
//

import UIKit

class IWantToKnowMoreTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblStepDescription: UILabel!
    @IBOutlet weak var lblStepTitle: UILabel!
    @IBOutlet weak var lblStepNo: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        GCDMainThread.async { [self] in
            lblStepNo.circleCorner = true
            lblStepNo.clipsToBounds = true
        }
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objHowItWorksItem = object as? HowItWorksItem {
            lblStepNo.text = "0\(tag)"
            lblStepTitle.text = objHowItWorksItem.title
            lblStepDescription.text = objHowItWorksItem.subtitle
        }
    }
    
}
