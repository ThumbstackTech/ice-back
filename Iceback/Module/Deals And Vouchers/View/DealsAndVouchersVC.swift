//
//  DealsAndVouchersVC.swift
//  Iceback
//
//  Created by Admin on 11/01/24.
//

import UIKit

class DealsAndVouchersVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var containerTabBarView: UIView!
  @IBOutlet weak var viewNew: UIView!
  @IBOutlet weak var lblNew: UILabel!
  @IBOutlet weak var viewTrending: UIView!
  @IBOutlet weak var lblTrending: UILabel!
  @IBOutlet weak var lblEmptyMsg: UILabel!
  @IBOutlet weak var txtSearch: AfterOneSecondTextField!
  @IBOutlet weak var tblDealsAndVouchersLists: UITableView!
  @IBOutlet weak var lblDealsAndVoucherTitle: UILabel!
  @IBOutlet weak var viewFilterApply: UIView!
  @IBOutlet weak var btnCancelSearch: UIButton!


  //MARK: - Constant & Variables
  private var dealsAndVouchersViewModel = DealsAndVouchersViewModel()

  private var arrNewFilterCategory : [FilterCategoriesData] = []
  private var arrTrendingFilterCategory : [FilterCategoriesData] = []

  private var arrNewFilterBy: [FilterListModel] = []
  private var arrTrendingFilterBy: [FilterListModel] = []

  private var intNewStoreCount = 0
  private var intTrendingStoreCount = 0

  private var arrNewDealsAndVouchers: [DealsAndVouchersData] = []
  private var arrTrendingDealsAndVouchers: [DealsAndVouchersData] = []

  private var arrNewCategorieId: [Int] = []
  private var arrTrendingCategorieId: [Int] = []

  private var intNewCurrentPage = 1
  private var intTrendingCurrentPage = 1

  private var strNewSearch = ""
  private var strTrendingSearch = ""

  private var intNewStoreId: Int = 0
  private var intTrendingStoreId: Int = 0

  private var isNewLoadMore = false
  private var isTrendingLoadMore = false

  private var arrNewStoreList: [AllStoreData] = []
  private var arrTrendingStoreList: [AllStoreData] = []

  private var isNewButtonClicked = true
  private var isTrendingButtonClicked = false

  private var isNewFilter = false
  private var isTrendingFilter = false

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
    refreshControl.tintColor = UIColor.appEFF8FF
    return refreshControl
  }()

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpController()
    xibRegister()
    searchText()
     initializeSetUp()
  }

  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
    filterSelected()
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  override func viewDidLayoutSubviews() {
    GCDMainThread.async { [self] in
      containerTabBarView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
  }

  //MARK: - XIB Register
  func xibRegister(){
    tblDealsAndVouchersLists.delegate = self
    tblDealsAndVouchersLists.dataSource = self
    tblDealsAndVouchersLists.registerCell(ofType: StoresAndDealsVouchersCell.self)
    tblDealsAndVouchersLists.registerCell(ofType: BottomEmptyTableViewCell.self)
    tblDealsAndVouchersLists.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
  }

  //MARK: - Setup Controller
  func setUpController() {
    navigationItem.hidesBackButton = true
    self.btnCancelSearch.isHidden = true
    lblNew.text = lblNew.text?.localized()
    lblTrending.text = lblTrending.text?.localized()
    lblDealsAndVoucherTitle.text = lblDealsAndVoucherTitle.text?.localized()
    lblEmptyMsg.text = lblEmptyMsg.text?.localized()
    txtSearch.placeholder = txtSearch.placeholder?.localized()

    dealsAndVouchersViewModel.newDealsAndVouchers(categories: "\(arrNewCategorieId)", currentPage: intNewCurrentPage, search: strNewSearch, storeId: intNewStoreId)
    dealsAndVouchersViewModel.newDealsAndVouchersSuccessDelegate = self
    dealsAndVouchersViewModel.newDealsAndVouchersFailureDelegate = self
    self.tblDealsAndVouchersLists.addSubview(self.refreshControl)
  }

   func initializeSetUp() {
      setLabelTextColor(labelColor: AppThemeManager.shared.labelColor)

      func setLabelTextColor(labelColor: UIColor) {
         lblDealsAndVoucherTitle.textColor = labelColor
      }
   }

  func removeDuplicateElements(posts: [StoreData]) -> [StoreData] {
    var uniquePosts = [StoreData]()
    for post in posts {
      if !uniquePosts.contains(where: {$0.id == post.id }) {
        uniquePosts.append(post)
      }
    }
    return uniquePosts
  }

  //MARK: - Search Text
  func searchText(){
    txtSearch.actionClosure = { [self] in
      dPrint("TEXT SEARCH",self.txtSearch.text ?? "EMPTY")
      GCDMainThread.asyncAfter(deadline: .now() + 0.0) { [self] in
        if isNewButtonClicked {
          strNewSearch = txtSearch.text ?? ""
          intNewCurrentPage = 1
          arrNewDealsAndVouchers.removeAll()
          isNewLoadMore = false
          tblDealsAndVouchersLists.reloadData()
          dealsAndVouchersViewModel.newDealsAndVouchers(categories: "\(arrNewCategorieId)", currentPage: intNewCurrentPage, search: strNewSearch, storeId: intNewStoreId)
        } else {
          strTrendingSearch = txtSearch.text ?? ""
          intTrendingCurrentPage = 1
          arrTrendingDealsAndVouchers.removeAll()
          isTrendingLoadMore = false
          tblDealsAndVouchersLists.reloadData()
          dealsAndVouchersViewModel.trendingDealsAndVouchers(categories: "\(arrTrendingCategorieId)", currentPage: intTrendingCurrentPage, search: strTrendingSearch, storeId: intTrendingStoreId)
        }
        dPrint("api calling")
      }
    }

    txtSearch.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
  }

  //MARK: - Filter Selected
  func filterSelected() {
    if isNewButtonClicked {
      viewFilterApply.isHidden = !isNewFilter
    } else {
      viewFilterApply.isHidden = !isTrendingFilter
    }
  }


  //MARK: - RefreshControl
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    if isNewButtonClicked {
      lblEmptyMsg.isHidden = true
      intNewCurrentPage = 1
      self.isNewLoadMore = false
      arrNewDealsAndVouchers.removeAll()
      tblDealsAndVouchersLists.reloadData()

      dealsAndVouchersViewModel.newDealsAndVouchers(categories: "\(arrNewCategorieId)", currentPage: intNewCurrentPage, search: strNewSearch, storeId: intNewStoreId)
    } else {
      intTrendingCurrentPage = 1
      self.isTrendingLoadMore = false
      lblEmptyMsg.isHidden = true
      arrTrendingDealsAndVouchers.removeAll()
      tblDealsAndVouchersLists.reloadData()

      dealsAndVouchersViewModel.trendingDealsAndVouchers(categories: "\(arrTrendingCategorieId)", currentPage: intTrendingCurrentPage, search: strTrendingSearch, storeId: intTrendingStoreId)
    }
    refreshControl.endRefreshing()
  }
}

