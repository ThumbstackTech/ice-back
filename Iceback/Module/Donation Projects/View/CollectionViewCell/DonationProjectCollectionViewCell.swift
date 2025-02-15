//
//  DonationProjectCollectionViewCell.swift
//  Iceback
//
//  Created by Admin on 26/01/24.
//

import UIKit
import SDWebImage

class DonationProjectCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblDonationProjectDescription: UILabel!
    @IBOutlet weak var lblDonationProjectTitle: UILabel!
    @IBOutlet weak var imgDonationProject: UIImageView!
   @IBOutlet weak var viewBackground: UIView!
   @IBOutlet weak var viewMore: UIView!

    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       lblDonationProjectTitle.textColor = AppThemeManager.shared.labelColor
       lblDonationProjectDescription.textColor = AppThemeManager.shared.labelColor
       viewBackground.backgroundColor = AppThemeManager.shared.backgroundColor
      viewMore.backgroundColor = AppThemeManager.shared.primaryColor
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objDonationProject = object as? DonationProjectsData {
                imgDonationProject.sd_setImage(with: URL(string: objDonationProject.mainImage?.url ?? ""), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
            lblDonationProjectTitle.text = objDonationProject.title
            lblDonationProjectDescription.text = objDonationProject.projectSummary
        }
    }
}
