//
//  ShopsOrVochersCollectionViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class ShopsWithCashbackCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgShopOrVoucher: UIImageView!
    @IBOutlet weak var collShippingFlag: UICollectionView!
    @IBOutlet weak var lblShopOrVoucherDesc: UILabel!
    @IBOutlet weak var constShippingFlagHeight: NSLayoutConstraint!
    @IBOutlet weak var constShippingFlagTop: NSLayoutConstraint!

    //MARK: - Constant & Variables
    var arrShippingAndDeliveryFlag = [String]() {
        didSet {
            collShippingFlag.reloadData()
        }
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        collShippingFlag.delegate = self
        collShippingFlag.dataSource = self
        collShippingFlag.register(nibWithCellClass: PaymentOptionsCollectionViewCell.self)
    }
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        lblShopOrVoucherDesc.text = ""
        imgShopOrVoucher.image = nil
        xibRegister()
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objCashback = object as? ShopWithCashbackData {
                arrShippingAndDeliveryFlag.removeAll()
                arrShippingAndDeliveryFlag = objCashback.regionLogo
            
            if let imageName = objCashback.logo {
                if imageName.contains(".svg") {
                    imgShopOrVoucher.sd_setImage(with: URL(string: imageName), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
                } else {
                    imgShopOrVoucher.sd_setImage(with: URL(string: imageName), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
                }
            }
            lblShopOrVoucherDesc.attributedText = Utility.couponPercentageMultipleAttribute(discountValue: objCashback.maxCashbackPercentage)
            lblShopOrVoucherDesc.adjustsFontSizeToFitWidth = true
            lblShopOrVoucherDesc.minimumScaleFactor = 0.5
            
            constShippingFlagTop.constant = arrShippingAndDeliveryFlag.isEmpty ? 0 : 10
            self.constShippingFlagHeight.constant = arrShippingAndDeliveryFlag.isEmpty ? 0 : collShippingFlag.collectionViewLayout.collectionViewContentSize.height
            self.layoutIfNeeded()
        }
    }
}


//MARK: - UICollectionViewDataSource
extension ShopsWithCashbackCollectionViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrShippingAndDeliveryFlag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: PaymentOptionsCollectionViewCell.self, indexPath: indexPath)
        cell.constImagePayementOptionWidth.constant = 35
        cell.constImagePayementOptionHeight.constant = 25
        cell.setup(arrShippingAndDeliveryFlag[indexPath.item])
        return cell
    }
    
    
}


//MARK: - UICollectionViewDelegate
extension ShopsWithCashbackCollectionViewCell : UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ShopsWithCashbackCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 15)
    }
}
