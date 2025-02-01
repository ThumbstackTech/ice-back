//
//  CouponDetailsVC.swift
//  Iceback
//
//  Created by Admin on 16/01/24.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class CouponDetailsVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var viewTermsAndConditions: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var btnFavourite: UIButton!
  @IBOutlet weak var constTermsAndConditionTop: NSLayoutConstraint!
  @IBOutlet weak var colHeight: NSLayoutConstraint!
  @IBOutlet weak var imgLogo: UIImageView!
  @IBOutlet weak var lblTermsAndCondition: UILabel!
  @IBOutlet weak var btnRegister: UIButton!
  @IBOutlet weak var lblPaymentOptionsTitle: UILabel!
  @IBOutlet weak var lblShippingDeliveryRegion: UILabel!
  @IBOutlet weak var lblTermsAndConditionTitle: UILabel!
  @IBOutlet weak var viewDashLine2: UIView!
  @IBOutlet weak var viewDashLine1: UIView!
  @IBOutlet weak var lblDealAndVouchersDetail: UILabel!
  @IBOutlet weak var lblDealAndVouchersTitle: UILabel!
  @IBOutlet weak var collSpecialDealsAndVouchers: UICollectionView!
  @IBOutlet weak var colPayment: UICollectionView!
  @IBOutlet weak var lblSpecialDealsAndVouchersTitle: UILabel!
  @IBOutlet weak var viewCouponDetail: UIView!
  @IBOutlet weak var lblShippingDeliveryTitle: UILabel!
  @IBOutlet weak var colPaymentHeight: NSLayoutConstraint!
  @IBOutlet weak var lblNoDataAvailable: UILabel!
   @IBOutlet weak var viewBackground1: UIView!
   @IBOutlet weak var viewBackground2: UIView!

  //MARK: - Constant & Variables
  private var storesViewModel = StoresViewModel()
  var arrSimilarStoresModel: [DealsAndVouchersData] = []
  var objStoreDetail: StoreDetailsNewModel?
  var dealsAndVouchersViewModel = DealsAndVouchersViewModel()
  var intStoreId = 0
  var arrRegion : [RegionData] = []
  var arrShippingAndDelivery = [String]()
  var dicShipping : [String: Bool] = [:]
  private var arrTargetLink: [MultipleClickURL] = []

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    languageLocalize()
    setUpController()
     initializeSetUp()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }

  override func viewDidLayoutSubviews() {
    GCDMainThread.async { [self] in
      viewDashLine1.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 4)
      viewDashLine2.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 4)
    }
  }
  //MARK: - Set TapGesture
  func setTapGesture() {
    let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
    lblTermsAndCondition.isUserInteractionEnabled = true
    lblTermsAndCondition.addGestureRecognizer(labelTap)
  }

  @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
    for linkRange in arrTargetLink {
      if gesture.didTapAttributedTextInLabel(label: lblTermsAndCondition, inRange: linkRange.targetLinkRange) {
        let vc: WKWebViewVC = WKWebViewVC.instantiate(appStoryboard:.stores)
        vc.strWebviewURL = linkRange.urlString
        self.navigationController?.pushViewController(vc, animated: false)
      }else {
        dPrint("Tapped none")
      }
    }
  }

  func storeDetailViewData() {
    if objStoreDetail?.shipping == nil {
      lblShippingDeliveryRegion.isHidden = true
      viewDashLine2.isHidden = true
    } else {
      lblShippingDeliveryRegion.isHidden = false
      viewDashLine2.isHidden = false
    }

    if objStoreDetail?.payment_options == nil {
      lblPaymentOptionsTitle.isHidden = true
      colPayment.isHidden = true
      viewDashLine2.isHidden = true
    } else {
      lblPaymentOptionsTitle.isHidden = false
      colPayment.isHidden = false
      viewDashLine2.isHidden = false
    }
  }

  //MARK: - XIB Register
  func xibRegister() {
    colPayment.delegate = self
    colPayment.dataSource = self
    colPayment.register(nibWithCellClass: PaymentOptionsCollectionViewCell.self)

  }

  //MARK: - Language Localize
  func languageLocalize() {
    lblNoDataAvailable.text = lblNoDataAvailable.text?.localized()
    lblDealAndVouchersTitle.text = lblDealAndVouchersTitle.text?.localized()
    lblPaymentOptionsTitle.text = lblPaymentOptionsTitle.text?.localized()
    lblShippingDeliveryTitle.text = lblShippingDeliveryTitle.text?.localized()
    lblSpecialDealsAndVouchersTitle.text = lblSpecialDealsAndVouchersTitle.text?.localized()

    if UserDefaultHelper.isLogin {
      btnRegister.setTitle(BUTTONTITLE.SHOPNOW.localized(), for: .normal)
    } else {
      btnRegister.setTitle(BUTTONTITLE.REGISTER.localized(), for: .normal)
    }
  }

  //MARK: - Setup Controller

  func setUpController() {
    navigationItem.hidesBackButton = true

    storesViewModel.StoreDetailsData(storeId: intStoreId)
    storesViewModel.StoreDetailsDelegate = self

    storesViewModel.specialDealsAndVouchers(specialId: intStoreId)
    storesViewModel.specialDealsAndVoucherDelegate = self

    btnFavourite.isHidden = UserDefaultHelper.isLogin ? false : true

  }

   func initializeSetUp() {
      setLabelTextColor(labelColor: AppThemeManager.shared.labelColor)
      btnRegister.backgroundColor = AppThemeManager.shared.primaryColor
      btnRegister.setTitleColor(AppThemeManager.shared.buttonTitleColor, for: .normal)
      viewBackground1.backgroundColor = AppThemeManager.shared.backgroundColor
      viewBackground2.backgroundColor = AppThemeManager.shared.backgroundColor

      func setLabelTextColor(labelColor: UIColor) {
         lblTermsAndCondition.textColor = labelColor
         lblPaymentOptionsTitle.textColor = labelColor
         lblShippingDeliveryTitle.textColor = labelColor
         lblShippingDeliveryRegion.textColor = labelColor
         lblDealAndVouchersTitle.textColor = labelColor
         lblDealAndVouchersDetail.textColor = labelColor
         lblTermsAndConditionTitle.textColor = labelColor
         lblSpecialDealsAndVouchersTitle.textColor = labelColor
         lblNoDataAvailable.textColor = labelColor
      }
   }

  //MARK: - Check String Contain URL
  func checkStringContainURL(description: String) {
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in:  description, options: [], range: NSRange(location: 0, length: description.utf16.count))

    for match in matches {
      guard let range = Range(match.range, in: description) else { continue }
      let url = description[range]
      dPrint("DETECTED LINK: \(url)")
      let strLink = String(url)
      let targetLink = description.nsRange(from: range)
      arrTargetLink.append(MultipleClickURL(targetLinkRange: targetLink, urlString: strLink))
    }

    setTapGesture()
  }
}

