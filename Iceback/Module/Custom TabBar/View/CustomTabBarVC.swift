//
//  CustomTabBarVC.swift
//  Iceback
//
//  Created by Admin on 10/01/24.
//

import UIKit

class CustomTabBarVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgVoucher: UIImageView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var imgDonation: UIImageView!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblDonation: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblVoucher: UILabel!
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(manageTabSelection), name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
       initializeSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        GCDMainThread.async { [self] in
            viewBg.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        }
    }

   func initializeSetUp() {
      lblHome.textColor = AppThemeManager.shared.labelColor
      lblDonation.textColor = AppThemeManager.shared.labelColor
      lblVoucher.textColor = AppThemeManager.shared.labelColor
      lblStore.textColor = AppThemeManager.shared.labelColor

//      imgHome.tintColor = AppThemeManager.shared.primaryColor
//      imgStore.tintColor = AppThemeManager.shared.primaryColor
//      imgVoucher.tintColor = AppThemeManager.shared.primaryColor
//      imgDonation.tintColor = AppThemeManager.shared.primaryColor
//
//      imgHome.image = imgHome.image?.withRenderingMode(.alwaysTemplate)
//      imgStore.image = imgStore.image?.withRenderingMode(.alwaysTemplate)
//      imgVoucher.image = imgVoucher.image?.withRenderingMode(.alwaysTemplate)
//      imgDonation.image = imgDonation.image?.withRenderingMode(.alwaysTemplate)
   }

    //MARK: - Manage Tab Deselection
    func manageTabDeSelection() {
        if UserDefaultHelper.selectedPreviousTabIndex == 0 {
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseInOut) { [self] in
                lblHome.alpha = 0.5
                imgHome.image = IMAGES.ICN_HOME_UNSELECTED
                imgHome.alpha = 1.0
                self.imgHome.layoutIfNeeded()
                
                UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn) { [self] in
                    lblHome.alpha = 0
                    lblHome.text = ""
                    self.lblHome.layoutIfNeeded()
                }
            }
        } else if UserDefaultHelper.selectedPreviousTabIndex == 1 {
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseInOut) { [self] in
                lblStore.alpha = 0.5
                imgStore.image = IMAGES.ICN_STORE_UNSELECTED
                imgStore.alpha = 1.0
                self.imgStore.layoutIfNeeded()
                
                UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn) { [self] in
                    lblStore.alpha = 0
                    lblStore.text = ""
                    self.lblStore.layoutIfNeeded()
                }
            }
        } else if UserDefaultHelper.selectedPreviousTabIndex == 2 {
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseInOut) { [self] in
                imgVoucher.image = IMAGES.ICN_VOUCHER_UNSELECTED
                lblVoucher.alpha = 0.5
                imgVoucher.alpha = 0.2
                
                UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn) { [self] in
                    lblVoucher.alpha = 0
                    lblVoucher.text = ""
                    imgVoucher.alpha = 1.0
                    self.lblVoucher.layoutIfNeeded()
                }
            }
        } else if UserDefaultHelper.selectedPreviousTabIndex == 3 {
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseInOut) { [self] in
                imgDonation.image = IMAGES.ICN_DONATION_UNSELECTED
                lblDonation.alpha = 0.5
                imgDonation.alpha = 0.2
                
                UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn) { [self] in
                    lblDonation.alpha = 0
                    lblDonation.text = ""
                    imgDonation.alpha = 1.0
                    self.lblDonation.layoutIfNeeded()
                }
            }
        }
    }
    
    //MARK: - Manage Tab Selection
    @objc func manageTabSelection() {
        if UserDefaultHelper.selectedTabIndex == 0 {
            manageTabDeSelection()
            lblHome.text = LABELTITLE.HOMETABBARTITLE.localized()
            imgHome.alpha = 0.2
            
            UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut) { [self] in
                lblHome.alpha = 0.1
               imgHome.image = imgHome.image?.withRenderingMode(.alwaysTemplate)
                imgHome.image = IMAGES.ICN_HOME_SELECTED
               imgHome.tintColor = AppThemeManager.shared.primaryColor
                imgHome.alpha = 1.0
                UIView.animate(withDuration: 0.8, delay: 0.1) { [self] in
                    lblHome.alpha = 1
                }
            }
        } else if UserDefaultHelper.selectedTabIndex == 1 {
            manageTabDeSelection()
            lblStore.text = LABELTITLE.STORETABBARTITLE.localized()
            imgStore.alpha = 0.2
            
            UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut) { [self] in
                lblStore.alpha = 0.1
               imgStore.image = imgStore.image?.withRenderingMode(.alwaysTemplate)
                imgStore.image = IMAGES.ICN_STORE_SELECTED
                imgStore.alpha = 1.0
                UIView.animate(withDuration: 0.8, delay: 0.1) { [self] in
                    lblStore.alpha = 1
                }
            }
        } else if UserDefaultHelper.selectedTabIndex == 2 {
            manageTabDeSelection()
            lblVoucher.text = LABELTITLE.VOUCHERTABBARTITLE.localized()
            imgVoucher.alpha = 0.2
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) { [self] in
                lblVoucher.alpha = 0.1
                imgVoucher.image = IMAGES.ICN_VOUCHER_SELECTED
                imgVoucher.alpha = 1.0
                UIView.animate(withDuration: 0.8, delay: 0.1) { [self] in
                    lblVoucher.alpha = 1
                }
            }
        } else if UserDefaultHelper.selectedTabIndex == 3 {
            manageTabDeSelection()
            lblDonation.text = LABELTITLE.DONATIONTABBARTITLE.localized()
            imgDonation.alpha = 0.2
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) { [self] in
                lblDonation.alpha = 0.1
                imgDonation.image = IMAGES.ICN_DONATION_SELECTED
                imgDonation.alpha = 1.0
                UIView.animate(withDuration: 0.8, delay: 0.1) { [self] in
                    lblDonation.alpha = 1
                }
            }
        }
    }
}


//MARK: - Button Actions
extension CustomTabBarVC {
    @IBAction func btnHomeAction(_ sender: UIButton) {
        if  UserDefaultHelper.selectedTabIndex != 0 {
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 0
            
            self.navigationController?.navigateToViewController(type: HomeVC.self, animated: false, storyboard: AppStoryboard.home)
        }
    }
    
    @IBAction func btnStoreAction(_ sender: UIButton) {
        if  UserDefaultHelper.selectedTabIndex != 1 {
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 1
            
            appendControllerToNavigationStack()
            
            self.navigationController?.navigateToViewController(type: StoresVC.self, animated: false, storyboard: AppStoryboard.stores)
        }
    }
    
    @IBAction func btnVoucherAction(_ sender: UIButton) {
        if  UserDefaultHelper.selectedTabIndex != 2 {
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 2
            
            appendControllerToNavigationStack()
            
            self.navigationController?.navigateToViewController(type: DealsAndVouchersVC.self, animated: false, storyboard: AppStoryboard.deals)
        }
    }
    
    @IBAction func btnDonationAction(_ sender: UIButton) {
        if  UserDefaultHelper.selectedTabIndex != 3 {
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 3
            
            appendControllerToNavigationStack()
            
            self.navigationController?.navigateToViewController(type: DonationProjectsVC.self, animated: false, storyboard: .donationProjects)
        }
    }
}