//MARK: - Button Action
extension DealsAndVouchersVC {
  @IBAction func btnCancelSearchClk(_ sender: UIButton) {
    self.txtSearch.text = ""
    if isNewButtonClicked {
      strNewSearch = txtSearch.text ?? ""
      arrNewDealsAndVouchers.removeAll()
      intNewCurrentPage = 1
      self.isNewLoadMore = false
      tblDealsAndVouchersLists.reloadData()
      dealsAndVouchersViewModel.newDealsAndVouchers(categories: "\(arrNewCategorieId)", currentPage: intNewCurrentPage, search: strNewSearch, storeId: intNewStoreId)
    } else {
      strTrendingSearch = txtSearch.text ?? ""
      intTrendingCurrentPage = 1
      arrTrendingDealsAndVouchers.removeAll()
      self.isTrendingLoadMore = false
      tblDealsAndVouchersLists.reloadData()
      dealsAndVouchersViewModel.trendingDealsAndVouchers(categories: "\(arrTrendingCategorieId)", currentPage: intTrendingCurrentPage, search: strTrendingSearch, storeId: intTrendingStoreId)
    }
    self.btnCancelSearch.isHidden = true
  }

  @IBAction func btnNewClk(_ sender: UIButton) {
    txtSearch.resignFirstResponder()
    self.isNewButtonClicked = true
    lblEmptyMsg.isHidden = arrNewDealsAndVouchers.isEmpty ? false : true

    tblDealsAndVouchersLists.reloadData()
    viewNew.backgroundColor =  .appFFFFFF
    viewTrending.backgroundColor = .clear

    if !strNewSearch.isEmpty {
      txtSearch.text = strNewSearch
      btnCancelSearch.isHidden = false
    } else {
      btnCancelSearch.isHidden = true
      self.txtSearch.text = ""
    }
    lblNew.textColor = .app010101
    lblTrending.textColor = .appFFFFFF

    lblNew.font = AFont(size: 14, type: .Heavy)
    lblTrending.font = AFont(size: 14, type: .Roman)

    filterSelected()
    tblDealsAndVouchersLists.reloadData()
  }