//MARK: - Button Action
extension CouponDetailsVC {
  @IBAction func btnFavouriteAction(_ sender: UIButton) {
    if objStoreDetail?.isFavourite == 1 {
      storesViewModel.favouriteStoreRemoveDelegate = self
      storesViewModel.favouriteStoreRemove(storeId: intStoreId, intIndex: sender.tag)
    } else {
      storesViewModel.favouriteStoreAddDelegate = self
      storesViewModel.favouriteStoreAdd(storeId: intStoreId, intIndex: sender.tag)
    }
  }

  @IBAction func btnBackAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: false)
    arrShippingAndDelivery.removeAll()
  }

  @IBAction func btnRegister(_ sender: UIButton) {
    if UserDefaultHelper.isLogin {
       dPrint("objStoreDetail = \(String(describing:objStoreDetail))")

      let vc: WKWebViewVC = WKWebViewVC.instantiate(appStoryboard:.stores)
      vc.strWebviewURL =  "\(objStoreDetail?.redirectUrl ?? "")?user=\(UserDefaultHelper.user_id)"
       dPrint("strWebviewURL = \(vc.strWebviewURL)")
      vc.isCashbackBottomView = true
      vc.isCashbackStatusActive = true
      vc.intStoreId = intStoreId
      vc.isStore = true
      self.navigationController?.pushViewController(vc, animated: false)

    } else {
      let vc: SignUpVC = SignUpVC.instantiate(appStoryboard:.main)
      self.navigationController?.pushViewController(vc, animated: false)
    }
  }
}

