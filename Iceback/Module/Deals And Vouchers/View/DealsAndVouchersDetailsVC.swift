//
//  DealsAndVouchersDetailsVC.swift
//  Iceback
//
//  Created by Admin on 12/01/24.
//

import UIKit
import SDWebImage


class DealsAndVouchersDetailsVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var constCollPaymentOptionTop: NSLayoutConstraint!
    @IBOutlet weak var viewDashLine2: UIView!
    @IBOutlet weak var constCollPaymentOptionHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCouponCode: UILabel!
    @IBOutlet weak var collPaymentOption: UICollectionView!
    @IBOutlet weak var imgDealsAndVoucherLogo: UIImageView!
    @IBOutlet weak var lblDealAndVouchersTitle: UILabel!
    @IBOutlet weak var lblDealAndVouchersDetail: UILabel!
    @IBOutlet weak var viewDashLine1: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblPaymentOptionsTitle: UILabel!
    @IBOutlet weak var btnCopyCouponCode: UIButton!
    @IBOutlet weak var lblShippingDeliveryTitle: UILabel!
    @IBOutlet weak var lblShippingDetail: UILabel!
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    //MARK: - Constant & Variables
    var dealsAndVouchersViewModel = DealsAndVouchersViewModel()
    var objDealsAndVoucherDetailData : DealsAndVoucherDetailData?
    var arrRegion : [RegionData] = []
    var dicShipping : [String: Bool] = [:]
    var storeId = 0
    var intDealId = 0
    var strCouponDetail = ""
    var strExpiryDate = ""
    var strCouponCode = ""
    var isNotification = false
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        setUpController()
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
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        self.dealsAndVouchersViewModel.dealsAndVouchersDetailDelegate = self
        self.dealsAndVouchersViewModel.dealsAndVoucherDetails(storeId: storeId)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblDealAndVouchersTitle.text = lblDealAndVouchersTitle.text?.localized()
        lblPaymentOptionsTitle.text = lblPaymentOptionsTitle.text?.localized()
        lblShippingDeliveryTitle.text = lblShippingDeliveryTitle.text?.localized()
        btnRegister.setTitle(BUTTONTITLE.REGISTER.localized(), for: .normal)
        lblNoDataAvailable.text = lblNoDataAvailable.text?.localized()
        
        if UserDefaultHelper.isLogin {
            btnRegister.setTitle(BUTTONTITLE.SHOPNOW.localized(), for: .normal)
        } else {
            btnRegister.setTitle(BUTTONTITLE.REGISTER.localized(), for: .normal)
        }
    }
    
    
    //MARK: - XIB Register
    func xibRegister() {
        collPaymentOption.delegate = self
        collPaymentOption.dataSource = self
        collPaymentOption.register(nibWithCellClass: PaymentOptionsCollectionViewCell.self)
    }
}

//MARK: - Button Action
extension DealsAndVouchersDetailsVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        if isNotification {
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 2
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)

            appendControllerToNavigationStack()
            
            self.navigationController?.navigateToViewController(type: DealsAndVouchersVC.self, animated: false, storyboard: AppStoryboard.deals)
            
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if UserDefaultHelper.isLogin {
            let vc: WKWebViewVC = WKWebViewVC.instantiate(appStoryboard:.stores)
            vc.isCashbackBottomView = true
            vc.isCashbackStatusActive = true
            vc.intStoreId = storeId
            vc.strWebviewURL =  "\(webOpenURL)/deals/\(intDealId)/redirect?user=\(UserDefaultHelper.user_id)"
            self.navigationController?.pushViewController(vc, animated: false)
            
        } else {
            let vc: SignUpVC = SignUpVC.instantiate(appStoryboard:.main)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnCopyCouponCodeAction(_ sender: UIButton) {
        UIPasteboard.general.string = strCouponCode
        PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.COUPONCODECOPIED, withTimeoutImterval: 0.3)
    }
}

//MARK: - UICollectionViewDataSource
extension DealsAndVouchersDetailsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objDealsAndVoucherDetailData?.paymentOptions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: PaymentOptionsCollectionViewCell.self, indexPath: indexPath)
        cell.setup(objDealsAndVoucherDetailData?.paymentOptions[indexPath.row])
        return cell
    }    
}

//MARK: - UICollectionViewDelegate
extension DealsAndVouchersDetailsVC : UICollectionViewDelegate {
}

//MARK: - UICollectionViewDelegate
extension DealsAndVouchersDetailsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 30)
    }
}

//MARK: - RegionListDelegate
extension DealsAndVouchersDetailsVC : RegionListDelegate {
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
        lblShippingDetail.attributedText = Utility.couponShippingDetail(shippingAddress: shippingAddress.joined(separator: ", "))
        lblShippingDetail.setLineSpacing(lineSpacing: 4)
    }
    
}

//MARK: - DealsAndVouchersDetailDelegate
extension DealsAndVouchersDetailsVC : DealsAndVouchersDetailDelegate {
    func dealsAndVouchersDetail(_ objData: DealsAndVoucherDetailData) {
        self.objDealsAndVoucherDetailData = objData
        self.lblDealAndVouchersDetail.text = strCouponDetail
        self.lblDealAndVouchersTitle.text = objDealsAndVoucherDetailData?.name
        
        self.xibRegister()
        
        if let imageUrl = URL(string: objDealsAndVoucherDetailData?.logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            self.imgDealsAndVoucherLogo.sd_setImage(with: imageUrl, placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
        }
        
        self.constCollPaymentOptionTop.constant = objDealsAndVoucherDetailData!.paymentOptions.isEmpty ? 0 : 10
        if objData.paymentOptions.isEmpty {
            lblNoDataAvailable.isHidden = false
        } else {
            lblNoDataAvailable.isHidden = true
        }
        self.constCollPaymentOptionHeight.constant = objDealsAndVoucherDetailData!.paymentOptions.isEmpty ? 50 : collPaymentOption.collectionViewLayout.collectionViewContentSize.height
        self.view.layoutIfNeeded()
        
        dicShipping = objData.shipping.filter({$0.value == true})
        
        //MARK:- Check Shipping Object is Empty
        if !dicShipping.isEmpty {
            dealsAndVouchersViewModel.regionList(isHideLoader: true)
            dealsAndVouchersViewModel.regionListDelegate = self
        }else {
            lblShippingDetail.text = ""
        }
        
        lblCouponCode.attributedText = Utility.couponCode(code: strCouponCode)
        
        self.lblExpiryDate.attributedText = Utility.couponExpirationDate(expirayDate: Utility.getFormattedDateFromString(dateStr: strExpiryDate, withDateFormat: DateAndTimeFormatString.ddMMMYYYY))
    }
    
}