  @IBAction func btnTrendingClk(_ sender: UIButton) {
    txtSearch.resignFirstResponder()
    self.isNewButtonClicked = false

    tblDealsAndVouchersLists.reloadData()
    viewTrending.backgroundColor = .appFFFFFF
    viewNew.backgroundColor = .clear

    lblTrending.textColor =  .app010101
    lblNew.textColor = .appFFFFFF
    if !strTrendingSearch.isEmpty {
      txtSearch.text = strTrendingSearch
    } else {
      btnCancelSearch.isHidden = true
      self.txtSearch.text = ""
    }
    lblTrending.font = AFont(size: 14, type: .Heavy)
    lblNew.font = AFont(size: 14, type: .Roman)
    filterSelected()
    if !isTrendingButtonClicked {
      dealsAndVouchersViewModel.trendingDealsAndVouchers(categories: "\(arrTrendingCategorieId)", currentPage: intTrendingCurrentPage, search: strTrendingSearch, storeId: intTrendingStoreId)
      dealsAndVouchersViewModel.trendingDealsAndVouchersSuccessDelegate = self
      dealsAndVouchersViewModel.trendingDealsAndVouchersFailureDelegate = self
      isTrendingButtonClicked = true
    } else {
      lblEmptyMsg.isHidden = arrTrendingDealsAndVouchers.isEmpty ? false : true
    }
    tblDealsAndVouchersLists.reloadData()
  }

  @objc func btnShopNowAction(_ sender: UIButton) {
    let vc: DealsAndVouchersDetailsVC = DealsAndVouchersDetailsVC.instantiate(appStoryboard:.deals)
    vc.storeId = isNewButtonClicked ? arrNewDealsAndVouchers[sender.tag].storeId : arrTrendingDealsAndVouchers[sender.tag].storeId
    vc.intDealId = isNewButtonClicked ? arrNewDealsAndVouchers[sender.tag].id : arrTrendingDealsAndVouchers[sender.tag].id
    vc.strCouponDetail = isNewButtonClicked ? arrNewDealsAndVouchers[sender.tag].name : arrTrendingDealsAndVouchers[sender.tag].name
    vc.strExpiryDate = isNewButtonClicked ? arrNewDealsAndVouchers[sender.tag].expiryDate : arrTrendingDealsAndVouchers[sender.tag].expiryDate
    vc.strCouponCode = isNewButtonClicked ? arrNewDealsAndVouchers[sender.tag].code : arrTrendingDealsAndVouchers[sender.tag].code
    self.navigationController?.pushViewController(vc, animated: false)
  }

