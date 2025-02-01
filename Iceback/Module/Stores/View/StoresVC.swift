//
//  StoresVC.swift
//  Iceback
//
//  Created by Admin on 11/01/24.
//

import UIKit

class StoresVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var containerTabBarView: UIView!
  @IBOutlet weak var viewAll: UIView!
  @IBOutlet weak var lblAll: UILabel!
  @IBOutlet weak var viewNew: UIView!
  @IBOutlet weak var lblNew: UILabel!
  @IBOutlet weak var viewTrending: UIView!
  @IBOutlet weak var lblTrending: UILabel!
  @IBOutlet weak var txtSearch: AfterOneSecondTextField!
  @IBOutlet weak var tblStoreLists: UITableView!
  @IBOutlet weak var FirstAllView: UIView!
  @IBOutlet weak var lastTrendingView: UIView!
  @IBOutlet weak var lblStoreTitle: UILabel!
  @IBOutlet weak var viewFilterApply: UIView!
  @IBOutlet weak var viewSortBy: UIView!
  @IBOutlet weak var btnCancelSearch: UIButton!
  @IBOutlet weak var lblNoDataAvailable: UILabel!

  @IBOutlet weak var btnAll: UIButton!
  @IBOutlet weak var btnNew: UIButton!
  @IBOutlet weak var btnTrending: UIButton!

  //MARK: - Constant & Variables
  private var arrAllStoreCategoryLists : [FilterCategoriesData] = []
  private var arrAllStoreRegionLists : [FilterRegionDataObject] = []

  private var arrNewStoreCategoryLists : [FilterCategoriesData] = []
  private var arrNewStoreRegionLists : [FilterRegionDataObject] = []

  private var arrTrendingStoreCategoryLists : [FilterCategoriesData] = []
  private var arrTrendingStoreRegionLists : [FilterRegionDataObject] = []

  private var AllStoreCategoryCount = 0
  private var AllStoreRegionCount = 0

  private var NewStoreCategoryCount = 0
  private var NewStoreRegionCount = 0

  private var TrendingStoreCategoryCount = 0
  private var TrendingStoreRegionCount = 0

  private var isAllClear = true
  private var isNewClear = true
  private var isTrendingClear = true

  private var strAllSearch = ""
  private var strNewSearch = ""
  private var strTrendingSearch = ""

  private var currentAllStorePage = 1
  private var currentNewStorePage = 1
  private var currentTrendingStorePage = 1

  var passAllCategoriesIds = [Int]()
  var passAllRegionIds = [Int]()

  var passNewCategoriesIds = [Int]()
  var passNewRegionIds = [Int]()

  var passTrendingCategoriesIds = [Int]()
  var passTrendingRegionIds = [Int]()

  var isCatApply = false
  var isRegionApply = false

  var strSelectedStore = "All"

  var isAllFilterApply = false
  var isNewFilterApply = false
  var isTrendingFilterApply = false

  var AllStoreIndex = 0
  var NewStoreIndex = 0
  var TrendingStoreIndex = 0

  private var viewModelStoresData = StoresViewModel()
  private var dealsAndVouchersViewModel = DealsAndVouchersViewModel()

  var arrAllstoreLists: [storeDataListObject] = []
  var arrNewstoreLists: [storeDataListObject] = []
  var arrTrendingstoreLists: [storeDataListObject] = []

  var arrAppendNewStoreLists = [storeDataListObject]()

  var isAllLoadMore = false
  var isNewLoadMore = false
  var isTrendingLoadMore = false

  var isTrending = false

  var isStoreAllCategoryApply = false
  var isStoreNewCategoryApply = false
  var isStoreTrendingCategoryApply = false
  var isStoreAllRegionApply = false
  var isStoreNewRegionApply = false
  var isStoreTrendingRegionApply = false

  var isFirstTimeAll = false
  var isFirstTimeNew = false
  var isFirstTimeTrending = false
  var isAllSortingApplied = false
  var isNewSortingApplied = false
  var isTrendingSortingApplied = false
  var allSortByCashbackPercentage = ""
  var allSortByName = ""
  var newSortByCashbackPercentage = ""
  var newSortByName = ""
  var trendingSortByCashbackPercentage = ""
  var trendingSortByName = ""
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
    refreshControl.tintColor = UIColor.appEFF8FF
    return refreshControl
  }()

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.removeFavouriteStore(_:)), name: NSNotification.Name.init(rawValue: "RemoveFavouriteStore"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.addFavouriteStore(_:)), name: NSNotification.Name.init(rawValue: "AddFavouriteStore"), object: nil)
    xibRegister()
    setUpController()
    searchStore()
     initializeSetUp()
    self.tblStoreLists.addSubview(self.refreshControl)

  }

  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
    checkFilterSelected()
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  override func viewDidLayoutSubviews() {
    GCDMainThread.async { [self] in
      containerTabBarView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
  }

  //MARK: - XIB Register
  func xibRegister(){
    tblStoreLists.delegate = self
    tblStoreLists.dataSource = self
    tblStoreLists.registerCell(ofType: StoresAndDealsVouchersCell.self)
    tblStoreLists.registerCell(ofType: BottomEmptyTableViewCell.self)
    tblStoreLists.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
  }

   func initializeSetUp() {
      setLabelTextColor(labelColor: AppThemeManager.shared.labelColor)

      func setLabelTextColor(labelColor: UIColor) {
         lblAll.textColor = labelColor
         lblNew.textColor = labelColor
         lblTrending.textColor = labelColor
         lblStoreTitle.textColor = labelColor
         lblNoDataAvailable.textColor = labelColor
      }
   }

  //MARK: - Search Store
  func searchStore() {
    txtSearch.actionClosure = { [self] in

      if self.txtSearch.text!.count > 0 {
        self.btnCancelSearch.isHidden = false
      } else {
        self.btnCancelSearch.isHidden = true
      }

      if strSelectedStore == StoresTypes.All {
        strAllSearch = self.txtSearch.text ?? ""
        currentAllStorePage = 1
        arrAllstoreLists.removeAll()
        isAllLoadMore = false
        viewModelStoresData.isStoreTrending = false
        viewModelStoresData.StoresLists(page: currentAllStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, sortbycashbackpercentage: allSortByCashbackPercentage, sortbyname: allSortByName)

      } else if strSelectedStore == StoresTypes.New {
        strNewSearch = self.txtSearch.text ?? ""
        currentNewStorePage = 1
        arrNewstoreLists.removeAll()
        isNewLoadMore = false
        viewModelStoresData.isStoreTrending = false
        viewModelStoresData.StoresLists(page: currentNewStorePage, regions: passNewRegionIds, categories: passNewCategoriesIds,search: strNewSearch, isNewStore: true, sortbycashbackpercentage: newSortByCashbackPercentage, sortbyname: newSortByName)
      } else {
        strTrendingSearch = self.txtSearch.text ?? ""
        currentTrendingStorePage = 1
        arrTrendingstoreLists.removeAll()
        isTrendingLoadMore = false
        viewModelStoresData.isStoreTrending = true
        viewModelStoresData.StoresLists(page: currentTrendingStorePage, regions: passTrendingRegionIds, categories: passTrendingCategoriesIds,search: strTrendingSearch, sortbycashbackpercentage: trendingSortByCashbackPercentage, sortbyname: trendingSortByName)
      }

      self.tblStoreLists.reloadData()
    }
    txtSearch.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
  }

  @objc func editingChanged(_ textField: UITextField) {

    guard  let clientName = txtSearch.text, !clientName.isEmpty
    else {

      btnCancelSearch.isHidden = true
      return
    }
    btnCancelSearch.isHidden = false
  }

  //MARK: - RefreshControl
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    if strSelectedStore == StoresTypes.All {
      arrAllstoreLists.removeAll()
      lblNoDataAvailable.isHidden = true
      isAllLoadMore = false
      currentAllStorePage = 1
    } else if strSelectedStore == StoresTypes.New {
      arrNewstoreLists.removeAll()
      currentNewStorePage = 1
      isNewLoadMore = false
      lblNoDataAvailable.isHidden = true
    } else {
      arrTrendingstoreLists.removeAll()
      currentTrendingStorePage = 1
      isTrendingLoadMore = false
      lblNoDataAvailable.isHidden = true
    }
    self.tblStoreLists.reloadData()
    APICall()

    refreshControl.endRefreshing()
  }

  //MARK: - Setup Controller
  func setUpController() {
    navigationItem.hidesBackButton = true
    self.lblNoDataAvailable.isHidden = true
    self.btnCancelSearch.isHidden = true
    FirstAllView.isHidden = true
    viewSortBy.isHidden = true
    lastTrendingView.isHidden = false
    lblAll.text = lblAll.text?.localized()
    lblNew.text = lblNew.text?.localized()
    lblStoreTitle.text = lblStoreTitle.text?.localized()
    txtSearch.placeholder = txtSearch.placeholder?.localized()
    lblTrending.text = lblTrending.text?.localized()
    lblNoDataAvailable.text = lblNoDataAvailable.text?.localized()


    viewModelStoresData.StoresFailureHandleDelegate = self
    viewModelStoresData.StoresListDelegate = self

    if strSelectedStore == StoresTypes.New {
      btnNewClk(btnNew)
    } else {
      APICall()
    }

  }

  func checkSortingSelected() {
    if strSelectedStore == StoresTypes.All {
      if AllStoreIndex == 0 {
        viewSortBy.isHidden = true
      } else {
        viewSortBy.isHidden = false
      }
    }else if strSelectedStore == StoresTypes.New {
      if NewStoreIndex == 0 {
        viewSortBy.isHidden = true
      } else {
        viewSortBy.isHidden = false
      }
    }else {
      if TrendingStoreIndex == 0 {
        viewSortBy.isHidden = true
      } else {
        viewSortBy.isHidden = false
      }
    }
  }

  func checkFilterSelected() {
    if strSelectedStore == StoresTypes.All {
      viewSortBy.isHidden = AllStoreIndex == 0 ? true : false
      if isAllClear {
        viewFilterApply.isHidden = true
      } else if isAllFilterApply {
        viewFilterApply.isHidden = false
      }

    } else if strSelectedStore == StoresTypes.New {
      viewSortBy.isHidden = NewStoreIndex == 0 ? true : false
      if isNewClear {
        viewFilterApply.isHidden = true
      } else if isNewFilterApply {
        viewFilterApply.isHidden = false
      }

    } else {
      viewSortBy.isHidden = TrendingStoreIndex == 0 ? true : false
      if isTrendingClear {
        viewFilterApply.isHidden = true
      }else if isTrendingFilterApply {
        viewFilterApply.isHidden = false
      }
    }
  }

  @objc func removeFavouriteStore(_ notification: NSNotification) {
    guard let intStoreId = notification.userInfo?["storeId"] as? Int else {
      return
    }
    dPrint("NSNotification CALLED STOREID: ", intStoreId)
    let dataAll = arrAllstoreLists.first(where: {$0.storeId == intStoreId})
    if dataAll != nil {
      dataAll?.isFavourite = 0
    }

    let dataNew = arrNewstoreLists.first(where: {$0.storeId == intStoreId})
    if dataNew != nil {
      dataNew?.isFavourite = 0
    }

    let dataTrending = arrTrendingstoreLists.first(where: {$0.storeId == intStoreId})
    if dataTrending != nil {
      dataTrending?.isFavourite = 0
    }
    tblStoreLists.reloadData()
  }

  @objc func addFavouriteStore(_ notification: NSNotification) {
    guard let intStoreId = notification.userInfo?["storeId"] as? Int else {
      return
    }
    dPrint("NSNotification CALLED STOREID: ", intStoreId)
    let dataAll = arrAllstoreLists.first(where: {$0.storeId == intStoreId})
    if dataAll != nil {
      dataAll?.isFavourite = 1
    }

    let dataNew = arrNewstoreLists.first(where: {$0.storeId == intStoreId})
    if dataNew != nil {
      dataNew?.isFavourite = 1
    }

    let dataTrending = arrTrendingstoreLists.first(where: {$0.storeId == intStoreId})
    if dataTrending != nil {
      dataTrending?.isFavourite = 1
    }
    tblStoreLists.reloadData()
  }
}

