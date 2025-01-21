//
//  ResetPasswordVC.swift
//  Iceback
//
//  Created by Admin on 28/03/24.
//

import Foundation
import UIKit

class ResetPasswordVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var viewBg: UIView!
  @IBOutlet weak var btnBack: UIButton!
  @IBOutlet weak var btnChangePassword: UIButton!
  @IBOutlet weak var txtNewPassword: UITextField!
  @IBOutlet weak var txtConfirmPassword: UITextField!
  @IBOutlet weak var codeStackview: AuthenticationCodeBox!
  @IBOutlet weak var lblConfirmPasswordTitle: UILabel!
  @IBOutlet weak var lblNewPasswordTitle: UILabel!
  @IBOutlet weak var lblVerificationCodeTitle: UILabel!
  @IBOutlet weak var lblResetPasswordTitle: UILabel!
  @IBOutlet weak var lblResetPasswordSubTitle: UILabel!

  //MARK: - Constant & Variables
  var strEmail: String = ""
  var isEmptyOTP = Bool()
  private var lRFViewModel = LRFViewModel()

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
    lblNewPasswordTitle.text = lblNewPasswordTitle.text?.localized()
    lblConfirmPasswordTitle.text = lblConfirmPasswordTitle.text?.localized()
    lblVerificationCodeTitle.text = lblVerificationCodeTitle.text?.localized()
    lblResetPasswordTitle.text = lblResetPasswordTitle.text?.localized()
    lblResetPasswordSubTitle.text = lblResetPasswordSubTitle.text?.localized()

    txtNewPassword.placeholder = txtNewPassword.placeholder?.localized()
    txtConfirmPassword.placeholder = txtConfirmPassword.placeholder?.localized()

    btnChangePassword.setTitle(BUTTONTITLE.RESETPASSWORD.localized(), for: .normal)
  }

  //MARK: - Setup Controller
  func setUpController() {
    txtNewPassword.delegate = self
    txtConfirmPassword.delegate = self
    viewBg.roundCorners(corners: [.topRight, .topLeft], radius: 60)
    txtNewPassword.enablePasswordToggle()
    txtConfirmPassword.enablePasswordToggle()
  }
}

//MARK: - Button Actions
extension ResetPasswordVC {
  @IBAction func btnBackClicked(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func btnChangePasswordClicked(_ sender: UIButton) {

    guard codeStackview.getOTP() != "" else {
      alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.OTPEMPTY.localized())
      return
    }
    
    guard self.isEmptyOTP == false else {
      alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.OTPVALIDMSG.localized())
      return
    }

    guard txtNewPassword.text != "" else {
      alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.NEWPASSWORDMSG.localized())
      return
    }

    guard txtConfirmPassword.text != "" else {
      alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CONFIRMPASSWORDMSG.localized())
      return
    }

    guard txtNewPassword.text == txtConfirmPassword.text else {
      alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.NEWPASSCONFIRMVALIDPASSWORDMSG.localized())
      return
    }

    lRFViewModel.resetPasswordDelegate = self
    lRFViewModel.confirmForgotPassword(email: strEmail, newPassword: txtNewPassword.text!, otp: codeStackview.getOTP())
  }
}

//MARK: - UITextFieldDelegate
extension ResetPasswordVC: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
      return false
    }

    if (textField == txtNewPassword) || (textField == txtConfirmPassword) {
      guard string != " " else {
        return false
      }
    }
    return true
  }
}


//MARK: - AuthenticationCodeBoxDelegate
extension ResetPasswordVC: AuthenticationCodeBoxDelegate {
  func didChangeValidity(isValid: Bool) {
    self.isEmptyOTP = !isValid
  }
}

//MARK: - ResetPasswordDelegate
extension ResetPasswordVC : ResetPasswordDelegate {
  func resetPasswordSuccess(_ isSucess: Bool) {
    presentAlertViewWithOneButtons(alertTitle: AlertMsg.SUCCESS, alertMessage: AlertMsg.RESETPASSSUCESSMSG, btnOneTitle: BUTTONTITLE.OK) { action in
      if let viewControllers = self.navigationController?.viewControllers {
        for viewController in viewControllers {
          if let vc = viewController as? LoginVC {
            self.navigationController?.popToViewController(vc, animated: true)
            break
          }
        }
      }
    }
  }
}