  @IBAction func btnFilterByClk(_ sender: UIButton) {
    let vc: DealsAndVouchersFilterVC = DealsAndVouchersFilterVC.instantiate(appStoryboard:.deals)
    if isNewButtonClicked {
      vc.arrFilterStoreLists = arrNewStoreList
      vc.newDealsAndVoucherFilterDelegate = self
      vc.arrFilterCategoryList = arrNewFilterCategory
      vc.arrFilterStoreLists = arrNewStoreList
      if !arrNewFilterBy.isEmpty {
        vc.arrFilterBy = arrNewFilterBy
      }
      vc.isNewFilter = true
    } else {
      vc.arrFilterStoreLists = arrTrendingStoreList
      vc.trendingDealsAndVoucherFilterDelegate = self
      vc.arrFilterCategoryList = arrTrendingFilterCategory
      vc.arrFilterStoreLists = arrTrendingStoreList
      if !arrTrendingFilterBy.isEmpty {
        vc.arrFilterBy = arrTrendingFilterBy
      }
      vc.isNewFilter = false
    }
    self.navigationController?.pushViewController(vc, animated: false)
  }

  @objc func editingChanged(_ textField: UITextField) {

    guard  let clientName = txtSearch.text, !clientName.isEmpty
    else {

      btnCancelSearch.isHidden = true
      return
    }
    btnCancelSearch.isHidden = false
  }
}

//MARK: - UITableViewDataSource
extension DealsAndVouchersVC : UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isNewButtonClicked {
      return isNewLoadMore ?  arrNewDealsAndVouchers.count + 1 : arrNewDealsAndVouchers.count
    } else {
      return isTrendingLoadMore ?  arrTrendingDealsAndVouchers.count + 1 : arrTrendingDealsAndVouchers.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isNewButtonClicked {
      if indexPath.row == arrNewDealsAndVouchers.count && isNewLoadMore{
        let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
        emptyCell.setup(EMPTYCELLMESSAGE.DEALSANDVOUCHERSEMPTY)
        return emptyCell
      } else {
        let storeCell = tableView.dequeueCell(ofType: StoresAndDealsVouchersCell.self)
        storeCell.btnShopNow.tag = indexPath.row
        storeCell.btnShopNow.addTarget(self, action: #selector(btnShopNowAction), for: .touchUpInside)
        storeCell.setup(arrNewDealsAndVouchers[indexPath.row])
        return storeCell
      }
    } else {
      if indexPath.row == arrTrendingDealsAndVouchers.count && isTrendingLoadMore{
        let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
        emptyCell.setup(EMPTYCELLMESSAGE.DEALSANDVOUCHERSEMPTY)
        return emptyCell
      } else {
        let storeCell = tableView.dequeueCell(ofType: StoresAndDealsVouchersCell.self)
        storeCell.btnShopNow.tag = indexPath.row
        storeCell.btnShopNow.addTarget(self, action: #selector(btnShopNowAction), for: .touchUpInside)
        storeCell.setup(arrTrendingDealsAndVouchers[indexPath.row])
        return storeCell
      }
    }

  }

}

//MARK: - UITableViewDelegate
extension DealsAndVouchersVC : UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard tableView.cellForRow(at: indexPath) is StoresAndDealsVouchersCell else { return }
    let vc: DealsAndVouchersDetailsVC = DealsAndVouchersDetailsVC.instantiate(appStoryboard:.deals)
    vc.storeId = isNewButtonClicked ? arrNewDealsAndVouchers[indexPath.row].storeId : arrTrendingDealsAndVouchers[indexPath.row].storeId
    vc.intDealId = isNewButtonClicked ? arrNewDealsAndVouchers[indexPath.row].id : arrTrendingDealsAndVouchers[indexPath.row].id
    vc.strCouponDetail = isNewButtonClicked ? arrNewDealsAndVouchers[indexPath.row].name : arrTrendingDealsAndVouchers[indexPath.row].name
    vc.strExpiryDate = isNewButtonClicked ? arrNewDealsAndVouchers[indexPath.row].expiryDate : arrTrendingDealsAndVouchers[indexPath.row].expiryDate
    vc.strCouponCode = isNewButtonClicked ? arrNewDealsAndVouchers[indexPath.row].code : arrTrendingDealsAndVouchers[indexPath.row].code
    self.navigationController?.pushViewController(vc, animated: false)
  }

}


