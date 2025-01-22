//
//  PurchaseHistoryVC.swift
//  Iceback
//
//  Created by Admin on 26/03/24.
//

import UIKit

class PurchaseHistoryVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblPurchaseHistoty: UITableView!
    @IBOutlet weak var btnReportIssue: UIButton!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblPurchaseHistoryTitle: UILabel!
    @IBOutlet weak var lblMyBalance: UILabel!
    @IBOutlet weak var lblMyBalanceTitle: UILabel!
    
    //MARK: - Constant & Variables
    var myProfileViewModel = MyProfileViewModel()
    var arrUserProfile : UserProfile?
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        setUpController()
        xibRegister()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblPurchaseHistoty.delegate = self
        tblPurchaseHistoty.dataSource = self
        tblPurchaseHistoty.registerCell(ofType: PurchaseHistoryTableViewCell.self)
        tblPurchaseHistoty.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 70, right: 0)
    }
    
    //MARK: - SetupController
    func setUpController() {
        myProfileViewModel.userProfileDelegate = self
        myProfileViewModel.getUserProfile()
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblNoDataFound.text = lblNoDataFound.text?.localized()
        lblPurchaseHistoryTitle.text = lblPurchaseHistoryTitle.text?.localized()
        lblMyBalanceTitle.text = lblMyBalanceTitle.text?.localized()
        btnReportIssue.setTitle(BUTTONTITLE.REPORTISSUE.localized(), for: .normal)
        
    }
}

//MARK: - Button Actions
extension PurchaseHistoryVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnReportIssueAction(_ sender: UIButton) {
        let vc: CreateReportIssueVC = CreateReportIssueVC.instantiate(appStoryboard: .reportIssue)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension PurchaseHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserProfile?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: PurchaseHistoryTableViewCell.self)
        cell.setup(arrUserProfile?.transactions[indexPath.row])
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension PurchaseHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: CouponDetailsVC = CouponDetailsVC.instantiate(appStoryboard:.stores)
        vc.intStoreId = arrUserProfile?.transactions[indexPath.row].storeId ?? 0
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - UserProfileDelegate
extension PurchaseHistoryVC: UserProfileDelegate {
    func getUserProfileDetails(_ objData: UserProfile) {
        arrUserProfile = objData
        
        if objData.balance != 0.0 {
            lblMyBalance.text = (removeDecimalIfZeroTwoDigit(from: objData.balance)) + " CHF"
        }else {
            lblMyBalance.text = (removeDecimalIfZeroTwoDigit(from: objData.expectedUserCashback)) + " CHF"
        }
        tblPurchaseHistoty.reloadData()
        lblNoDataFound.isHidden = objData.transactions.isEmpty ? false : true
    }    
}