//MARK: - Button Action
extension StoresVC {
  @IBAction func btnCancelSearchClk(_ sender: UIButton) {
    self.txtSearch.text = ""
    self.btnCancelSearch.isHidden = true
    self.lblNoDataAvailable.isHidden = true

    if strSelectedStore == StoresTypes.All {
      strAllSearch = self.txtSearch.text ?? ""
      currentAllStorePage = 1
      isAllLoadMore = false
      arrAllstoreLists.removeAll()
      tblStoreLists.reloadData()
      viewModelStoresData.isStoreTrending = false
      viewModelStoresData.StoresLists(page: currentAllStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, sortbycashbackpercentage: allSortByCashbackPercentage, sortbyname: allSortByName)
      isFirstTimeAll = true
    } else if strSelectedStore == StoresTypes.New {
      strNewSearch = self.txtSearch.text ?? ""
      currentNewStorePage = 1
      isNewLoadMore = false
      viewModelStoresData.isStoreTrending = false
      arrNewstoreLists.removeAll()
      tblStoreLists.reloadData()
      viewModelStoresData.StoresLists(page: currentNewStorePage, regions: passNewRegionIds, categories: passNewCategoriesIds,search: strNewSearch, isNewStore: true, sortbycashbackpercentage: newSortByCashbackPercentage, sortbyname: newSortByName)
      isFirstTimeNew = true
    } else {
      strTrendingSearch = self.txtSearch.text ?? ""
      currentTrendingStorePage = 1
      isTrendingLoadMore = false
      viewModelStoresData.isStoreTrending = true
      arrTrendingstoreLists.removeAll()
      tblStoreLists.reloadData()
      viewModelStoresData.StoresLists(page: currentTrendingStorePage, regions: passTrendingRegionIds, categories: passTrendingCategoriesIds,search: strTrendingSearch, sortbycashbackpercentage: trendingSortByCashbackPercentage, sortbyname: trendingSortByName)
      isFirstTimeTrending = true
    }

  }

