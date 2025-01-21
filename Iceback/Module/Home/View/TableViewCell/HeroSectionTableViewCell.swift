//
//  HeroSectionTableViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit
import SDWebImage

class HeroSectionTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblBannerDescription: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblBannerTitle: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objHeroSection = object as? ContentData {
            lblBannerTitle.text = objHeroSection.primaryContent?.withoutHtml.replacingOccurrences(of: "\n", with: "")
            lblBannerTitle.setLineSpacing(lineSpacing: 5)
            lblBannerDescription.text = objHeroSection.secondaryContent?.withoutHtml.replacingOccurrences(of: "\n", with: "")
            lblBannerDescription.setLineSpacing(lineSpacing: 3)
            btnSignUp.setTitle(BUTTONTITLE.GETMYCARD.localized(), for: .normal)
            if let imageUrl = URL(string: objHeroSection.image?.first?.url ?? ""){
                imgBanner.sd_setImage(with:  imageUrl, placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
            }
        }
    }
}
