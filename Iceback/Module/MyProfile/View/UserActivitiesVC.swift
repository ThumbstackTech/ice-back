//
//  NotificationVC.swift
//  Iceback
//
//  Created by Admin on 01/04/24.
//

import UIKit

class UserActivitiesVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblUserActivities: UITableView!
    @IBOutlet weak var btnClearActivitiesHistory: UIButton!
    @IBOutlet weak var lblUserActivitiesTitle: UILabel!
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    //MARK: - Constant & Variables
    var myProfileViewModel = MyProfileViewModel()
    var arrActivities: [Activity] = []
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        setUpController()
       initializeSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - SetupController
    func setUpController() {
        myProfileViewModel.userProfileDelegate = self
        myProfileViewModel.getUserProfile()
    }
    
    func languageLocalize() {
        lblUserActivitiesTitle.text = lblUserActivitiesTitle.text?.localized()
        btnClearActivitiesHistory.setTitle(BUTTONTITLE.CLEARACTIVITIESHISTORY.localized(), for: .normal)
        lblNoDataAvailable.text = lblNoDataAvailable.text?.localized()
    }
        
    //MARK: - XIB Register
    func xibRegister() {
        tblUserActivities.delegate = self
        tblUserActivities.dataSource = self
        tblUserActivities.registerCell(ofType: UserActivitiesTableViewCell.self)
        tblUserActivities.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 100, right: 0)
    }

   func initializeSetUp() {
      lblNoDataAvailable.textColor = AppThemeManager.shared.labelColor
      lblUserActivitiesTitle.textColor = AppThemeManager.shared.titleColor
      btnClearActivitiesHistory.setTitleColor(AppThemeManager.shared.buttonTitleColor, for: .normal)
      btnClearActivitiesHistory.backgroundColor = AppThemeManager.shared.primaryColor
   }
}


//MARK: - Button Actions
extension UserActivitiesVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnClearActivitiesHistoryAction(_ sender: UIButton) {
        myProfileViewModel.userActivitiesDeleteDelegate = self
        myProfileViewModel.userActivitiesDelete()
    }
}

//MARK: - UITableViewDataSource
extension UserActivitiesVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: UserActivitiesTableViewCell.self)
        cell.setup(arrActivities[indexPath.row])
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension UserActivitiesVC : UITableViewDelegate {
}

//MARK: - UserProfileDelegate
extension UserActivitiesVC : UserProfileDelegate {
    func getUserProfileDetails(_ objData: UserProfile) {
        lblNoDataAvailable.isHidden = objData.activities.isEmpty ?  false : true
        btnClearActivitiesHistory.isHidden = objData.activities.isEmpty ?  true : false
        arrActivities = objData.activities
        xibRegister()
    }    
}

//MARK: - UserActivitiesDeleteDelegate
extension UserActivitiesVC : UserActivitiesDeleteDelegate {
    func userActivitiesDeleteSuccess(isSucess: Bool) {
        arrActivities.removeAll()
        tblUserActivities.reloadData()
        lblNoDataAvailable.isHidden = false
        btnClearActivitiesHistory.isHidden = true
    }
}
