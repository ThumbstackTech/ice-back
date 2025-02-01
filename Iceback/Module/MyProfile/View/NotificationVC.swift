//
//  NotificationVC.swift
//  Iceback
//
//  Created by Admin on 01/04/24.
//

import UIKit

class NotificationVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblNotificationList: UITableView!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    
    //MARK: - Constant & Variables
    var arrNotification: [NotifcationData] = []
    var myProfileViewModel = MyProfileViewModel()
    private var intCurrentPage = 1
    var isLoadMore = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.appEFF8FF
        return refreshControl
    }()
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblNotificationList.addSubview(self.refreshControl)
        languageLocalize()
        setUpController()
        xibRegister()
       lblNotificationTitle.textColor = AppThemeManager.shared.titleColor
       lblNoDataAvailable.textColor = AppThemeManager.shared.labelColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - SetupController
    func setUpController() {
        myProfileViewModel.notificationsDelegate = self
        myProfileViewModel.notificationsList(intPageLimit: intCurrentPage)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblNotificationTitle.text = lblNotificationTitle.text?.localized()
        lblNoDataAvailable.text = lblNoDataAvailable.text?.localized()
    }
    
    //MARK: - RefreshControl
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        arrNotification.removeAll()
        isLoadMore = false
        lblNoDataAvailable.isHidden = true
        intCurrentPage = 1
        tblNotificationList.reloadData()
        myProfileViewModel.notificationsList(intPageLimit: intCurrentPage)
        refreshControl.endRefreshing()
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblNotificationList.delegate = self
        tblNotificationList.dataSource = self
        tblNotificationList.registerCell(ofType: NotificationTableViewCell.self)
        tblNotificationList.registerCell(ofType: BottomEmptyTableViewCell.self)
        tblNotificationList.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
}


//MARK: - Button Actions
extension NotificationVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - UITableViewDataSource
extension NotificationVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isLoadMore ? arrNotification.count + 1 :  arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == arrNotification.count && isLoadMore {
            let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
            emptyCell.setup(EMPTYCELLMESSAGE.FAVOURITEEMPTY)
            return emptyCell
        } else {
            let cell = tableView.dequeueCell(ofType: NotificationTableViewCell.self)
            cell.setup(arrNotification[indexPath.row])
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension NotificationVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       guard tableView.cellForRow(at: indexPath) is NotificationTableViewCell else { return }
        
        switch arrNotification[indexPath.row].notificationType {
      
        case NOTIFICATIONTYPE.NEWVOUCHERS.rawValue:
            let vc: DealsAndVouchersDetailsVC = DealsAndVouchersDetailsVC.instantiate(appStoryboard: .deals)
            vc.storeId = arrNotification[indexPath.row].notificationData?.data?.message?.storeId ?? 0
            vc.intDealId = arrNotification[indexPath.row].notificationData?.data?.message?.voucherId ?? 0
            vc.strCouponCode = arrNotification[indexPath.row].notificationData?.data?.message?.code ?? ""
            vc.strExpiryDate = arrNotification[indexPath.row].notificationData?.data?.message?.expiryDate ?? ""
            vc.strCouponDetail = arrNotification[indexPath.row].notificationData?.data?.message?.name ?? ""
            self.navigationController?.pushViewController(vc, animated: false)

        case NOTIFICATIONTYPE.NEWDONATIONPROJECT.rawValue:
            UserDefaultHelper.selectedTabIndex = 3
            UserDefaultHelper.selectedPreviousTabIndex = 5
            let vc: DonationProjectsVC = DonationProjectsVC.instantiate(appStoryboard: .donationProjects)
            self.navigationController?.pushViewController(vc, animated: false)

        case NOTIFICATIONTYPE.REPORTISSUE.rawValue:
            let vc: ReportIssueDetailVC = ReportIssueDetailVC.instantiate(appStoryboard: .reportIssue)
            vc.intReportId = arrNotification[indexPath.row].notificationData?.data?.message?.intReportId ?? 0
            self.navigationController?.pushViewController(vc, animated: false)

        case NOTIFICATIONTYPE.NEWSHOPS.rawValue:
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 1
            let vc: StoresVC = StoresVC.instantiate(appStoryboard: .stores)
            vc.strSelectedStore = "New"
            self.navigationController?.pushViewController(vc, animated: false)

        case NOTIFICATIONTYPE.DONATIONMILESTONE.rawValue:
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 3
            let vc: DonationProjectsVC = DonationProjectsVC.instantiate(appStoryboard: .donationProjects)
            self.navigationController?.pushViewController(vc, animated: false)

        case NOTIFICATIONTYPE.DONATIONRECIEVED.rawValue:
            UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
            UserDefaultHelper.selectedTabIndex = 3
            let vc: DonationProjectsVC = DonationProjectsVC.instantiate(appStoryboard: .donationProjects)
            self.navigationController?.pushViewController(vc, animated: false)
            
        default:
            break
        }
    }
}

//MARK: - UIScrollViewDelegate
extension NotificationVC: UIScrollViewDelegate {
   
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      
      if scrollView == tblNotificationList {
         if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if (arrNotification.count/Global.sharedManager.intStoreAndVouchersPageLimit) == intCurrentPage {
               tblNotificationList.showLoadingFooter()
               intCurrentPage += 1
               myProfileViewModel.notificationsList(intPageLimit: intCurrentPage)
               dPrint("Works Notification Pagination")
            } else {
               self.isLoadMore = arrNotification.isEmpty ? false : true
            }
         }
      }
   }
}


//MARK: - NotificationsDelegate
extension NotificationVC : NotificationsDelegate {
    func getNotifications(_ arrData: [NotifcationData]) {
        tblNotificationList.hideLoadingFooter()
        arrNotification.append(contentsOf: arrData)
        guard !arrData.isEmpty else {
            self.isLoadMore = arrNotification.isEmpty ? false : true
            lblNoDataAvailable.isHidden = arrNotification.isEmpty ? false : true
            tblNotificationList.reloadData()
            return
        }
        
        if arrData.count != Global.sharedManager.intStoreAndVouchersPageLimit{
            self.isLoadMore = arrNotification.isEmpty ? false : true
        }
      
        lblNoDataAvailable.isHidden = arrNotification.isEmpty ? false : true
        tblNotificationList.reloadData()
    }    
}