//MARK: - UIScrollViewDelegate
extension DealsAndVouchersVC: UIScrollViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    if scrollView == tblDealsAndVouchersLists {
      if isNewButtonClicked {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
          if (arrNewDealsAndVouchers.count/Global.sharedManager.intStoreAndVouchersPageLimit) == intNewCurrentPage {
            tblDealsAndVouchersLists.showLoadingFooter()
            intNewCurrentPage += 1
            dealsAndVouchersViewModel.newDealsAndVouchers(categories: "\(arrNewCategorieId)", currentPage: intNewCurrentPage, search: strNewSearch, storeId: intNewStoreId)
            dPrint("Works")
          } else {
            self.isNewLoadMore = arrNewDealsAndVouchers.isEmpty ? false : true
          }
        }
      } else {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
          if (arrTrendingDealsAndVouchers.count/Global.sharedManager.intStoreAndVouchersPageLimit) == intTrendingCurrentPage {
            tblDealsAndVouchersLists.showLoadingFooter()
            intTrendingCurrentPage += 1
            dealsAndVouchersViewModel.trendingDealsAndVouchers(categories: "\(arrTrendingCategorieId)", currentPage: intTrendingCurrentPage, search: strTrendingSearch, storeId: intTrendingStoreId)
            dPrint("Works")
          }else {
            self.isTrendingLoadMore = arrTrendingDealsAndVouchers.isEmpty ? false : true
          }
        }

      }
    }
  }
}

//MARK: - NewDealsAndVouchersSuccessDelegate
extension DealsAndVouchersVC: NewDealsAndVouchersSuccessDelegate {
  func newDealsAndVouchersSuccess(_ arrData: [DealsAndVouchersData]) {
    self.tblDealsAndVouchersLists.hideLoadingFooter()

    self.arrNewDealsAndVouchers.append(contentsOf: arrData)

    guard !arrData.isEmpty else {
      self.isNewLoadMore = arrNewDealsAndVouchers.isEmpty ? false : true
      self.lblEmptyMsg.isHidden = arrNewDealsAndVouchers.isEmpty ? false : true
      self.tblDealsAndVouchersLists.reloadData()
      return
    }

    if arrData.count != Global.sharedManager.intStoreAndVouchersPageLimit{
      self.isNewLoadMore = arrNewDealsAndVouchers.isEmpty ? false : true
    }

    dPrint("NEW  STORE LIST COUNT: \(arrNewDealsAndVouchers.count)")
    lblEmptyMsg.isHidden = arrNewDealsAndVouchers.isEmpty ? false : true
    tblDealsAndVouchersLists.reloadData()
  }
}

//MARK: - TrendingDealsAndVouchersSuccessDelegate
extension DealsAndVouchersVC: TrendingDealsAndVouchersSuccessDelegate {
  func trendingDealsAndVouchersSuccess(_ arrData: [DealsAndVouchersData]) {
    self.tblDealsAndVouchersLists.hideLoadingFooter()

    self.arrTrendingDealsAndVouchers.append(contentsOf: arrData)

    guard !arrData.isEmpty else {
      self.isTrendingLoadMore = arrTrendingDealsAndVouchers.isEmpty ? false : true
      lblEmptyMsg.isHidden = arrTrendingDealsAndVouchers.isEmpty ? false : true
      tblDealsAndVouchersLists.reloadData()
      return
    }

    if arrData.count != Global.sharedManager.intStoreAndVouchersPageLimit{
      self.isTrendingLoadMore = arrTrendingDealsAndVouchers.isEmpty ? false : true
    }


    dPrint("TRENDING STORE LIST COUNT: \(arrTrendingDealsAndVouchers.count)")
    lblEmptyMsg.isHidden = arrTrendingDealsAndVouchers.isEmpty ? false : true
    tblDealsAndVouchersLists.reloadData()
  }
}

