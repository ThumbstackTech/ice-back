//
//  CustomSideMenuVC.swift
//  Iceback
//
//  Created by Admin on 11/01/24.
//

import UIKit

import Foundation
import UIKit

class CustomSideMenuVC: UIViewController {
    
    @IBOutlet weak var tblMenu: UITableView!
    
    var arrMenu : [SIDEMENU] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        xibRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setupControls() {
        navigationItem.hidesBackButton = true
        if UserDefaultHelper.isLogin {
            arrMenu.append(contentsOf: [.myProfile, .aboutUs,  .terms, .privacyPolicy, .selectLanguage, .logout])
        }else {
            arrMenu.append(contentsOf: [.aboutUs, .terms, .privacyPolicy, .selectLanguage , .login])
        }
    }
    
    func xibRegister() {
        tblMenu.dataSource = self
        tblMenu.delegate = self
        tblMenu.register(nibWithCellClass: MenuListCell.self)
    }
    
    //MARK: - Button Actions
    @IBAction func btnCloseClicked(_ sender: UIButton) {
            navigationController?.popViewController(animated: true)
        }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource methods
extension CustomSideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MenuListCell.self)
        cell.setup(arrMenu[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrMenu[indexPath.row] {
      
        case .aboutUs:
            let vc: CMSVC = CMSVC.instantiate(appStoryboard: .sideMenu)
            vc.slug = "about-us"
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .terms:
            let vc: CMSVC = CMSVC.instantiate(appStoryboard: .sideMenu)
            vc.slug = "terms-and-conditions"
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .privacyPolicy:
            let vc: CMSVC = CMSVC.instantiate(appStoryboard: .sideMenu)
            vc.slug = "privacy-policy"
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .myProfile :
            let vc: MyProfileVC = MyProfileVC.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .logout:
            let vc: LogoutPopupVC = LogoutPopupVC.instantiate(appStoryboard: .main)
            vc.modalPresentationStyle = .custom
            vc.isLogout = true
            self.navigationController?.present(vc, animated: false)
            
        case .login:
            Global.destroySharedManager()
            let vc: LoginVC = LoginVC.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated: false)
            
        case .selectLanguage:
            let vc: SelectLanguageVC = SelectLanguageVC.instantiate(appStoryboard: .sideMenu)
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
    }
}
