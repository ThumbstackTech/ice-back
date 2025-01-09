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
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
