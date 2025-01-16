//
//  VerificationVC.swift
//  Iceback
//
//  Created by Admin on 28/03/24.
//

import UIKit

class VerificationVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var codeStackview: AuthenticationCodeBox!
    @IBOutlet weak var lblAuthenticationCodeTitle: UILabel!
    
    //MARK: - Constant & Variables
    private var targetRangeResendOTP = NSRange()
    var isOpenFrom = ""
    var targetResend = NSRange()
    var intResend = 0
    var isEmptyOTP = Bool()
    private var lRFViewModel = LRFViewModel()
    private var myProfileViewModel = MyProfileViewModel()
    var strEmail: String = ""
    var isRememberMe = false
    var awsToken = ""
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblAuthenticationCodeTitle.text = lblAuthenticationCodeTitle.text?.localized()
        lblDescription.text = lblDescription.text?.localized()
        lblResend.text = lblResend.text?.localized()
        btnVerify.setTitle(BUTTONTITLE.Verify.localized(), for: .normal)
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        viewBg.roundCorners(corners: [.topRight, .topLeft], radius: 60)
        codeStackview.delegate = self
        lblDescription.setLineSpacing(lineSpacing: 10)
        lblDescription.textAlignment = .center
        
        let attributedStringTerms = Utility.otpResendMultipleAttribute()
        targetRangeResendOTP = (attributedStringTerms.string as NSString).range(of: "Resend")
        lblResend.attributedText = attributedStringTerms
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapResendOtpLabel))
        lblResend.isUserInteractionEnabled = true
        lblResend.addGestureRecognizer(tap)
        lblResend.setLineSpacing(lineSpacing: 3)
    }
    
    //MARK: - TapGesture Action
    @objc func tapResendOtpLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: lblResend, inRange: targetRangeResendOTP) {
           dPrint("Tapped Resend OTP")
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if let vc = viewController as? LoginVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        } else {
           dPrint("Tapped none")
        }
    }
    
    
}

//MARK: - Button Actions
extension VerificationVC {
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVerifyClicked(_ sender: UIButton) {
        guard codeStackview.getOTP() != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.OTPEMPTY.localized())
            return
        }
        guard self.isEmptyOTP == false else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.OTPVALIDMSG.localized())
            return
        }
        
        lRFViewModel.signInDelegate = self
        lRFViewModel.confirmSignIn(email: strEmail , otp: codeStackview.getOTP())
    }
}

//MARK: - AuthenticationCodeBoxDelegate
extension VerificationVC: AuthenticationCodeBoxDelegate {
    func didChangeValidity(isValid: Bool) {
        self.isEmptyOTP = !isValid
    }
}

//MARK: - SignInDelegate
extension VerificationVC : SignInDelegate {
    func signInSuccess(_ objData: AuthUser) {
        lRFViewModel.signInAccessTokenDelegate = self
        lRFViewModel.identityProvider()
    }
    
}

//MARK: - SignInAccessTokenDelegate
extension VerificationVC: SignInAccessTokenDelegate {
    func SignInAccessTokenSuccess(_ strData: String) {
        Global.destroySharedManager()
        UserDefaultHelper.acessToken = strData
        lRFViewModel.mobileAwsTokensDelegate = self
        lRFViewModel.mobileAwsTokens(accessToken: strData)
        awsToken = strData
       dPrint("ACCESS TOKEN DETAILS>>", strData)
    }
    
}

//MARK: - UserProfileDelegate
extension VerificationVC: UserProfileDelegate {
    func getUserProfileDetails(_ objData: UserProfile) {
       
        UserDefaultHelper.isRememberMe = isRememberMe
        UserDefaultHelper.selectedTabIndex = 0
        UserDefaultHelper.selectedPreviousTabIndex = 5
        UserDefaultHelper.isLogin = true
        UserDefaultHelper.user_id = objData.id
        UserDefaultHelper.referral_link = "\(referralURL)=\(objData.referralCode)"
        
        self.navigationController?.viewControllers = [self]
        
        appDelegate.arrNavigationStack = []
        
        let vc : HomeVC = HomeVC.instantiate(appStoryboard: .home)
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
}

//MARK: - MobileAwsTokensDelegate
extension VerificationVC: MobileAwsTokensDelegate {
    func mobileAwsTokensSuccess(_ isSucess: Bool) {
       
        lRFViewModel.userProfileDelegate = self
        lRFViewModel.getUserProfile()
    }
    
}