  @IBAction func btnAllClk(_ sender: UIButton) {

    viewFilterApply.isHidden = isAllClear ? true : false
    lblNoDataAvailable.isHidden = true
    if AllStoreIndex == 0  {
      viewSortBy.isHidden = true
    } else {
      viewSortBy.isHidden = false
    }

    txtSearch.resignFirstResponder()

    btnCancelSearch.isHidden = true
    tblStoreLists.reloadData()

    viewAll.backgroundColor =  .appFFFFFF
    viewNew.backgroundColor = .clear
    viewTrending.backgroundColor = .clear

    lblAll.textColor =  .app010101
    lblNew.textColor =  .appFFFFFF
    lblTrending.textColor =  .appFFFFFF

    lblAll.font =  AFont(size: 14, type: .Heavy)
    lblNew.font =  AFont(size: 14, type: .Roman)
    lblTrending.font =  AFont(size: 14, type: .Roman)
    FirstAllView.isHidden = true
    lastTrendingView.isHidden = false

    if !strAllSearch.isEmpty {
      self.txtSearch.text = strAllSearch
      self.btnCancelSearch.isHidden = false

    } else {
      self.btnCancelSearch.isHidden = true
      self.txtSearch.text = ""
    }

    isTrending = false
    strSelectedStore = StoresTypes.All

    if !isFirstTimeAll {
      currentAllStorePage = 1
      APICall()
    } else {
      lblNoDataAvailable.isHidden = arrAllstoreLists.isEmpty ? false : true
    }
    self.tblStoreLists.reloadData()
  }

