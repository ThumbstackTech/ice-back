//
//  LoginVC.swift
//  Iceback
//
//  Created by Admin on 21/03/24.
//

import UIKit
import LocalAuthentication
import AuthenticationServices
import AWSCognitoIdentityProvider
import AWSMobileClient
import FBSDKLoginKit
import FBSDKCoreKit
import WebKit

class LoginVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnContinueAsGuest: UIButton!
    @IBOutlet weak var lblRememberMeTitle: UILabel!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var lblOrTitle: UILabel!
    @IBOutlet weak var lblPasswordTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblEnterDetailTitle: UILabel!
    @IBOutlet weak var constBiometricLoginHeight: NSLayoutConstraint!
    @IBOutlet weak var lblWelcomeTitle: UILabel!
    @IBOutlet weak var btnAlreadyMember: UIButton!
    @IBOutlet weak var viewBiometricLogin: UIView!
    @IBOutlet weak var lblBiometricTitle: UILabel!
    @IBOutlet weak var imgBiometric: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var collSocialLogin: UICollectionView!
    @IBOutlet weak var constBiometricLoginTop: NSLayoutConstraint!
    @IBOutlet weak var viewTopLine: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewOrLine: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var switchRemember: UISwitch!
    
    //MARK: - Variable
    var arrSocialLogin: [SocialLoginModel] = [SocialLoginModel(type: .Google, image: IMAGES.ICN_GOOGLE_LOGIN), SocialLoginModel(type: .Apple, image: IMAGES.ICN_APPLE_LOGIN), SocialLoginModel(type: .Facebook, image: IMAGES.ICN_FACEBOOK_LOGIN)]
    private var targetSignUp = NSRange()
    private var authController = AuthController()
    private var lRFViewModel = LRFViewModel()
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        xibRegister()
        setUpController()
        setTabGesture()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        GCDMainThread.async { [self] in
            viewTopLine.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 2)
            viewOrLine.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 2)
            viewBackground.roundCorners(corners: [.topLeft, .topRight], radius: 60)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        AWSMobileClient.default().signOut()
        bioMetricFetch()
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        collSocialLogin.dataSource = self
        collSocialLogin.delegate = self
        collSocialLogin.register(nibWithCellClass: SocialLoginCollectionViewCell.self)
    }
    
    //MARK: - Biometric Fetch
    func bioMetricFetch() {
        if UserDefaultHelper.isBiometric {
            constBiometricLoginHeight.constant = 50
            constBiometricLoginTop.constant = 30
            fetchBioMetric()
        } else {
            constBiometricLoginHeight.constant = 0
            constBiometricLoginTop.constant = 0
        }
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblWelcomeTitle.text = lblWelcomeTitle.text?.localized()
        lblEnterDetailTitle.text = lblEnterDetailTitle.text?.localized()
        lblEmailTitle.text = lblEmailTitle.text?.localized()
        lblPasswordTitle.text = lblPasswordTitle.text?.localized()
        lblRememberMeTitle.text = lblRememberMeTitle.text?.localized()
        lblOrTitle.text = lblOrTitle.text?.localized()
        
        txtEmail.placeholder = txtEmail.placeholder?.localized()
        txtPassword.placeholder = txtPassword.placeholder?.localized()
        
        btnContinueAsGuest.setTitle(BUTTONTITLE.CONTINUEASGUEST.localized(), for: .normal)
        btnAlreadyMember.setAttributedTitle(Utility.alreadyMember(), for: .normal)
        btnForgetPassword.setTitle(BUTTONTITLE.FORGOTPASSWORD.localized(), for: .normal)
        btnLogin.setTitle(BUTTONTITLE.LOGIN.localized(), for: .normal)
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        if UserDefaultHelper.isRememberMe {
            txtEmail.text = Common.shared.decrypt(str: UserDefaultHelper.email)
            txtPassword.text = Common.shared.decrypt(str: UserDefaultHelper.passowrd)
            switchRemember.isOn = true
        }
        
        txtPassword.enablePasswordToggle()
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        
    }
    
    //MARK: - Set Tab Gesture
    func setTabGesture() {
        let viewBiometricTap = UITapGestureRecognizer(target: self, action: #selector(self.viewBiometricTapped(_:)))
        viewBiometricLogin.isUserInteractionEnabled = true
        viewBiometricLogin.addGestureRecognizer(viewBiometricTap)
        
        let attributedStringLogin = Utility.signUpMultipleAttribute()
        
        targetSignUp = (attributedStringLogin.string as NSString).range(of: LABELTITLE.SIGNUP.localized())
        
        lblSignup.attributedText = attributedStringLogin
        let tapSignUp = UITapGestureRecognizer(target: self, action: #selector(self.tapSignUpLabel))
        lblSignup.isUserInteractionEnabled = true
        lblSignup.addGestureRecognizer(tapSignUp)
    }
    
    //MARK: - TapGesture Action
    @objc func tapSignUpLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: lblSignup, inRange: targetSignUp) {
            print("Tapped SIgn up")
            let vc: SignUpVC = SignUpVC.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated:true)
        } else {
            print("Tapped none")
        }
    }
    
    //MARK: - Fetch Biometric
    func fetchBioMetric() {
        authController.askBiometricAvailability { [self] passcode in
            switch authController.biometricType{
            case .touchID:
                print("Finger Print")
                lblBiometricTitle.text = BIOMETRICTYPE.FINGERPRINT.rawValue.localized()
                imgBiometric.image = IMAGES.ICN_FINGERPRINT
                UserDefaultHelper.selectedBiometric = BIOMETRICTYPE.FINGERPRINT.rawValue
                
            case .faceID:
                print("Face Id")
                lblBiometricTitle.text = BIOMETRICTYPE.FACEID.rawValue.localized()
                imgBiometric.image = IMAGES.ICN_FACEID
                UserDefaultHelper.selectedBiometric = BIOMETRICTYPE.FACEID.rawValue
                
            case .none:
                print("Passcode")
                lblBiometricTitle.text = BIOMETRICTYPE.PASSCODE.rawValue.localized()
                imgBiometric.image = IMAGES.ICN_PASSCODE
                UserDefaultHelper.selectedBiometric = BIOMETRICTYPE.PASSCODE.rawValue
                break
                
            @unknown default:
                self.view.layoutIfNeeded()
                break
            }
        } completion: { error in
            if error != nil{
                print("LocalAuthentication", error?.localizedDescription ?? "")
            }
        }
    }
   
}

