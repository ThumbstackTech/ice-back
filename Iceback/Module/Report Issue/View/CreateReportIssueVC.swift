//
//  CreateReportIssueVC.swift
//  Iceback
//
//  Created by Admin on 10/04/24.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
import AVKit
import Photos
import PhotosUI


class CreateReportIssueVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnAddFile: UIButton!
    @IBOutlet weak var lblUploadImageTitle: UILabel!
    @IBOutlet weak var lblImageName: UILabel!
    @IBOutlet weak var lblSubjectTitle: UILabel!
    @IBOutlet weak var lblReportIssueTitle: UILabel!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var imgReport: UIImageView!
    @IBOutlet weak var viewReportImage: UIView!
    @IBOutlet weak var btnRemoveImage: UIButton!
    
    //MARK: - Constant & Variables
    private var imagePicker: ImagePicker!
    var appendCreateReportIssueDelegate: AppendCreateReportIssueDelegate!
    var reportViewModel = ReportViewModel()

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
    
    //MARK: - SetupController
    func setUpController() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        tvMessage.text = "Enter message".localized()
        txtSubject.placeholder = txtSubject.placeholder?.localized()
        
        lblMessage.text = lblMessage.text?.localized()
        lblSubjectTitle.text = lblSubjectTitle.text?.localized()
        lblImageName.text = lblImageName.text?.localized()
        lblReportIssueTitle.text = lblReportIssueTitle.text?.localized()
        lblUploadImageTitle.text = lblUploadImageTitle.text?.localized()
        
        btnAddFile.setTitle(BUTTONTITLE.ADDFILE.localized(), for: .normal)
        btnSubmit.setTitle(BUTTONTITLE.SUBMIT.localized(), for: .normal)
    }
}

//MARK: - Button Actions
extension CreateReportIssueVC {
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        guard txtSubject.text != ""   else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CUSTOMERSUPPORTSUBJECT.localized())
            return
        }
        
        guard tvMessage.text != ""  else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CUSTOMERSUPPORTMESSAGE.localized())
            return
        }

        guard  tvMessage.text != "Enter message".localized() else {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.CUSTOMERSUPPORTMESSAGE.localized())
            return
        }
        
        self.reportViewModel.createReportDelegate  = self
        reportViewModel.HUD.show()
        if imgReport.image != nil   {
            self.uploadImage { [self] (remotePath) in
                self.reportViewModel.createReport(subject: txtSubject.text!, detail: tvMessage.text!, key:remotePath)
            }
        }else{
            self.reportViewModel.createReport(subject: txtSubject.text!, detail: tvMessage.text!, key:nil)
        }
        
        btnSubmit.isUserInteractionEnabled = false
    }
    
    @IBAction func btnAddFileAction(_ sender: UIButton) {
        imagePicker.present(from:sender)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnRemoveImageAction(_ sender: UIButton) {
        lblImageName.text = "Upload image".localized()
        viewReportImage.isHidden = true
        btnRemoveImage.isHidden = true
    }
    
}

//MARK: - UITextViewDelegate
extension CreateReportIssueVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvMessage.text == "Enter message".localized() {
            tvMessage.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvMessage.text.isEmpty {
            tvMessage.text = "Enter message".localized()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.location == 0 && (text.rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        return true
    }
}

//MARK: - Image Picker Delegate
extension CreateReportIssueVC:ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        imgReport.image = image
        viewReportImage.isHidden = false
        btnRemoveImage.isHidden = false
        if let imageName = image?.imageAsset?.value(forKey: "assetName") as? String {
            lblImageName.text = imageName
        }
    }
}

//MARK: - CreateReportDelegate
extension CreateReportIssueVC : CreateReportDelegate {
    func createReportSuccess(_ data: ReportListData) {
        btnSubmit.isUserInteractionEnabled = true
        let alert = UIAlertController(title: AlertMsg.SUCCESS, message: AlertMsg.DATASUCCESS, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [self]
                    UIAlertAction in
                    dPrint("OK Pressed")
                self.navigationController?.popViewController(animated: true)
                }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
    }
}

//MARK: - Issue image upload to S3bucket
extension CreateReportIssueVC {
        func uploadImage(_ completion: @escaping (String?)->Void){
        
        if imgReport.image != nil {
            let compressImg = imgReport.image?.resized(withPercentage: 0.5)
            if let pickedImage = compressImg {
                ImageUpload.shared.uploadImage(true, pickedImage, "image/jpeg", .kAWSDocumentPathIssueImage, nil, strVideoThumb: nil) { (fullPath, remotePath, index) in
                    if remotePath != nil {
                        completion(remotePath)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else{
            completion(nil)
        }
    }
}

//MARK: - UITextFieldDelegate
extension CreateReportIssueVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
            return false
        }
        
        return true
    }
}
