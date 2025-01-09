//
//  HomeIceBackVC.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit


class HomeVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var containerTabBarView: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var tblHome: UITableView!
    
    //MARK: - Constant & Variables
    var arrCashback: [ShopWithCashbackData] = []
    var arrVouchers: [SpecialAndVoucherData] = []
    var arrDonationProjects: [DonationProjectsData] = []
    var arrHomeList = HomeSection.allCases
    var homeViewModel = HomeViewModel()
    var lRFViewModel = LRFViewModel()
    var donationProjectsViewModel = DonationProjectsViewModel()
    var objHomeData: HomeData = HomeData(jsonData: [:])
    var isCashback = false
    var isHomeSucess = false
    var objContentData: ContentData?
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        GCDMainThread.async { [self] in
            containerTabBarView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        }
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblHome.delegate = self
        tblHome.dataSource = self
        tblHome.registerCell(ofType: HeroSectionTableViewCell.self)
        tblHome.registerCell(ofType: HeaderTitleTableViewCell.self)
        tblHome.registerCell(ofType: HowItWorksTableViewCell.self)
        tblHome.registerCell(ofType: TitleAndViewMoreTableViewCell.self)
        tblHome.registerCell(ofType: ShopsOrVochersTableViewCell.self)
        tblHome.registerCell(ofType: DonationTableViewCell.self)
        tblHome.registerCell(ofType: ReferAFriendsTableViewCell.self)
        tblHome.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.isHomeSucess = true
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        
        homeViewModel.homeDetailDelegate = self
        homeViewModel.homeDetailData()
        
        if UserDefaultHelper.isLogin {
            lRFViewModel.registerDeviceToken(fcmToken: UserDefaultHelper.device_token)
        }
    }
    
    //MARK: - Navigate To Stores Screen
    func navigateToStoresScreen() {
        UserDefaultHelper.selectedPreviousTabIndex = 0
        UserDefaultHelper.selectedTabIndex = 1
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)

        appendControllerToNavigationStack()
        
        self.navigationController?.navigateToViewController(type: StoresVC.self, animated: false, storyboard: AppStoryboard.stores)
    }
    
    //MARK: - Navigate To Deals And Vouchers Screen
    func navigateToDealsAndVouchersScreen() {
        
        UserDefaultHelper.selectedPreviousTabIndex = 0
        UserDefaultHelper.selectedTabIndex = 2
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)

        appendControllerToNavigationStack()
        
        self.navigationController?.navigateToViewController(type: DealsAndVouchersVC.self, animated: false, storyboard: AppStoryboard.deals)
    }
    
    //MARK: - Navigate To Donation Projects Screen
    func navigateToDonationProjectsScreen() {
        UserDefaultHelper.selectedPreviousTabIndex = 0
        UserDefaultHelper.selectedTabIndex = 3
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
        
        appendControllerToNavigationStack()
        
        self.navigationController?.navigateToViewController(type: DonationProjectsVC.self, animated: false, storyboard: AppStoryboard.donationProjects)
    }
}

