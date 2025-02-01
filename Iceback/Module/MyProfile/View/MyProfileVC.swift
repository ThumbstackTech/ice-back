//
//  MyProfileVC.swift
//  Iceback
//
//  Created by apple on 03/05/24.
//

import UIKit

class MyProfileVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblMyProfileTitle: UILabel!
    
    //MARK: - Constant & Variables
    var arrMenu : [MyProfileMenu] = []
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        setUpController()
        xibRegister()
       initializeSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - SetupController
    func setUpController() {
        navigationItem.hidesBackButton = true
        
        arrMenu.append(contentsOf: [.editProfile, .favourites, .userActivities,.customerSupport, .notificationTitle, .purchaseHistory, .reports, .biometricLogin, .deleteAccount])
    }
    
    func xibRegister() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nibWithCellClass: MyProfileMenuCell.self)
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblMyProfileTitle.text = lblMyProfileTitle.text?.localized()
    }   

   func initializeSetUp() {
      lblMyProfileTitle.textColor = AppThemeManager.shared.secondaryColor
   }
}

//MARK: - Button Actions
extension MyProfileVC {
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchBioMetricAction(_ sender: UISwitch) {
        if UserDefaultHelper.isBiometric {
            UserDefaultHelper.isBiometric  = false
        }else {
            UserDefaultHelper.isBiometric = true
        }
    }
}

//MARK: - UITableViewDataSource
extension MyProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MyProfileMenuCell.self)
        cell.switchEnable.isHidden = true
        cell.imgNxt.isHidden = false
        cell.setup(arrMenu[indexPath.row].rawValue)
        
        if arrMenu[indexPath.row] == MyProfileMenu.biometricLogin {
            cell.switchEnable.isHidden = false
            cell.imgNxt.isHidden = true
            cell.switchEnable.isOn = UserDefaultHelper.isBiometric
            cell.switchEnable.addTarget(self, action: #selector(switchBioMetricAction), for: .touchUpInside)
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension MyProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrMenu[indexPath.row] {
            
        case .editProfile:
            let vc: EditProfileVC = EditProfileVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .customerSupport:
            let vc: CustomerSupportVC = CustomerSupportVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)

        case .userActivities:
            let vc: UserActivitiesVC = UserActivitiesVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .notificationTitle:
            let vc: NotificationVC = NotificationVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)

        case .purchaseHistory:
            let vc: PurchaseHistoryVC = PurchaseHistoryVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)

        case .biometricLogin:
            break

        case .deleteAccount:
            let vc: LogoutPopupVC = LogoutPopupVC.instantiate(appStoryboard: .main)
            vc.modalPresentationStyle = .custom
            vc.isLogout = false
            self.navigationController?.present(vc, animated: false)

        case .reports:
            let vc: ReportIssuesVC = ReportIssuesVC.instantiate(appStoryboard: .reportIssue)
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .favourites:
            let vc: FavouritesVC = FavouritesVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
