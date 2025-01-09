//
//  EditProfileVC.swift
//  Iceback
//
//  Created by apple on 03/05/24.
//

import UIKit

class EditProfileVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFamilyName: UITextField!
    @IBOutlet weak var txtGivenName: UITextField!
    @IBOutlet weak var lblGivenNameTitle: UILabel!
    @IBOutlet weak var lblFamilyNameTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblEditProfileTitle: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    
    //MARK: - Variable
    var isProfileImageUpdate = false
    var imagePicker: ImagePicker!
    var myProfileViewModel = MyProfileViewModel()
    var arrProfilePicture : EditProfile?
    var arrProfileUpdate : EditAvatarData?
    var objectUrlKey : String = ""
    
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
        myProfileViewModel.userProfileDelegate = self
        myProfileViewModel.getUserProfile()
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblEditProfileTitle.text = lblEditProfileTitle.text?.localized()
        lblEmailTitle.text = lblEmailTitle.text?.localized()
        lblFamilyNameTitle.text = lblFamilyNameTitle.text?.localized()
        lblGivenNameTitle.text = lblGivenNameTitle.text?.localized()
        btnUpdate.setTitle(BUTTONTITLE.UPDATE.localized(), for: .normal)
    }
}

//MARK: - Button Action
extension EditProfileVC {
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditProfileImageAction(_ sender: UIButton) {
        imagePicker.present(from:sender)
    }
    
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        if isProfileImageUpdate {
            myProfileViewModel.HUD.show()
            self.uploadImage { [self] (remotePath) in
                myProfileViewModel.profilePictureDelegate = self
                myProfileViewModel.profilePicture(key: remotePath!)
                btnUpdate.isUserInteractionEnabled = false
            }
        } else {
            PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.PROFILEUPDATEDALREADY, withTimeoutImterval: 0.3)
        }
    }
    
}

//MARK: - ImagePickerDelegate
extension EditProfileVC:ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        imgProfile.image = image
        imgProfile.contentMode = .scaleAspectFill
        isProfileImageUpdate = true
    }
}

//MARK: - UserProfileDelegate
extension EditProfileVC: UserProfileDelegate {
    func getUserProfileDetails(_ objData: UserProfile) {
        txtEmail.text = objData.email
        txtGivenName.text = objData.firstName
        txtFamilyName.text = objData.lastName
        imgProfile.sd_setImage(with: URL(string: objData.avatar), placeholderImage: UIImage(named: "icn_profile"))
    }
    
    
}

//MARK: - ProfilePictureProtocol
extension EditProfileVC : ProfilePictureProtocol {
    
    func profilePictureDelegate(response: EditProfile) {
        btnUpdate.isUserInteractionEnabled = true
        if response.objectURL != "" {
            objectUrlKey =  response.objectURL
            
            myProfileViewModel.updateProfileDelegate = self
            myProfileViewModel.editProfile(key: objectUrlKey)
        }
    }
}

//MARK: - UpdateProfileProtocol
extension EditProfileVC : UpdateProfileProtocol {
    
    func editAvatarDelegate(_ strMessage: String) {
        btnUpdate.isUserInteractionEnabled = true
        isProfileImageUpdate = false
        
        let alert = UIAlertController(title: AlertMsg.SUCCESS.localized(), message: strMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized(), style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}


//MARK: - Upload Image in S3 Bucket
extension EditProfileVC {
    
    //MARK: - Issue image upload to S3bucket
    func uploadImage(_ completion: @escaping (String?)->Void){
        
        if imgProfile.image != nil {
            let compressImg = imgProfile.image?.resized(withPercentage: 0.5)
            if let pickedImage = compressImg {
                ImageUpload.shared.uploadImage(true, pickedImage, "image/jpeg", .kAWSDocumentPathProfileImage, nil, strVideoThumb: nil) { (fullPath, remotePath, index) in
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