//MARK: - UICollectionViewDataSource
extension CouponDetailsVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == colPayment {
      return objStoreDetail?.payment_options.count ?? 0
    } else {
      return arrSimilarStoresModel.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == colPayment {
      let cell = collectionView.dequeueCell(ofType: PaymentOptionsCollectionViewCell.self, indexPath: indexPath)
      cell.setup(objStoreDetail?.payment_options[indexPath.row])
      return cell
    } else {
      let cell = collectionView.dequeueCell(ofType: SpecialDealsAndVouchersCollectionViewCell.self, indexPath: indexPath)
      cell.setup(arrSimilarStoresModel[indexPath.row])
      return cell
    }
  }

}

//MARK: - UICollectionViewDelegate
extension CouponDetailsVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
      case collSpecialDealsAndVouchers :
        let vc : DealsAndVouchersDetailsVC = DealsAndVouchersDetailsVC.instantiate(appStoryboard: .deals)
        vc.storeId = arrSimilarStoresModel[indexPath.row].storeId
        vc.intDealId = arrSimilarStoresModel[indexPath.row].id
        vc.strExpiryDate = arrSimilarStoresModel[indexPath.row].expiryDate
        vc.strCouponCode = arrSimilarStoresModel[indexPath.row].code
        vc.strCouponDetail = arrSimilarStoresModel[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: false)

      default:
        break
    }
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CouponDetailsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == collSpecialDealsAndVouchers {
      return CGSize(width: (collectionView.bounds.width - 10)/2, height: 200)
    }
    return CGSize(width: 50, height: 30)
  }
}

