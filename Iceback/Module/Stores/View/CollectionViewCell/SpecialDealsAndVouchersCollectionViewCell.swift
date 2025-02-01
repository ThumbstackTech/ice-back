//
//  SpecialDealsAndVouchersCollectionViewCell.swift
//  Iceback
//
//  Created by Admin on 16/01/24.
//

import UIKit

class SpecialDealsAndVouchersCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgVoucher: UIImageView!
    @IBOutlet weak var lblVoucherTitle: UILabel!
    @IBOutlet weak var lblVoucherDetail: UILabel!
   @IBOutlet weak var viewBackground: UIView!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       initializeSetUp()
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objVoucher = object as? DealsAndVouchersData {
                imgVoucher.sd_setImage(with:  URL(string: objVoucher.store?.logo ?? ""), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
            
            lblVoucherTitle.text = objVoucher.type
            lblVoucherDetail.text = "\(objVoucher.name)"
        }
    }

   func initializeSetUp() {
      lblVoucherTitle.textColor = AppThemeManager.shared.labelColor
      lblVoucherDetail.textColor = AppThemeManager.shared.labelColor
      viewBackground.backgroundColor = AppThemeManager.shared.backgroundColor
   }
}
