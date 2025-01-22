//
//  PaymentOptionsCollectionViewCell.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class PaymentOptionsCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgPaymentOptions: UIImageView!
    @IBOutlet weak var constImagePayementOptionHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var constImagePayementOptionWidth: NSLayoutConstraint!

    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        
        if let objRegionFlag = object as? String {
            if objRegionFlag.contains(".svg") {
                imgPaymentOptions.sd_setImage(with: URL(string: objRegionFlag), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
            } else {
                imgPaymentOptions.sd_setImage(with: URL(string: objRegionFlag), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
            }
            viewBackground.cornerRadius = 0
        }
        
        if let objVoucher = object as? PaymentOptionsInfoData {
            if let imageUrl = URL(string: objVoucher.logo){
                if objVoucher.logo.contains(".svg") {
                    imgPaymentOptions.sd_setImage(with: imageUrl, placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
                } else {
                    imgPaymentOptions.sd_setImage(with: imageUrl, placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
                }
            }
        }
    }
}
            