  @IBAction func btnNewClk(_ sender: UIButton) {

    viewFilterApply.isHidden = isNewClear ? true : false
    lblNoDataAvailable.isHidden = true
    if NewStoreIndex == 0 {
      viewSortBy.isHidden = true
    } else {
      viewSortBy.isHidden = false
    }

    txtSearch.resignFirstResponder()

    btnCancelSearch.isHidden = true

    viewNew.backgroundColor = .appFFFFFF
    viewAll.backgroundColor = .clear
    viewTrending.backgroundColor = .clear

    lblNew.textColor = .app010101
    lblAll.textColor =  .appFFFFFF
    lblTrending.textColor =  .appFFFFFF

    lblAll.font =  AFont(size: 14, type: .Roman)
    lblNew.font =  AFont(size: 14, type: .Heavy)
    lblTrending.font =  AFont(size: 14, type: .Roman)

    FirstAllView.isHidden = true
    lastTrendingView.isHidden = true

    self.txtSearch.text = ""

    if !strNewSearch.isEmpty {
      self.txtSearch.text = strNewSearch
      self.btnCancelSearch.isHidden = false
    } else {
      self.btnCancelSearch.isHidden = true
      self.txtSearch.text = ""
    }

    isTrending = false

    strSelectedStore = StoresTypes.New

    if !isFirstTimeNew {
      currentNewStorePage = 1
      APICall()
    } else {
      lblNoDataAvailable.isHidden = arrNewstoreLists.isEmpty ? false : true
    }
    self.tblStoreLists.reloadData()

  }

  @IBAction func btnTrendingClk(_ sender: UIButton) {

    viewFilterApply.isHidden = isTrendingClear ? true : false
    lblNoDataAvailable.isHidden = true
    if TrendingStoreIndex == 0  {
      viewSortBy.isHidden = true
    } else {
      viewSortBy.isHidden = false
    }

    txtSearch.resignFirstResponder()

    btnCancelSearch.isHidden = true
    tblStoreLists.reloadData()
    viewTrending.backgroundColor =  .appFFFFFF
    viewNew.backgroundColor = .clear
    viewAll.backgroundColor = .clear

    lblTrending.textColor = .app010101
    lblAll.textColor =  .appFFFFFF
    lblNew.textColor =  .appFFFFFF

    lblAll.font =  AFont(size: 14, type: .Roman)
    lblNew.font =  AFont(size: 14, type: .Roman)
    lblTrending.font =  AFont(size: 14, type: .Heavy)
    FirstAllView.isHidden = false
    lastTrendingView.isHidden = true


    if !strTrendingSearch.isEmpty {
      self.txtSearch.text = strTrendingSearch
      self.btnCancelSearch.isHidden = false
    } else {
      self.btnCancelSearch.isHidden = true
      self.txtSearch.text = ""
    }

    isTrending = true

    strSelectedStore = StoresTypes.Trending

    if !isFirstTimeTrending {
      currentTrendingStorePage = 1
      APICall()
    } else {
      lblNoDataAvailable.isHidden = arrTrendingstoreLists.isEmpty ? false : true
    }
    self.tblStoreLists.reloadData()
  }

  @IBAction func btnFilterClk(_ sender: UIButton) {
    let vc: SortByVC = SortByVC.instantiate(appStoryboard:.stores)
    vc.modalPresentationStyle = .custom

    if strSelectedStore == StoresTypes.All {
      vc.previousIndex = AllStoreIndex
    } else if strSelectedStore == StoresTypes.New {
      vc.previousIndex = NewStoreIndex
    } else {
      vc.previousIndex = TrendingStoreIndex
    }

    vc.sortByDelegate = self
    self.navigationController?.present(vc, animated: false)
  }


  @IBAction func btnTorchClk(_ sender: UIButton) {

    let vc: FilterVC = FilterVC.instantiate(appStoryboard:.stores)
    vc.filterByDelegate = self
    vc.isFromStores = true
    vc.isFromTrending = isTrending
    vc.StoreType = strSelectedStore


    if strSelectedStore == StoresTypes.All {
      if isAllFilterApply {
        vc.isStoreAllCategoryApply = isStoreAllCategoryApply
        vc.isStoreAllRegionApply = isStoreAllRegionApply
        vc.arrAllStoreCategoriesIds = passAllCategoriesIds
        vc.arrAllStoreRegionIds = passAllRegionIds
        vc.arrCategoryLists = arrAllStoreCategoryLists
        vc.arrRegionLists = arrAllStoreRegionLists
        vc.AllStoreCategoryCount = AllStoreCategoryCount
        vc.AllStoreRegionCount = AllStoreRegionCount
      }
    } else if strSelectedStore == StoresTypes.New {
      if isNewFilterApply {
        vc.isStoreNewCategoryApply = isStoreNewCategoryApply
        vc.isStoreNewRegionApply = isStoreNewRegionApply
        vc.arrNewStoreCategoriesIds = passNewCategoriesIds
        vc.arrNewStoreRegionIds = passNewRegionIds
        vc.arrCategoryLists = arrNewStoreCategoryLists
        vc.arrRegionLists = arrNewStoreRegionLists
        vc.NewStoreCategoryCount = NewStoreCategoryCount
        vc.NewStoreRegionCount = NewStoreRegionCount
      }
    } else {
      if isTrendingFilterApply {
        vc.isStoreTrendingCategoryApply = isStoreTrendingCategoryApply
        vc.isStoreTrendingRegionApply = isStoreTrendingRegionApply
        vc.arrTrendingStoreCategoriesIds = passTrendingCategoriesIds
        vc.arrTrendingStoreRegionIds = passTrendingRegionIds
        vc.arrCategoryLists = arrTrendingStoreCategoryLists
        vc.arrRegionLists = arrTrendingStoreRegionLists
        vc.TrendingStoreCategoryCount = TrendingStoreCategoryCount
        vc.TrendingStoreRegionCount = TrendingStoreRegionCount
      }
    }
    self.navigationController?.pushViewController(vc, animated: false)
  }

