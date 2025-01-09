//
//  DonationTableViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit
import SDWebImage

class DonationTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblMoreInformation: UILabel!
    @IBOutlet weak var lblDonationDescription: UILabel!
    @IBOutlet weak var lblDonationTitle: UILabel!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var imgDonation: UIImageView!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objDonationProjects = object as? DonationProjectsData {
            lblDonationTitle.text = objDonationProjects.title
            lblDonationDescription.text = objDonationProjects.projectSummary
            lblDonationDescription.setLineSpacing(lineSpacing: lineSpacingBetweenText)
                imgDonation.sd_setImage(with: URL(string:objDonationProjects.mainImage?.url ?? ""), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
            lblMoreInformation.text = lblMoreInformation.text?.localized()
        }
    }
}