//MARK: - Button Actions
extension LoginVC {
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        guard txtEmail.text != "" else{
            alertWithTitle(AlertMsg.TITLE.localized(), message:AlertMsg.EMAILADDRESS.localized())
            return
        }
        guard Utility.isValidEmail(strEmail: txtEmail.text ?? "") else{
            alertWithTitle(AlertMsg.TITLE.localized(), message:AlertMsg.EMAILVALIDMSG.localized())
            return
        }
        guard txtPassword.text != "" else{
            alertWithTitle(AlertMsg.TITLE.localized(), message:AlertMsg.PASSWORDVALIDMSG.localized())
            return
        }
        
        lRFViewModel.oTPSendDelegate = self
        lRFViewModel.signIn(email: txtEmail.text!, password: txtPassword.text!)
        
    }
    
    @IBAction func btnForgetPasswordAction(_ sender: UIButton) {
        let vc: ForgotPasswordVC = ForgotPasswordVC.instantiate(appStoryboard: .main)
        if sender.tag == 1 {
            vc.isForgotPassword = false
        } else {
            vc.isForgotPassword = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewBiometricTapped(_ gesture: UITapGestureRecognizer) {
        authenticationWithTouchID()
    }
    
    @IBAction func switchRememberChanged(_ sender: UISwitch) {
        print("REMEMBER ME SWITCH>>",sender.isOn,switchRemember.isOn)
    }
    
    @IBAction func btnContinueAsGuestAction(_ sender: UIButton) {
        UserDefaultHelper.acessToken = guestLoginBearerToken
        UserDefaultHelper.selectedTabIndex = 0
        UserDefaultHelper.selectedPreviousTabIndex = 5
        
        self.navigationController?.viewControllers = [self]
        
        appDelegate.arrNavigationStack.removeAll()
        
        let vc: HomeVC = HomeVC.instantiate(appStoryboard: .home)
        self.navigationController?.fadeTo(vc, animated: false)
    }
}

//MARK: - UICollectionViewDataSource
extension LoginVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSocialLogin.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: SocialLoginCollectionViewCell.self, indexPath: indexPath)
        cell.setup(arrSocialLogin[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension LoginVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch arrSocialLogin[indexPath.row].type {
            
        case .Google:
            print("Google")
            let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email", "phone", "aws.cognito.signin.user.admin"], identityProvider: IdentityProvider.google.rawValue)
            lRFViewModel.socialSigInDelegate = self
            lRFViewModel.showSignIn(navigationController: navigationController!, hostedUIOptions: hostedUIOptions)
            
        case .Apple:
            print("Apple")
            let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email", "phone", "aws.cognito.signin.user.admin"], identityProvider: IdentityProvider.apple.rawValue)
            lRFViewModel.socialSigInDelegate = self
            lRFViewModel.showSignIn(navigationController: navigationController!, hostedUIOptions: hostedUIOptions)
         
        case .Facebook:
            print("Facebook")
            let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email", "phone", "aws.cognito.signin.user.admin"], identityProvider: IdentityProvider.facebook.rawValue)
            lRFViewModel.socialSigInDelegate = self
            lRFViewModel.showSignIn(navigationController: navigationController!, hostedUIOptions: hostedUIOptions)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension LoginVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 56)
    }
}