  @objc func btnShopNowAction(_ sender: UIButton) {

    let vc: CouponDetailsVC = CouponDetailsVC.instantiate(appStoryboard:.stores)
    if strSelectedStore == StoresTypes.All {
      vc.intStoreId = arrAllstoreLists[sender.tag].storeId
    } else if strSelectedStore == StoresTypes.New {
      vc.intStoreId = arrNewstoreLists[sender.tag].storeId
    } else {
      vc.intStoreId = arrTrendingstoreLists[sender.tag].storeId
    }

    self.navigationController?.pushViewController(vc, animated: false)
  }

  @objc func btnFavouriteAction(_ sender: UIButton) {
    if strSelectedStore == StoresTypes.All {
      if arrAllstoreLists[sender.tag].isFavourite == 1 {
        viewModelStoresData.favouriteStoreRemoveDelegate = self
        viewModelStoresData.favouriteStoreRemove(storeId: arrAllstoreLists[sender.tag].storeId, intIndex: sender.tag)
      } else {
        viewModelStoresData.favouriteStoreAddDelegate = self
        viewModelStoresData.favouriteStoreAdd(storeId: arrAllstoreLists[sender.tag].storeId, intIndex: sender.tag)
      }
    } else if strSelectedStore == StoresTypes.New {
      if arrNewstoreLists[sender.tag].isFavourite == 1 {
        viewModelStoresData.favouriteStoreRemoveDelegate = self
        viewModelStoresData.favouriteStoreRemove(storeId: arrNewstoreLists[sender.tag].storeId, intIndex: sender.tag)
      } else {
        viewModelStoresData.favouriteStoreAddDelegate = self
        viewModelStoresData.favouriteStoreAdd(storeId: arrNewstoreLists[sender.tag].storeId, intIndex: sender.tag)
      }
    } else {
      if arrTrendingstoreLists[sender.tag].isFavourite == 1 {
        viewModelStoresData.favouriteStoreRemoveDelegate = self
        viewModelStoresData.favouriteStoreRemove(storeId: arrTrendingstoreLists[sender.tag].storeId, intIndex: sender.tag)
      } else {
        viewModelStoresData.favouriteStoreAddDelegate = self
        viewModelStoresData.favouriteStoreAdd(storeId: arrTrendingstoreLists[sender.tag].storeId, intIndex: sender.tag)
      }
    }
  }

}
//MARK: - UITableViewDataSource
extension StoresVC : UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if strSelectedStore == StoresTypes.All {
      return isAllLoadMore ? arrAllstoreLists.count + 1 : arrAllstoreLists.count
    } else if strSelectedStore == StoresTypes.New {
      return isNewLoadMore ? arrNewstoreLists.count + 1 : arrNewstoreLists.count
    } else {
      return isTrendingLoadMore ? arrTrendingstoreLists.count + 1 : arrTrendingstoreLists.count
    }

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if strSelectedStore == StoresTypes.All {
      if indexPath.row == arrAllstoreLists.count && isAllLoadMore {
        let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
        emptyCell.setup(EMPTYCELLMESSAGE.STORESEMPTY)
        return emptyCell
      } else {
        let storeCell = tableView.dequeueCell(ofType: StoresAndDealsVouchersCell.self)
        storeCell.btnShopNow.tag = indexPath.row
        storeCell.btnFavourite.tag = indexPath.row
        storeCell.btnShopNow.addTarget(self, action: #selector(btnShopNowAction), for: .touchUpInside)
        storeCell.btnFavourite.addTarget(self, action: #selector(btnFavouriteAction), for: .touchUpInside)
        storeCell.btnFavourite.isHidden = UserDefaultHelper.isLogin ? false : true
        storeCell.setup(arrAllstoreLists[indexPath.row])
        return storeCell
      }
    } else if strSelectedStore == StoresTypes.New {

      if indexPath.row == arrNewstoreLists.count && isNewLoadMore {
        let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
        emptyCell.setup(EMPTYCELLMESSAGE.STORESEMPTY)
        return emptyCell
      } else {
        let storeCell = tableView.dequeueCell(ofType: StoresAndDealsVouchersCell.self)
        storeCell.btnShopNow.tag = indexPath.row
        storeCell.btnFavourite.tag = indexPath.row
        storeCell.btnShopNow.addTarget(self, action: #selector(btnShopNowAction), for: .touchUpInside)
        storeCell.btnFavourite.addTarget(self, action: #selector(btnFavouriteAction), for: .touchUpInside)
        storeCell.btnFavourite.isHidden = UserDefaultHelper.isLogin ? false : true
        storeCell.setup(arrNewstoreLists[indexPath.row])
        return storeCell
      }
    } else {
      if indexPath.row == arrTrendingstoreLists.count && isTrendingLoadMore {
        let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
        emptyCell.setup(EMPTYCELLMESSAGE.STORESEMPTY)
        return emptyCell
      } else {
        let storeCell = tableView.dequeueCell(ofType: StoresAndDealsVouchersCell.self)
        storeCell.btnShopNow.tag = indexPath.row
        storeCell.btnFavourite.tag = indexPath.row
        storeCell.btnShopNow.addTarget(self, action: #selector(btnShopNowAction), for: .touchUpInside)
        storeCell.btnFavourite.addTarget(self, action: #selector(btnFavouriteAction), for: .touchUpInside)
        storeCell.btnFavourite.isHidden = UserDefaultHelper.isLogin ? false : true
        storeCell.setup(arrTrendingstoreLists[indexPath.row])
        return storeCell
      }
    }
  }
}

//MARK: - UITableViewDelegate
extension StoresVC : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard tableView.cellForRow(at: indexPath) is StoresAndDealsVouchersCell else { return }
    let vc: CouponDetailsVC = CouponDetailsVC.instantiate(appStoryboard:.stores)
    if strSelectedStore == StoresTypes.All {
      vc.intStoreId = arrAllstoreLists[indexPath.row].storeId
    } else if strSelectedStore == StoresTypes.New {
      vc.intStoreId = arrNewstoreLists[indexPath.row].storeId
    } else {
      vc.intStoreId = arrTrendingstoreLists[indexPath.row].storeId
    }
    self.navigationController?.pushViewController(vc, animated: false)
  }
}


//MARK: - UIScrollViewDelegate
extension StoresVC: UIScrollViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    if scrollView == tblStoreLists {
      if strSelectedStore == StoresTypes.All {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
          if (arrAllstoreLists.count/Global.sharedManager.intStoreAndVouchersPageLimit) == currentAllStorePage {
            tblStoreLists.showLoadingFooter()
            currentAllStorePage += 1
            viewModelStoresData.StoresLists(page: currentAllStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, sortbycashbackpercentage: allSortByCashbackPercentage, sortbyname: allSortByName)
            dPrint("Works All Store")
          } else {
            self.isAllLoadMore = arrAllstoreLists.isEmpty ? false : true
          }
        }
      } else if strSelectedStore == StoresTypes.New {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
          if (arrNewstoreLists.count/Global.sharedManager.intStoreAndVouchersPageLimit) == currentNewStorePage {
            tblStoreLists.showLoadingFooter()
            currentNewStorePage += 1
            viewModelStoresData.StoresLists(page: currentNewStorePage, regions: passNewRegionIds, categories: passNewCategoriesIds,search: strNewSearch, isNewStore: true, sortbycashbackpercentage: newSortByCashbackPercentage, sortbyname: newSortByName)
            dPrint("Works New Store")
          }else {
            self.isNewLoadMore = arrNewstoreLists.isEmpty ? false : true
          }
        }

      } else {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
          if (arrTrendingstoreLists.count/Global.sharedManager.intStoreAndVouchersPageLimit) == currentTrendingStorePage {
            tblStoreLists.showLoadingFooter()
            currentTrendingStorePage += 1
            viewModelStoresData.StoresLists(page: currentTrendingStorePage, regions: passTrendingRegionIds, categories: passTrendingCategoriesIds,search: strTrendingSearch, sortbycashbackpercentage: trendingSortByCashbackPercentage, sortbyname: trendingSortByName)
            dPrint("Works Trending Store")
          }else {
            self.isTrendingLoadMore = arrTrendingstoreLists.isEmpty ? false : true
          }
        }
      }
    }
  }
}


