//
//  ForgotPasswordVC.swift
//  Iceback
//
//  Created by Admin on 22/03/24.
//

import UIKit
import AWSMobileClient

class ForgotPasswordVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblForgotPasswordDescription: UILabel!
    @IBOutlet weak var lblForgotPasswordTitle: UILabel!
    
    //MARK: - Variable
    private var lRFViewModel = LRFViewModel()
    var isForgotPassword = false
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        languageLocalize()
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
        lblForgotPasswordTitle.text = lblForgotPasswordTitle.text?.localized()
        lblForgotPasswordDescription.text = lblForgotPasswordDescription.text?.localized()
        lblEmailTitle.text = lblEmailTitle.text?.localized()
        txtEmail.placeholder = txtEmail.placeholder?.localized()
        btnSubmit.setTitle(BUTTONTITLE.SUBMIT.localized(), for: .normal)
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        txtEmail.delegate = self
        viewBg.roundCorners(corners: [.topRight, .topLeft], radius: 60)
        lblDesc.setLineSpacing(lineSpacing: 4)
        lblDesc.textAlignment = .center
        lblForgotPasswordTitle.text = isForgotPassword ? LABELTITLE.FORGOTPASSWORD : LABELTITLE.ALREADYMEMBER
    }
}

//MARK: - Button Actions
extension ForgotPasswordVC {
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        guard txtEmail.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.EMAILADDRESS.localized())
            return
        }
        guard Utility.isValidEmail(strEmail: txtEmail.text ?? "") else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.EMAILVALIDMSG.localized())
            return
        }

        if isForgotPassword {
            lRFViewModel.forgetPasswordDelegate = self
            lRFViewModel.forgetPassword(email: txtEmail.text!)
        } else {
            lRFViewModel.alreadyMemberDelegate = self
            lRFViewModel.alreadyMember(email: txtEmail.text!)
        }
    
    }
}

//MARK: - UITextFieldDelegate
extension ForgotPasswordVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        return true
    }
}


//MARK: - ForgetPasswordDelegate
extension ForgotPasswordVC: ForgetPasswordDelegate {
    
    func forgetPasswordSuccess(_ objData: ForgotPasswordResult?) {
        let vc: ResetPasswordVC = ResetPasswordVC.instantiate(appStoryboard: .main)
        vc.strEmail = txtEmail.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - AlreadyMemberDelegate
extension ForgotPasswordVC: AlreadyMemberDelegate {
    func alreadyMemberSuccess(_ isSucess: Bool) {
        let alert = UIAlertController(title: AlertMsg.SUCCESS, message: AlertMsg.USEREXISTSUCCESS, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [self]
                UIAlertAction in
                dPrint("OK Pressed")
            self.navigationController?.popViewController(animated: true)
            }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}