//MARK: - Biometric
extension LoginVC {
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = BUTTONTITLE.USEPASSCODE
        
        var authorizationError: NSError?
        let reason = AlertMsg.AUTHENTICATIORESONMSG
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                if success {
                    GCDMainThread.async { [self] in
                        lRFViewModel.oTPSendDelegate = self
                        lRFViewModel.signIn(email: Common.shared.decrypt(str: UserDefaultHelper.email), password: Common.shared.decrypt(str: UserDefaultHelper.passowrd))
                    }
                } else {
                    // Failed to authenticate
                    guard let error = evaluateError else {
                        return
                    }
                    print(error)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
    }
    
}

//MARK: - UITextFieldDelegate method
extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        if textField == txtPassword {
            guard string != " " else {
                return false
            }
        }
        
        return true
    }
}


//MARK: - OTPSendDelegate
extension LoginVC : OTPSendDelegate {
    func OTPSendSuccess(_ isSucess: Bool) {
        
//        let vc: VerificationVC = VerificationVC.instantiate(appStoryboard: .main)
//        vc.strEmail = txtEmail.text!
//        vc.isRememberMe = switchRemember.isOn
//        self.navigationController?.pushViewController(vc, animated: true)
        lRFViewModel.signInAccessTokenDelegate = self
        lRFViewModel.identityProvider()
    }
    
}

//MARK: - SocialSigInDelegate
extension LoginVC : SocialSigInDelegate {
    func socialSigInFailure(_ strError: String) {
        let alert = UIAlertController(title: AlertMsg.ALERT.localized(), message: strError, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized(), style: .default) { action in
            self.dismiss(animated: false)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func socialSigInSuccess(_ isSucess: Bool) {
        lRFViewModel.signInAccessTokenDelegate = self
        lRFViewModel.identityProvider()
    }
    
}

//MARK: - SignInAccessTokenDelegate
extension LoginVC : SignInAccessTokenDelegate {
    func SignInAccessTokenSuccess(_ strData: String) {
        Global.destroySharedManager()
        UserDefaultHelper.acessToken = strData
        UserDefaultHelper.isRememberMe = switchRemember.isOn
        lRFViewModel.mobileAwsTokensDelegate = self
        lRFViewModel.mobileAwsTokens(accessToken: strData)
//        awsToken = strData
        print("ACCESS TOKEN DETAILS>>", strData)
    }
    
}

//MARK: - UserProfileDelegate
extension LoginVC: UserProfileDelegate {
    func getUserProfileDetails(_ objData: UserProfile) {
       
        UserDefaultHelper.selectedTabIndex = 0
        UserDefaultHelper.selectedPreviousTabIndex = 5
        UserDefaultHelper.isLogin = true
        UserDefaultHelper.user_id = objData.id
        UserDefaultHelper.referral_link = "\(referralURL)=\(objData.referralCode)"
        
        self.navigationController?.viewControllers = [self]
        
        appDelegate.arrNavigationStack.removeAll()
        
        let vc : HomeVC = HomeVC.instantiate(appStoryboard: .home)
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
}

//MARK: - MobileAwsTokensDelegate
extension LoginVC: MobileAwsTokensDelegate {
    func mobileAwsTokensSuccess(_ isSucess: Bool) {
        Global.destroySharedManager()
        lRFViewModel.userProfileDelegate = self
        lRFViewModel.getUserProfile()
    }
    
}
