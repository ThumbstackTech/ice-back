//
//  CustomerSupportVC.swift
//  Iceback
//
//  Created by APPLE on 10/01/24.
//

import UIKit
import CountryPickerView
import MobileCoreServices
import UniformTypeIdentifiers


class CustomerSupportVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblFileAttachName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblPhoneTitle: UILabel!
    @IBOutlet weak var lblMessageTitle: UILabel!
    @IBOutlet weak var lblSubjectTitle: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK: - Constant & Variables
    var myProfileViewModel = MyProfileViewModel()
    
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
    
    
    //MARK: - Language Localize
    func languageLocalize() {
        txtMessage.text = LABELTITLE.ENTERMESSAGETITLE.localized()
        lblTitle.text = lblTitle.text?.localized()
        lblNameTitle.text = lblNameTitle.text?.localized()
        lblEmailTitle.text = lblEmailTitle.text?.localized()
        lblMessageTitle.text = lblMessageTitle.text?.localized()
        btnSubmit.setTitle(BUTTONTITLE.SUBMIT.localized(), for: .normal)
        txtName.placeholder = txtName.placeholder?.localized()
        txtName.placeholder = txtName.placeholder?.localized()
        txtEmailAddress.placeholder = txtEmailAddress.placeholder?.localized()
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        txtMessage.delegate = self
    }
    
}

//MARK: - Button Action
extension CustomerSupportVC {
    @IBAction func btnBackClk(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnSubmitClk(_ sender: UIButton) {
        guard txtName.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.FULLNAME.localized())
            return
        }
        
        guard txtEmailAddress.text != "" else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.EMAILADDRESS.localized())
            return
        }
        
        guard Utility.isValidEmail(strEmail: txtEmailAddress.text ?? "") else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.EMAILVALIDMSG.localized())
            return
        }
    
        guard txtMessage.text != LABELTITLE.ENTERMESSAGETITLE.localized() else{
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CUSTOMERSUPPORTMESSAGE.localized())
            return
        }
        
        myProfileViewModel.customerSupport(name: txtName.text!, email: txtEmailAddress.text!, message: txtMessage.text!)
        myProfileViewModel.customerSupportDelegate = self
                
    }
    
}


//MARK: - UITextViewDelegate
extension CustomerSupportVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtMessage.text == LABELTITLE.ENTERMESSAGETITLE.localized() {
            txtMessage.text = nil
            txtMessage.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtMessage.text.isEmpty {
            txtMessage.text = LABELTITLE.ENTERMESSAGETITLE.localized()
            txtMessage.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.location == 0 && (text .rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        return true
    }
}

//MARK: - CustomerSupportDelegate
extension CustomerSupportVC: CustomerSupportDelegate {
    func customerSupport(_ strMsg: String) {
        presentAlertViewWithOneButtons(alertTitle: AlertMsg.SUCCESS.localized(), alertMessage: AlertMsg.CUSTOMERSUPPORTSUCESSMSG.localized(), btnOneTitle: BUTTONTITLE.OK.localized()) { success in
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
}


//MARK: - UITextFieldDelegate
extension CustomerSupportVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        return true
    }
}