//MARK: - UITextFieldDelegate
extension StoresVC : UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (range.location == 0 && (string.rangeOfCharacter(from: .whitespaces) != nil)) {
      return false
    }
    return true
  }

}

//MARK: - API function
extension StoresVC {
  func APICall() {

    if strSelectedStore == StoresTypes.All {
      viewModelStoresData.isStoreTrending = false
      viewModelStoresData.StoresLists(page: currentAllStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, sortbycashbackpercentage: allSortByCashbackPercentage, sortbyname: allSortByName)
      isFirstTimeAll = true

    } else if strSelectedStore == StoresTypes.New {
      viewModelStoresData.isStoreTrending = false
      viewModelStoresData.StoresLists(page: currentNewStorePage, regions: passNewRegionIds, categories: passNewCategoriesIds,search: strNewSearch, isNewStore: true, sortbycashbackpercentage: newSortByCashbackPercentage, sortbyname: newSortByName)
      isFirstTimeNew = true

    } else {
      viewModelStoresData.isStoreTrending = true
      viewModelStoresData.StoresLists(page: currentTrendingStorePage, regions: passTrendingRegionIds, categories: passTrendingCategoriesIds,search: strTrendingSearch, sortbycashbackpercentage: trendingSortByCashbackPercentage, sortbyname: trendingSortByName)
      isFirstTimeTrending = true
    }
  }
}


