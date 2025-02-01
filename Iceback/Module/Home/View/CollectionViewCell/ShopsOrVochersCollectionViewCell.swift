//
//  ShopsOrVochersCollectionViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class ShopsOrVochersCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgShopOrVoucher: UIImageView!
    @IBOutlet weak var lblShopOrVoucherDesc: UILabel!
   @IBOutlet weak var viewBackground: UIView!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       viewBackground.backgroundColor = AppThemeManager.shared.backgroundColor
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objVoucher = object as? SpecialAndVoucherData {
            if let imageName = objVoucher.store?.logo{
                if imageName.contains(".svg") {
                    imgShopOrVoucher.sd_setImage(with: URL(string: imageName), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
                } else {
                    imgShopOrVoucher.sd_setImage(with: URL(string: imageName), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
                }
            }
           
            lblShopOrVoucherDesc.text = objVoucher.name
           lblShopOrVoucherDesc.textColor = AppThemeManager.shared.labelColor

        }
    }
}