extension CouponDetailsVC: StoreDetailsDelegate {
  func StoreDetails(_ objData: StoreDetailsNewModel) {
     dPrint("objData = \(objData)")
    self.objStoreDetail = objData
    xibRegister()

    if objStoreDetail?.max_cashback_percentage != 0 {
      lblDealAndVouchersDetail.attributedText = Utility.couponPercentageMultipleAttribute(discountValue: objStoreDetail?.max_cashback_percentage ?? 0.0)
    } else {
      lblDealAndVouchersDetail.attributedText = Utility.couponPercentageMultipleAttribute(discountValue: objStoreDetail?.max_cashback_amount ?? 0.0, isCHF: true)
    }

    lblDealAndVouchersDetail.adjustsFontSizeToFitWidth = true
    lblDealAndVouchersDetail.minimumScaleFactor = 0.5

    if objData.logo.contains(".svg") {
      imgLogo.sd_setImage(with: URL(string: objData.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
    } else {
      imgLogo.sd_setImage(with: URL(string: objData.logo), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
    }

    lblDealAndVouchersTitle.text = objStoreDetail?.name


    dicShipping = objData.shipping.filter({$0.value == true})

    //MARK:- Check Shipping Object is Empty
    if !dicShipping.isEmpty {
      dealsAndVouchersViewModel.regionList(isHideLoader: true)
      dealsAndVouchersViewModel.regionListDelegate = self
    }else {
      lblShippingDeliveryRegion.text = ""
    }

    //Terms & Conditions Hide Show Logic
    if objStoreDetail?.termsAndCondition == nil {
      lblTermsAndConditionTitle.text = "Terms and Conditions".localized()
      lblTermsAndCondition.text = "Not available".localized()
      dPrint("TERMS AND CONDITIONS>>",objStoreDetail?.termsAndCondition ?? "")
    } else {
      viewTermsAndConditions.isHidden = false
      if UserDefaultHelper.selectedLanguage == "de" {
        lblTermsAndConditionTitle.text = objStoreDetail?.termsAndCondition?.attributes.titlede
        lblTermsAndCondition.text = objStoreDetail?.termsAndCondition?.attributes.contentde
        checkStringContainURL(description: lblTermsAndCondition.text!)
      } else {
        lblTermsAndConditionTitle.text = objStoreDetail?.termsAndCondition?.attributes.title
        lblTermsAndCondition.text = objStoreDetail?.termsAndCondition?.attributes.content
        checkStringContainURL(description: lblTermsAndCondition.text!)
      }
      lblTermsAndCondition.setLineSpacing(lineSpacing: lineSpacingBetweenText)
    }

    if objData.payment_options.isEmpty {
      lblNoDataAvailable.isHidden = false
    } else {
      lblNoDataAvailable.isHidden = true
      self.colPaymentHeight.constant = objData.payment_options.isEmpty ? 50 : colPayment.collectionViewLayout.collectionViewContentSize.height
      self.view.layoutIfNeeded()
    }
    if objStoreDetail?.isFavourite == 1 {
      btnFavourite.setImage(IMAGES.ICN_FAVOURITE, for: .normal)
    } else {
      btnFavourite.setImage(IMAGES.ICN_UNFAVOURITE, for: .normal)
    }

    storeDetailViewData()
  }
}

extension CouponDetailsVC: SpecialDealsAndVoucherDelegate {
  func specialDealsAndVoucher(_ arrData: [DealsAndVouchersData]) {
    self.arrSimilarStoresModel = arrData
    collSpecialDealsAndVouchers.delegate = self
    collSpecialDealsAndVouchers.dataSource = self
    collSpecialDealsAndVouchers.register(nibWithCellClass: SpecialDealsAndVouchersCollectionViewCell.self)

    lblSpecialDealsAndVouchersTitle.isHidden = arrData.isEmpty ? true : false

    self.colHeight.constant = self.collSpecialDealsAndVouchers.collectionViewLayout.collectionViewContentSize.height
    self.view.layoutIfNeeded()
  }
}

extension CouponDetailsVC : RegionListDelegate {
  func regionList(_ arrData: [RegionData]) {
    self.arrRegion = arrData

    var shippingAddress: [String] = []
    for dict in arrRegion {
      if dicShipping.contains(where: {$0.key == "\(dict.id)"}) {
        if UserDefaultHelper.selectedLanguage == "de" {
          shippingAddress.append(dict.name?.de ?? "")
        } else {
          shippingAddress.append(dict.name?.en ?? "")
        }
      }
    }
    dPrint("SHIPPING OBJECT ADDRESS: \(shippingAddress)")
    lblShippingDeliveryRegion.attributedText = Utility.couponShippingDetail(shippingAddress: shippingAddress.joined(separator: ", "))
    lblShippingDeliveryRegion.setLineSpacing(lineSpacing: 4)
  }
}


//MARK: - FavouriteStoreAddDelegate
extension CouponDetailsVC: FavouriteStoreAddDelegate {
  func favouriteStoreAddSuccess(_ isSuccess: Bool, intIndex: Int) {
    objStoreDetail?.isFavourite = 1
    let dict:[String: Any] = ["storeId": intStoreId]
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AddFavouriteStore"), object: nil, userInfo: dict)
    btnFavourite.setImage(IMAGES.ICN_FAVOURITE, for: .normal)
  }

}

//MARK: - FavouriteStoreRemoveDelegate
extension CouponDetailsVC: FavouriteStoreRemoveDelegate {
  func favouriteStoreRemoveSuccess(_ isSuccess: Bool, intIndex: Int) {
    objStoreDetail?.isFavourite = 0
    let dict:[String: Any] = ["storeId": intStoreId]
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RemoveFavouriteStore"), object: nil, userInfo: dict)
    btnFavourite.setImage(IMAGES.ICN_UNFAVOURITE, for: .normal)
  }

}