//MARK: - SortByDelegate
extension StoresVC: SortByDelegate {
  func sortBy(sort: String, intPrevius: Int) {
    allSortByCashbackPercentage = ""
    allSortByName = ""
    newSortByCashbackPercentage = ""
    newSortByName = ""
    trendingSortByCashbackPercentage = ""
    trendingSortByName = ""

    if strSelectedStore == StoresTypes.All {
      AllStoreIndex = intPrevius
      isAllSortingApplied = true
      isAllLoadMore = false
      if (AllStoreIndex == 1) || (AllStoreIndex == 2) {
        allSortByName = ARRAY.SORTBY[AllStoreIndex].value
      } else {
        allSortByCashbackPercentage = ARRAY.SORTBY[AllStoreIndex].value
      }
      currentAllStorePage = 1
      arrAllstoreLists.removeAll()
      tblStoreLists.reloadData()
      viewModelStoresData.isStoreTrending = false
      viewModelStoresData.StoresLists(page: currentAllStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, sortbycashbackpercentage: allSortByCashbackPercentage, sortbyname: allSortByName)

    } else if strSelectedStore == StoresTypes.New {
      NewStoreIndex = intPrevius
      isNewSortingApplied = true
      isNewLoadMore = false
      if (NewStoreIndex == 1) || (NewStoreIndex == 2) {
        newSortByName = ARRAY.SORTBY[NewStoreIndex].value
      } else {
        newSortByCashbackPercentage = ARRAY.SORTBY[NewStoreIndex].value
      }

      currentNewStorePage = 1
      arrNewstoreLists.removeAll()
      tblStoreLists.reloadData()

      viewModelStoresData.isStoreTrending = false
      viewModelStoresData.StoresLists(page: currentNewStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, isNewStore: true, sortbycashbackpercentage: newSortByCashbackPercentage, sortbyname: newSortByName)
    } else {
      TrendingStoreIndex = intPrevius
      isTrendingSortingApplied = true
      isTrendingLoadMore = false
      if (TrendingStoreIndex == 1) || (TrendingStoreIndex == 2) {
        trendingSortByName = ARRAY.SORTBY[TrendingStoreIndex].value
      } else {
        trendingSortByCashbackPercentage = ARRAY.SORTBY[TrendingStoreIndex].value
      }

      currentTrendingStorePage = 1
      arrTrendingstoreLists.removeAll()
      tblStoreLists.reloadData()

      viewModelStoresData.isStoreTrending = true
      viewModelStoresData.StoresLists(page: currentTrendingStorePage, regions: passTrendingRegionIds, categories: passTrendingCategoriesIds,search: strTrendingSearch, sortbycashbackpercentage: trendingSortByCashbackPercentage, sortbyname: trendingSortByName)
    }
    checkFilterSelected()

  }
}


//MARK: - FilterByDelegate
extension StoresVC: FilterByDelegate {

  func filterByAll(categoryList: [FilterCategoriesData], regionList: [FilterRegionDataObject], isFilterApply: Bool, CategoryCount: Int, RegionCount:Int,isClearAll: Bool,categoryIds:[Int],regionIds:[Int],isCategoryApply:Bool,isRegionApply:Bool,currentPage:Int) {

    self.passAllCategoriesIds = categoryIds
    self.passAllRegionIds = regionIds

    self.arrAllStoreRegionLists = regionList
    self.arrAllStoreCategoryLists = categoryList

    self.isAllFilterApply = isFilterApply

    self.AllStoreCategoryCount = CategoryCount
    self.AllStoreRegionCount = RegionCount

    self.isAllClear = isClearAll

    self.isStoreAllCategoryApply = isCategoryApply
    self.isStoreAllRegionApply = isRegionApply

    currentAllStorePage = currentPage
    isAllLoadMore = false

    if isClearAll {
      AllStoreIndex = 0
      isAllSortingApplied = false
    }
    arrAllstoreLists.removeAll()
    lblNoDataAvailable.isHidden = true
    tblStoreLists.reloadData()

    viewModelStoresData.isStoreTrending = false
    viewModelStoresData.StoresLists(page: currentAllStorePage, regions: passAllRegionIds, categories: passAllCategoriesIds,search: strAllSearch, sortbycashbackpercentage: allSortByCashbackPercentage, sortbyname: allSortByName)

  }

  func filterByNew(categoryList: [FilterCategoriesData], regionList: [FilterRegionDataObject], isFilterApply: Bool, CategoryCount: Int, RegionCount:Int,isClearAll: Bool,NewcategoryIds categoryIds:[Int],NewregionIds regionIds:[Int],isCategoryApply:Bool,isRegionApply:Bool,currentPage:Int) {

    self.passNewCategoriesIds = categoryIds
    self.passNewRegionIds = regionIds

    self.arrNewStoreRegionLists = regionList
    self.arrNewStoreCategoryLists = categoryList

    self.isNewFilterApply = isFilterApply

    self.NewStoreCategoryCount = CategoryCount
    self.NewStoreRegionCount = RegionCount

    self.isNewClear = isClearAll

    self.isStoreNewCategoryApply = isCategoryApply
    self.isStoreNewRegionApply = isRegionApply

    currentNewStorePage = currentPage
    isNewLoadMore = false
    if isClearAll {
      NewStoreIndex = 0
      isNewSortingApplied = false
    }

    arrNewstoreLists.removeAll()
    lblNoDataAvailable.isHidden = true
    tblStoreLists.reloadData()

    viewModelStoresData.isStoreTrending = false
    viewModelStoresData.StoresLists(page: currentNewStorePage, regions: passNewRegionIds, categories: passNewCategoriesIds,search: strNewSearch, isNewStore: true, sortbycashbackpercentage: newSortByCashbackPercentage, sortbyname: newSortByName)

  }

  func filterByTrending(categoryList: [FilterCategoriesData], regionList: [FilterRegionDataObject], isFilterApply: Bool, CategoryCount: Int, RegionCount:Int,isClearAll: Bool,TrendingcategoryIds categoryIds:[Int],TrendingregionIds regionIds:[Int],isCategoryApply:Bool,isRegionApply:Bool,currentPage:Int) {

    self.passTrendingCategoriesIds = categoryIds
    self.passTrendingRegionIds = regionIds

    self.arrTrendingStoreRegionLists = regionList
    self.arrTrendingStoreCategoryLists = categoryList

    self.isTrendingFilterApply = isFilterApply

    self.TrendingStoreCategoryCount = CategoryCount
    self.TrendingStoreRegionCount = RegionCount

    self.isTrendingClear = isClearAll

    self.isStoreTrendingCategoryApply = isCategoryApply
    self.isStoreTrendingRegionApply = isRegionApply

    currentTrendingStorePage = currentPage
    isTrendingLoadMore = false
    if isClearAll {
      TrendingStoreIndex = 0
      isTrendingSortingApplied = false
    }

    arrTrendingstoreLists.removeAll()
    lblNoDataAvailable.isHidden = true
    tblStoreLists.reloadData()

    viewModelStoresData.isStoreTrending = true
    viewModelStoresData.StoresLists(page: currentTrendingStorePage, regions: passTrendingRegionIds, categories: passTrendingCategoriesIds,search: strTrendingSearch, sortbycashbackpercentage: trendingSortByCashbackPercentage, sortbyname: trendingSortByName)
  }
}