//MARK: - NewDealsAndVouchersFailureDelegate
extension DealsAndVouchersVC: NewDealsAndVouchersFailureDelegate {
  func newDealsAndVouchersFailure(_ isFailure: Bool) {
    self.tblDealsAndVouchersLists.hideLoadingFooter()
    self.isNewLoadMore = arrNewDealsAndVouchers.isEmpty ? false : true
    lblEmptyMsg.isHidden = arrNewDealsAndVouchers.isEmpty ? false : true
  }

}

//MARK: - TrendingDealsAndVouchersFailureDelegate
extension DealsAndVouchersVC: TrendingDealsAndVouchersFailureDelegate {
  func trendingDealsAndVouchersFailure(_ isFailure: Bool) {
    self.tblDealsAndVouchersLists.hideLoadingFooter()
    self.isTrendingLoadMore = arrTrendingDealsAndVouchers.isEmpty ? false : true
    lblEmptyMsg.isHidden = arrTrendingDealsAndVouchers.isEmpty ? false : true
    tblDealsAndVouchersLists.reloadData()
  }

}
//MARK: - NewDealsAndVoucherFilterDelegate
extension DealsAndVouchersVC: NewDealsAndVoucherFilterDelegate {
  func newDealsAndVoucherFilter(arrCategory: [FilterCategoriesData], arrStore: [AllStoreData], arrFilterBy: [FilterListModel]) {

    arrNewDealsAndVouchers.removeAll()
    intNewCurrentPage = 1

    self.lblEmptyMsg.isHidden = true
    self.arrNewFilterCategory = arrCategory
    self.arrNewStoreList = arrStore
    self.arrNewCategorieId.removeAll()
    self.isNewLoadMore = false
    let data = arrCategory.filter({$0.isSelected == true})
    for temp in data {
      arrNewCategorieId.append(temp.categoryId)
    }

    let dataStore = arrNewStoreList.filter({$0.isSelected == true})
    if !dataStore.isEmpty {
      intNewStoreId = dataStore.first?.id ?? 0
    } else {
      intNewStoreId = 0
    }

    if arrFilterBy.first?.count != 0 || arrFilterBy.last?.count != 0 {
      isNewFilter = true
    } else {
      isNewFilter = false
    }
    self.arrNewFilterBy = arrFilterBy
    tblDealsAndVouchersLists.reloadData()
    dealsAndVouchersViewModel.newDealsAndVouchers(categories: "\(arrNewCategorieId)", currentPage: intNewCurrentPage, search: strNewSearch, storeId: intNewStoreId)
  }
}

//MARK: - TrendingDealsAndVoucherFilterDelegate
extension DealsAndVouchersVC: TrendingDealsAndVoucherFilterDelegate {
  func trendingDealsAndVoucherFilterDelegate(arrCategory: [FilterCategoriesData], arrStore: [AllStoreData], arrFilterBy: [FilterListModel]) {
    arrTrendingDealsAndVouchers.removeAll()
    intTrendingCurrentPage = 1

    self.lblEmptyMsg.isHidden = true
    self.arrTrendingFilterCategory = arrCategory
    self.arrTrendingStoreList = arrStore
    self.arrTrendingCategorieId.removeAll()
    self.isTrendingLoadMore = false

    let data = arrCategory.filter({$0.isSelected == true})
    for temp in data {
      arrTrendingCategorieId.append(temp.categoryId)
    }

    let dataStore = arrTrendingStoreList.filter({$0.isSelected == true})
    if !dataStore.isEmpty {
      intTrendingStoreId = dataStore.first?.id ?? 0
    }else {
      intTrendingStoreId = 0
    }

    if arrFilterBy.first?.count != 0 || arrFilterBy.last?.count != 0 {
      isTrendingFilter = true
    } else {
      isTrendingFilter = false
    }
    self.arrTrendingFilterBy = arrFilterBy
    tblDealsAndVouchersLists.reloadData()
    dealsAndVouchersViewModel.trendingDealsAndVouchers(categories: "\(arrTrendingCategorieId)", currentPage: intTrendingCurrentPage, search: strTrendingSearch, storeId: intTrendingStoreId)
  }

}

//MARK: - UITextFieldDelegate
extension DealsAndVouchersVC : UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
      return false
    }
    return true
  }
}
