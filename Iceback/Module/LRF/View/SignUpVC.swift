//
//  SignUpVC.swift
//  Iceback
//
//  Created by Admin on 21/03/24.
//

import UIKit
import CountryPickerView

class SignUpVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var txtGivenName: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtFamilyName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblPhoneNumberTitle: UILabel!
    @IBOutlet weak var lblGivenNameTitle: UILabel!
    @IBOutlet weak var lblTermsAndConditions: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lblFamilyNameTitle: UILabel!
    @IBOutlet weak var btnTermsAndConditions: UIButton!
    @IBOutlet weak var lblPasswordTitle: UILabel!
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var lblConfirmPasswordTitle: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblWelcomeTitle: UILabel!

    //MARK: - Variable
    private var targetLogin = NSRange()
    private var isTerms = false
    private var targetRangeTerms = NSRange()
    private var targetRangeLogin = NSRange()
    let countryPickerView = CountryPickerView()
    private var lRFViewModel = LRFViewModel()
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        setUpController()
        setTabGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        GCDMainThread.async { [self] in
            viewBackground.roundCorners(corners: [.topLeft, .topRight], radius: 60)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblWelcomeTitle.text = lblWelcomeTitle.text?.localized()
        lblEmailTitle.text = lblEmailTitle.text?.localized()
        lblPhoneNumberTitle.text = lblPhoneNumberTitle.text?.localized()
        lblGivenNameTitle.text = lblGivenNameTitle.text?.localized()
        lblFamilyNameTitle.text = lblFamilyNameTitle.text?.localized()
        lblPasswordTitle.text = lblPasswordTitle.text?.localized()
        lblConfirmPasswordTitle.text = lblConfirmPasswordTitle.text?.localized()
        
        btnRegister.setTitle(BUTTONTITLE.REGISTER.localized(), for: .normal)
        
        txtEmail.placeholder = txtEmail.placeholder?.localized()
        txtPassword.placeholder = txtPassword.placeholder?.localized()
        txtPhoneNumber.placeholder = txtPhoneNumber.placeholder?.localized()
        txtGivenName.placeholder = txtGivenName.placeholder?.localized()
        txtFamilyName.placeholder = txtFamilyName.placeholder?.localized()
        txtConfirmPassword.placeholder = txtConfirmPassword.placeholder?.localized()
    }
    
    
    //MARK: - Setup Controller
    func setUpController() {
        txtGivenName.delegate = self
        txtFamilyName.delegate = self
        txtEmail.delegate = self
        txtPhoneNumber.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
                
        txtConfirmPassword.enablePasswordToggle()
        txtPassword.enablePasswordToggle()
        
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
    }
    
    //MARK: - Set Tab Gesture
    func setTabGesture() {
        let attributedStringTerms = Utility.termsAndPrivacymultipleAttribute()
        targetRangeTerms = (attributedStringTerms.string as NSString).range(of: LABELTITLE.TERMTITLE.localized())
        lblTermsAndConditions.attributedText = attributedStringTerms
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        lblTermsAndConditions.isUserInteractionEnabled = true
        lblTermsAndConditions.addGestureRecognizer(tap)
        lblTermsAndConditions.setLineSpacing(lineSpacing: 3)
        
        let attributedStringLogin = Utility.loginMultipleAttribute()
        targetRangeLogin = (attributedStringLogin.string as NSString).range(of: LABELTITLE.LOGIN.localized())
        lblLogin.attributedText = attributedStringLogin
        let tapLogin = UITapGestureRecognizer(target: self, action: #selector(self.tapLoginLabel))
        lblLogin.isUserInteractionEnabled = true
        lblLogin.addGestureRecognizer(tapLogin)
    }
    
    //MARK: - TapGesture Action
    @objc func tapLoginLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: lblLogin, inRange: targetRangeLogin) {
           dPrint("Tapped Login")
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
    
    @objc func tapFunction(gesture: UITapGestureRecognizer) {
       if gesture.didTapAttributedTextInLabel(label: lblTermsAndConditions, inRange: targetRangeTerms) {
           let vc: CMSVC = CMSVC.instantiate(appStoryboard: .sideMenu)
           vc.slug = "terms-and-conditions"
           self.navigationController?.pushViewController(vc, animated: false)
          dPrint("Tapped Terms & Conditions")
        } else {
           dPrint("Tapped none")
        }
        }
}

//MARK: - Button Actions
extension SignUpVC {
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        guard txtEmail.text != "" else{
            alertWithTitle(AlertMsg.TITLE.localized(), message:AlertMsg.EMAILADDRESS.localized())
            return
        }
        
        guard Utility.isValidEmail(strEmail: txtEmail.text ?? "") else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.EMAILVALIDMSG.localized())
            return
        }
        
        
        guard txtPhoneNumber.text != "" else{
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.PHONENO.localized())
            return
        }
        
        guard Utility.isPhoneNumberValid(strPhoneNo: txtPhoneNumber.text ?? "") else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.PHONENOVALID.localized())
            return
        }
        
        guard txtGivenName.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.FIRSTNAME.localized())
            return
        }
        
        guard txtFamilyName.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.LASTNAME.localized())
            return
        }
        
        guard txtPassword.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.PASSWORDVALIDMSG.localized())
            return
        }
        
        guard txtConfirmPassword.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CONFIRMPASSWORDMSG.localized())
            return
        }
        
        guard txtPassword.text == txtConfirmPassword.text else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CONFIRMVALIDPASSWORDMSG)
            return
        }
        
        if !btnTermsAndConditions.isSelected {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.TERMSCONDIATIONMSG.localized())
            return
        }
        
        let phoneNumber = lblCountryCode.text! + txtPhoneNumber.text!
        lRFViewModel.signUpDelegate = self
        lRFViewModel.signUp(email: txtEmail.text!, password: txtPassword.text!, phoneNumber: phoneNumber, givenName: txtGivenName.text!, familyName: txtFamilyName.text!)
       
    }
    
  
    @IBAction func btnTermsAndConditionsAction(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCountryClk(_ sender: UIButton) {
        countryPickerView.showCountriesList(from: self)
    }
}

//MARK: - CountryPickerViewDataSource, CountryPickerViewDelegate
extension SignUpVC: CountryPickerViewDataSource, CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.lblCountryCode.text = countryPickerView.selectedCountry.phoneCode
        self.imgCountryFlag.image = countryPickerView.selectedCountry.flag
    }
}


//MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        if txtGivenName == textField || txtFamilyName == textField{
            guard Utility.fullNameValid(strFullName:string) else{
                return false
            }
        }
         
        if (textField == txtPassword) || (textField == txtConfirmPassword) {
            guard string != " " else {
                return false
            }
        }
        
        return true
    }
}

//MARK: - SignInDelegate
extension SignUpVC: SignUpDelegate {
    func signUpSuccess(_ isSucess: Bool) {
        lRFViewModel.welcomeMailDelegate = self
        lRFViewModel.welcomeMail(email: txtEmail.text!)
    }
 
}

//MARK: - WelcomeMailDelegate
extension SignUpVC: WelcomeMailDelegate {
    func welcomeMailSuccess(_ isSucess: Bool) {
        
        let alert = UIAlertController(title: AlertMsg.SUCCESS.localized(), message: "We have sent an email to \(txtEmail.text!). Please check your email, follow the instructions to verify your email address.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized(), style: .default) { action in
            let vc: LoginVC = LoginVC.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
       
    }
    
}
