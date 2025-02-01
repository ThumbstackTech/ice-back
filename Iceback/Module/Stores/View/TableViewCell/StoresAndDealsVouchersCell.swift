//
//  StoresAndDealsVouchersCell.swift
//  Iceback
//
//  Created by APPLE on 10/01/24.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class StoresAndDealsVouchersCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnShopNow: UIButton!
    @IBOutlet weak var imgCoupon: UIImageView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collShippingFlag: UICollectionView!
    @IBOutlet weak var constShippingFlagHeight: NSLayoutConstraint!
    @IBOutlet weak var constShippingFlagTop: NSLayoutConstraint!
   @IBOutlet weak var viewBackground: UIView!
    
    //MARK: - Constant & Variables
    var arrShippingAndDeliveryFlag = [String]() {
        didSet {
            collShippingFlag.reloadData()
        }
    }
 
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        languageLocalize()
        xibRegister()
       initialSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        btnShopNow.setTitle(BUTTONTITLE.MOREINFORMATION.localized(), for: .normal)
    }

    //MARK: - XIB Register
    func xibRegister() {
        collShippingFlag.delegate = self
        collShippingFlag.dataSource = self
        collShippingFlag.register(nibWithCellClass: PaymentOptionsCollectionViewCell.self)
    }

   func initialSetUp() {
      btnShopNow.backgroundColor = AppThemeManager.shared.primaryColor
      btnShopNow.setTitleColor(AppThemeManager.shared.buttonTitleColor, for: .normal)
      lblTitle.textColor = AppThemeManager.shared.labelColor
      viewBackground.backgroundColor = AppThemeManager.shared.backgroundColor
   }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
     
        if let objStores = object as? storeDataListObject {
            arrShippingAndDeliveryFlag.removeAll()
            arrShippingAndDeliveryFlag = objStores.regionLogo
         
            if objStores.logo.contains(".svg") {
                imgCoupon.sd_setImage(with: URL(string: objStores.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
            } else {
                imgCoupon.sd_setImage(with: URL(string: objStores.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
            }
            
            if objStores.maxCashbackPercentage != 0.0 {
                lblTitle.attributedText = Utility.couponPercentageMultipleAttribute(discountValue: Double(objStores.maxCashbackPercentage))
            } else {
                lblTitle.attributedText = Utility.couponPercentageMultipleAttribute(discountValue: Double(objStores.maxCashbackAmount), isCHF: true)
            }
            lblTitle.numberOfLines = 1
            lblTitle.adjustsFontSizeToFitWidth = true
            lblTitle.minimumScaleFactor = 0.5
            
            if objStores.isFavourite == 1 {
                btnFavourite.setImage(IMAGES.ICN_FAVOURITE, for: .normal)
            } else {
                btnFavourite.setImage(IMAGES.ICN_UNFAVOURITE, for: .normal)
            }
            constShippingFlagTop.constant = arrShippingAndDeliveryFlag.isEmpty ? 0 : 20
            self.constShippingFlagHeight.constant = arrShippingAndDeliveryFlag.isEmpty ? 0 : collShippingFlag.collectionViewLayout.collectionViewContentSize.height
            self.layoutIfNeeded()
        }
        
        if let objDealsAndVouchers = object as? DealsAndVouchersData {
            constShippingFlagTop.constant = 0
            constShippingFlagHeight.constant = 0
            if let imageName = objDealsAndVouchers.store?.logo {
                if imageName.contains(".svg") {
                    imgCoupon.sd_setImage(with: URL(string: imageName), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
                } else {
                    imgCoupon.sd_setImage(with: URL(string: imageName), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
                }
            }
            lblTitle.text = objDealsAndVouchers.name
           lblTitle.textColor = AppThemeManager.shared.textColor
        }
    }
    
}


//MARK: - UICollectionViewDataSource
extension StoresAndDealsVouchersCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrShippingAndDeliveryFlag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: PaymentOptionsCollectionViewCell.self, indexPath: indexPath)
        cell.constImagePayementOptionWidth.constant = 30
        cell.constImagePayementOptionHeight.constant = 23
        cell.setup(arrShippingAndDeliveryFlag[indexPath.item])
        return cell
    }
    
    
}


//MARK: - UICollectionViewDelegate
extension StoresAndDealsVouchersCell : UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension StoresAndDealsVouchersCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 23)
    }
}
