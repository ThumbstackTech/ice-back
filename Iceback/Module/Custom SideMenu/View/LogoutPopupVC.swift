//
//  LogoutPopupVC.swift
//  Iceback
//
//  Created by Admin on 22/03/24.
//

import UIKit

class LogoutPopupVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var imgPopUp: UIImageView!
    @IBOutlet weak var lblPopUpMessage: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    //MARK: - Constant & Variables
    var isLogout = false
    private var lRFViewModel = LRFViewModel()
    private var myProfileViewModel = MyProfileViewModel()
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        languageLocalize()
    }
    
    override func viewDidLayoutSubviews() {
        GCDMainThread.async { [self] in
            viewBg.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblPopUpMessage.text = lblPopUpMessage.text?.localized()
        btnYes.setTitle(BUTTONTITLE.YES.localized(), for: .normal)
        btnNo.setTitle(BUTTONTITLE.No.localized(), for: .normal)
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        lblPopUpMessage.text = isLogout ? LABELTITLE.LOGOUTPOPUPTITLE : LABELTITLE.DELETEACCOUNTPOPUPTITLE
        imgPopUp.image = isLogout ? IMAGES.ICN_LOGOUTPOPUP : IMAGES.ICN_DELETEACCOUNTPOPUP
    }
    
    func navigateToLoginScreen() {
        GCDMainThread.async {
            Common.shared.doLogoutFromApp()
        }
    }
}

//MARK: - Button Actions
extension LogoutPopupVC {
    
    @IBAction func btnYesClicked(_ sender: UIButton) {
        self.dismiss(animated: false,completion: {
            GCDMainThread.async { [self] in
                lRFViewModel.deRegisterDeviceToken()
                if isLogout {
                    lRFViewModel.signOutDelegate = self
                    lRFViewModel.signOut()
                } else {
                    lRFViewModel.deleteUserDelegate = self
                    lRFViewModel.deleteUser()
                }
            }
        })
       
    }
    
    @IBAction func btnNoClicked(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}


//MARK: - SignOutDelegate
extension LogoutPopupVC : SignOutDelegate {
    func signOutSuccess(_ isSucess: Bool) {
       navigateToLoginScreen()
    }
}

//MARK: - DeleteUserDelegate
extension LogoutPopupVC : DeleteUserDelegate {
    func deleteUserSuccess(_ isSucess: Bool) {
        myProfileViewModel.userAccountDeleteDelegate = self
        myProfileViewModel.userDeleteAccount()
    }
}

extension LogoutPopupVC : UserAccountDeleteDelegate {
    func userAccountDeleteSuccess(isSucess: Bool) {
        navigateToLoginScreen()
    }    
}