//MARK: - StoresListDelegate
extension StoresVC : StoresListDelegate{
  func StoresLists(arrstores: [storeDataListObject]) {

    tblStoreLists.hideLoadingFooter()
    checkSortingSelected()

    if strSelectedStore == StoresTypes.All {
      arrAllstoreLists.append(contentsOf: arrstores)
      dPrint("All Store Count",arrAllstoreLists.count)

      guard !arrstores.isEmpty else {
        self.isAllLoadMore = arrAllstoreLists.isEmpty ? false : true
        self.lblNoDataAvailable.isHidden = arrAllstoreLists.isEmpty ? false : true
        self.tblStoreLists.reloadData()
        return
      }

      if arrstores.count != Global.sharedManager.intStoreAndVouchersPageLimit{
        self.isAllLoadMore = arrAllstoreLists.isEmpty ? false : true
      }

      lblNoDataAvailable.isHidden = arrAllstoreLists.isEmpty ? false : true

    } else if strSelectedStore == StoresTypes.New {

      arrNewstoreLists.append(contentsOf: arrstores)
      dPrint("New Store Count",arrNewstoreLists.count)

      guard !arrstores.isEmpty else {
        self.isNewLoadMore = arrNewstoreLists.isEmpty ? false : true
        self.lblNoDataAvailable.isHidden = arrNewstoreLists.isEmpty ? false : true
        self.tblStoreLists.reloadData()
        return
      }

      if arrstores.count != Global.sharedManager.intStoreAndVouchersPageLimit{
        self.isNewLoadMore = arrNewstoreLists.isEmpty ? false : true
      }
      lblNoDataAvailable.isHidden = arrNewstoreLists.isEmpty ? false : true

    } else {
      arrTrendingstoreLists.append(contentsOf: arrstores)
      dPrint("Trending Store Count",arrTrendingstoreLists.count)

      guard !arrstores.isEmpty else {
        self.isTrendingLoadMore = arrTrendingstoreLists.isEmpty ? false : true
        self.lblNoDataAvailable.isHidden = arrTrendingstoreLists.isEmpty ? false : true
        self.tblStoreLists.reloadData()
        return
      }

      if arrstores.count != Global.sharedManager.intStoreAndVouchersPageLimit{
        self.isTrendingLoadMore = arrTrendingstoreLists.isEmpty ? false : true
      }

      lblNoDataAvailable.isHidden = arrTrendingstoreLists.isEmpty ? false : true
    }
    tblStoreLists.reloadData()
  }
}

//MARK: - StoresFailureHandleDelegate
extension StoresVC : StoresFailureHandleDelegate {
  func StoreFailureHandler(isFailure: Bool) {
    tblStoreLists.hideLoadingFooter()
    if strSelectedStore == StoresTypes.All {
      isAllLoadMore = arrAllstoreLists.isEmpty ? false : true
      self.lblNoDataAvailable.isHidden = arrAllstoreLists.isEmpty ? false : true
    } else if strSelectedStore == StoresTypes.New {
      isNewLoadMore = arrNewstoreLists.isEmpty ? false : true
      self.lblNoDataAvailable.isHidden = arrNewstoreLists.isEmpty ? false : true
    } else {
      isTrendingLoadMore = arrTrendingstoreLists.isEmpty ? false : true
      self.lblNoDataAvailable.isHidden = arrTrendingstoreLists.isEmpty ? false : true
    }
    tblStoreLists.reloadData()
  }
}

//MARK: - FavouriteStoreAddDelegate
extension StoresVC: FavouriteStoreAddDelegate {
  func favouriteStoreAddSuccess(_ isSuccess: Bool, intIndex: Int) {
    if strSelectedStore == StoresTypes.All {
      arrAllstoreLists[intIndex].isFavourite = 1
    } else if strSelectedStore == StoresTypes.New {
      arrNewstoreLists[intIndex].isFavourite = 1
    } else {
      arrTrendingstoreLists[intIndex].isFavourite = 1
    }
    tblStoreLists.reloadRows(at: [IndexPath(row: intIndex, section: 0)], with: .automatic)
  }
}

//MARK: - FavouriteStoreRemoveDelegate
extension StoresVC: FavouriteStoreRemoveDelegate {
  func favouriteStoreRemoveSuccess(_ isSuccess: Bool, intIndex: Int) {
    if strSelectedStore == StoresTypes.All {
      arrAllstoreLists[intIndex].isFavourite = 0
    } else if strSelectedStore == StoresTypes.New {
      arrNewstoreLists[intIndex].isFavourite = 0
    } else {
      arrTrendingstoreLists[intIndex].isFavourite = 0
    }
    tblStoreLists.reloadRows(at: [IndexPath(row: intIndex, section: 0)], with: .automatic)
  }

}
