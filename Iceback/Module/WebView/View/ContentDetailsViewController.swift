//
//  ContentDetailsViewController.swift
//  Iceback
//
//  Created by Gourav Joshi on 10/02/25.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class ContentDetailsViewController: UIViewController {

  var objDealsAndVoucherDetailData : DealsAndVoucherDetailData?
  var objStoreDetail: StoreDetailsNewModel?
  private var arrTargetLink: [MultipleClickURL] = []
  @IBOutlet weak var lblMaximumCashBack: UILabel!
  @IBOutlet weak var lblCashbBackAmtValue: UILabel!
  @IBOutlet weak var lblCashBackDiscount: UILabel!
  @IBOutlet weak var lblTermsAndConditionsHeading: UILabel!
  @IBOutlet weak var lblDescription1: UILabel!
  @IBOutlet weak var lblDescription2: UILabel!
  @IBOutlet weak var lblDescription3: UILabel!
  @IBOutlet weak var imgViewLogo: UIImageView!
  @IBOutlet weak var viewCashBack: UIView!
  @IBOutlet weak var viewTermsConditions: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      lblCashbBackAmtValue.layer.masksToBounds = true
      lblCashbBackAmtValue.backgroundColor = .app1F8DFF
      lblCashbBackAmtValue.textColor = .white
      lblMaximumCashBack.textColor = .app1F8DFF
      setLocalizedContent()
      setViewBorder()
        // Do any additional setup after loading the view.
    }
    
  override func viewWillAppear(_ animated: Bool) {
    if let obStore = objStoreDetail {
      lblCashbBackAmtValue.text = " \(obStore.max_cashback_percentage)% "
      if obStore.logo.contains(".svg") {
        imgViewLogo.sd_setImage(with: URL(string: obStore.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
      } else {
        imgViewLogo.sd_setImage(with: URL(string: obStore.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
      }
    }
    
    if let obDealsVoucher = objDealsAndVoucherDetailData {
      lblCashbBackAmtValue.text = " \(obDealsVoucher.maxCashbackPercentage)% "
      if obDealsVoucher.logo.contains(".svg") {
        imgViewLogo.sd_setImage(with: URL(string: obDealsVoucher.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
      } else {
        imgViewLogo.sd_setImage(with: URL(string: obDealsVoucher.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
      }
    }
  }

  
  func setLocalizedContent() {
    lblCashBackDiscount.text = LABELTITLE.CashbackAndDiscounts.localized()
    lblDescription1.text = LABELTITLE.CashbackDescription1.localized()
    lblDescription2.text = LABELTITLE.CashbackDescription2.localized()
    lblDescription3.text = LABELTITLE.CashbackDescription3.localized()
    lblMaximumCashBack.text = LABELTITLE.MaximumCashback.localized()
    lblTermsAndConditionsHeading.text = LABELTITLE.TermsAndConditions.localized()
  }
  
  func setViewBorder() {
    viewCashBack.layer.masksToBounds = true
    viewTermsConditions.layer.masksToBounds = true
  }
}
