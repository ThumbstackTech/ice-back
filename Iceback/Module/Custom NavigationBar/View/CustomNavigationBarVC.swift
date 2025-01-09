//
//  NavigationBarVC.swift
//  Iceback
//
//  Created by Admin on 09/01/24.
//

import UIKit

class CustomNavigationBarVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnSideMenu: UIButton!
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        GCDMainThread.async { [self] in
            btnSideMenu.circleCorner = true
        }
    }
}

//MARK: - Button Action
extension CustomNavigationBarVC {
    @IBAction func btnSideMenuAction(_ sender: UIButton) {
        let vc: CustomSideMenuVC = CustomSideMenuVC.instantiate(appStoryboard: .sideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