//MARK: - Button Action
extension HomeVC {
    @objc func btnIWantToKnowMoreAction(_ sender: UIButton) {
        let vc: IWantToKnowMoreVC = IWantToKnowMoreVC.instantiate(appStoryboard:.home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSignUpAction(_ sender: UIButton) {
//        let vc: WKWebViewVC = WKWebViewVC.instantiate(appStoryboard:.stores)
//        vc.strWebviewURL = REDIRECTIONURL.GETMYCARDURL.localized()
//        self.navigationController?.pushViewController(vc, animated: false)
        PPAlerts.sharedAlerts().iOsAlert(title:"", withMessage: AlertMsg.GETMYCARD.localized() , withDelegate: nil)
    }
    
    @objc func btnViewMoreAction(_ sender: UIButton) {
        //MARK:- Navigate To Store
        if sender.tag == 3 {
           navigateToStoresScreen()
        }
        //MARK:- Navigate To Deals And Vouchers
        else if sender.tag == 5 {
          navigateToDealsAndVouchersScreen()
        }
        //MARK:- Navigate To Donation Projects
        else if sender.tag == 7 {
           navigateToDonationProjectsScreen()
        }
    }
}

//MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrHomeList[indexPath.row] {
            
        case .heroSection:
            let cell = tableView.dequeueCell(ofType: HeroSectionTableViewCell.self)
            cell.btnSignUp.addTarget(self, action: #selector(btnSignUpAction), for: .touchUpInside)
            let data = objHomeData.content.filter({$0.type == "content_block"})
            cell.setup(data.first)
            return cell
        case .howItWorkTitle:
            let cell = tableView.dequeueCell(ofType: HeaderTitleTableViewCell.self)
            let data = objHomeData.content.filter({$0.type == "how_it_works_block"})
            cell.lblHeaderTitle.text = data.first?.title
            return cell
        case .howItWork:
            let cell = tableView.dequeueCell(ofType: HowItWorksTableViewCell.self)
            cell.tableViewReloadDelegate = self
            cell.navigateToStoreDelegate = self
            cell.navigateToCashbackDelegate = self
            cell.navigateToProjectDetailsDelegate = self
            let data = objHomeData.content.filter({$0.type == "how_it_works_block"})
            cell.arrHowItWorks = data.first?.howItWorksItems ?? []
            return cell
        case .shopWithCashbackTitle:
            let cell = tableView.dequeueCell(ofType: TitleAndViewMoreTableViewCell.self)
            let data = objHomeData.content.filter({$0.type == "stores_with_cashback"})
            cell.lblViewMoreTitle.text = data.first?.title
            cell.btnViewMore.tag = indexPath.row
            cell.btnViewMore.addTarget(self, action: #selector(btnViewMoreAction), for: .touchUpInside)
            return cell
        case .shopWithCashback:
            let cell = tableView.dequeueCell(ofType: ShopsOrVochersTableViewCell.self)
            cell.isCashback = true
            cell.constCollShopsOrVochersHeight.constant = 165
            cell.arrCashback = arrCashback
            cell.navigateToStoreDetailDelegate = self
            return cell
        case .specialAndVoucherTitle:
            let cell = tableView.dequeueCell(ofType: TitleAndViewMoreTableViewCell.self)
            let data = objHomeData.content.filter({$0.type == "special_deals_and_vouchers"})
            cell.lblViewMoreTitle.text = data.first?.title
            cell.btnViewMore.tag = indexPath.row
            cell.btnViewMore.addTarget(self, action: #selector(btnViewMoreAction), for: .touchUpInside)
            return cell
        case .specialAndVoucher:
            let cell = tableView.dequeueCell(ofType: ShopsOrVochersTableViewCell.self)
            cell.isCashback = false
            cell.constCollShopsOrVochersHeight.constant = 130
            cell.arrVouchers = arrVouchers
            cell.navigateToStoreDetailDelegate = self
            return cell
        case .donationProjectsTitle:
            let cell = tableView.dequeueCell(ofType: TitleAndViewMoreTableViewCell.self)
            cell.lblViewMoreTitle.text = LABELTITLE.DONATIONPROJECTJOINTITLE.localized()
            cell.btnViewMore.tag = indexPath.row
            cell.btnViewMore.addTarget(self, action: #selector(btnViewMoreAction), for: .touchUpInside)
            return cell
        case .donationProjects:
            let cell = tableView.dequeueCell(ofType: DonationTableViewCell.self)
            cell.setup(arrDonationProjects.first)
            return cell
        case .referAFriendsTitle:
            let cell = tableView.dequeueCell(ofType: HeaderTitleTableViewCell.self)
            cell.lblHeaderTitle.text = objContentData?.title
            return cell
        case .referAFriends:
            let cell = tableView.dequeueCell(ofType: ReferAFriendsTableViewCell.self)
            cell.btnIWantToKnowMore.addTarget(self, action: #selector(btnIWantToKnowMoreAction), for: .touchUpInside)
            cell.setup(objContentData)
            return cell
        }
    }
    
    
}

//MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrHomeList[indexPath.row] {
        case .donationProjects:
            let vc: DonationProjectsDetailsVC = DonationProjectsDetailsVC.instantiate(appStoryboard:.donationProjects)
            vc.objDonationProjectDetail = arrDonationProjects.first
            vc.isHome = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

//MARK: - TableViewReload
extension HomeVC: TableViewReloadDelegate {
    func reloadTableView() {
        tblHome.reloadData()
        print("DELEGATE TABLEVIEW RELOAD")
    }
}

//MARK: - NavigateToStoreDelegate
extension HomeVC: NavigateToStoreDelegate {
    func navigateToStore() {
        navigateToStoresScreen()
    }
}

//MARK: - NavigateToProjectDetailsDelegate
extension HomeVC: NavigateToProjectDetailsDelegate {
    func navigateToProjectDetails() {
        navigateToDonationProjectsScreen()
    }
}

//MARK: - HomeDetailDelegate
extension HomeVC: HomeDetailDelegate {
    func homeDetail(_ homeData: HomeData) {
        self.objHomeData = homeData
        let data = objHomeData.content.filter({($0.type == "text_with_image") && ($0.button2_Text != "")})
        self.objContentData = data.last
        if data.count == 0 {
            arrHomeList.removeLast()
            arrHomeList.removeLast()
        }
        xibRegister()
        
        donationProjectsViewModel.donationProjectsListDelegate = self
        donationProjectsViewModel.donationProjectsList(pageCount: 1, limitCount: 1)
        
        homeViewModel.homeSpecialAndVoucherDelegate = self
        homeViewModel.homeSpecialAndVoucher()
        
        homeViewModel.homeShopWithCashbackDelegate = self
        homeViewModel.homeShopWithCashback()
      
    }
    
}

//MARK: - HomeShopWithCashbackDelegate
extension HomeVC: HomeShopWithCashbackDelegate {
    func shopWithCashback(_ arrData: [ShopWithCashbackData]) {
        print("SHOP WITH CASHBACK DELEGATE: \(arrData.count)")
        self.arrCashback = arrData
        if isHomeSucess {
            self.tblHome.reloadData()
        }
    }
    
}
//MARK: - HomeSpecialAndVoucherDelegate
extension HomeVC: HomeSpecialAndVoucherDelegate {
    func specialAndVoucher(_ arrData: [SpecialAndVoucherData]) {
        print("SPECIAL VOUCHER DELEGATE: \(arrData.count)")
        self.arrVouchers = arrData
        if isHomeSucess {
            self.tblHome.reloadData()
        }
    }
    
}

//MARK: - DonationProjectsListDelegate
extension HomeVC: DonationProjectsListDelegate {
    func DonationProjectsListSuccess(_ arrData: [DonationProjectsData], totalData: Int, pageLimit: Int) {
        self.arrDonationProjects = arrData
        if isHomeSucess {
            self.tblHome.reloadData()
        }
    }
}

//MARK: - NavigateToStoreDetailDelegate
extension HomeVC: NavigateToStoreDetailDelegate {
    func navigateToStoreDetail(_ intStoreId: Int, _ intDealId: Int, _ isCasback: Bool, name: String, expiryDate: String, couponCode: String) {
        if isCasback {
            let vc: CouponDetailsVC = CouponDetailsVC.instantiate(appStoryboard:.stores)
            vc.intStoreId = intStoreId
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc: DealsAndVouchersDetailsVC = DealsAndVouchersDetailsVC.instantiate(appStoryboard:.deals)
            vc.storeId = intStoreId
            vc.intDealId = intDealId
            vc.strCouponDetail = name
            vc.strExpiryDate = expiryDate
            vc.strCouponCode = couponCode
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - NavigateToCashbackDelegate
extension HomeVC: NavigateToCashbackDelegate {
    func navigateToCashback() {
        let vc: CashbackVC = CashbackVC.instantiate(appStoryboard:.home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
