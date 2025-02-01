//
//  FilterVC.swift
//  Iceback
//
//  Created by APPLE on 16/01/24.
//

import UIKit

class FilterVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var tblFilterBy: UITableView!
  @IBOutlet weak var tblFilterLists: UITableView!
  @IBOutlet weak var imgAll: UIImageView!
  @IBOutlet weak var viewAll: UIView!
  @IBOutlet weak var viewAllHeight: NSLayoutConstraint!
  @IBOutlet weak var lblFilterTitle: UILabel!
  @IBOutlet weak var btnClearAll: UIButton!
  @IBOutlet weak var btnCancel: UIButton!
  @IBOutlet weak var btnApply: UIButton!

  //MARK: - Constant & Variables

  var arrFilterBy = [FilterListModel]()

  var isFromStores = false
  var StoreType = ""
  var DealsType = ""
  var filterByDelegate: FilterByDelegate!
  var isCategorySelected = true
  var UpdateIndex = 0
  var isCategoryAllSelected = true
  var isRegionAllSelected = true
  var AllStoreCategoryCount = 0
  var AllStoreRegionCount = 0
  var NewStoreCategoryCount = 0
  var NewStoreRegionCount = 0

  var TrendingStoreCategoryCount = 0
  var TrendingStoreRegionCount = 0

  var NewDealsCategoryCount = 0
  var NewDealsRegionCount = 0

  var TrendingDealsCategoryCount = 0
  var TrendingDealsRegionCount = 0

  var arrRegionLists = [FilterRegionDataObject]()
  var arrCategoryLists: [FilterCategoriesData] = []

  private var viewModelFilter = FilterViewModel()


  var isStoreAllCategoryApply = false
  var isStoreNewCategoryApply = false
  var isStoreTrendingCategoryApply = false
  var isStoreAllRegionApply = false
  var isStoreNewRegionApply = false
  var isStoreTrendingRegionApply = false

  var isDealNewCategoryApply = false
  var isDealTrendingCategoryApply = false
  var isDealNewRegionApply = false
  var isDealTrendingRegionApply = false

  var isRegionApply = false
  var arrAllStoreRegionIds = [Int]()
  var arrAllStoreCategoriesIds = [Int]()

  var arrNewStoreRegionIds = [Int]()
  var arrNewStoreCategoriesIds = [Int]()

  var arrTrendingStoreRegionIds = [Int]()
  var arrTrendingStoreCategoriesIds = [Int]()

  var arrNewDealsRegionIds = [Int]()
  var arrNewDealsCategoriesIds = [Int]()

  var arrTrendingDealsRegionIds = [Int]()
  var arrTrendingDealsCategoriesIds = [Int]()

  var isFromTrending = false

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpController()
    xibRegister()
    tblFilterLists.rowHeight = UITableView.automaticDimension
    tblFilterLists.estimatedRowHeight = 60
     initializeSetUp()
  }

  //MARK: - XIB Register
  func xibRegister(){
    tblFilterBy.delegate = self
    tblFilterBy.dataSource = self
    tblFilterLists.delegate = self
    tblFilterLists.dataSource = self
    tblFilterBy.registerCell(ofType: FilterByTableViewCell.self)
    tblFilterLists.registerCell(ofType: FilterListsTableViewCell.self)

  }

  //MARK: - Setup Controller
  func setUpController() {

    arrFilterBy =   [(FilterListModel(id: 1, Name: "Category".localized() , isSelected: true, count: 0)),(FilterListModel(id: 2, Name: "Region" , isSelected: false, count: 0))]

    lblFilterTitle.text = lblFilterTitle.text?.localized()
    btnClearAll.setTitle(BUTTONTITLE.CLEARALL.localized(), for: .normal)
    btnApply.setTitle(BUTTONTITLE.APPLY.localized(), for: .normal)
    btnCancel.setTitle(BUTTONTITLE.CANCEL.localized(), for: .normal)

    if isFromStores {
      if StoreType == StoresTypes.All && !isStoreAllCategoryApply {
        CategoryAPICall()
      } else if StoreType == StoresTypes.New && !isStoreNewCategoryApply {
        CategoryAPICall()
      } else if StoreType == StoresTypes.Trending && !isStoreTrendingCategoryApply {
        CategoryAPICall()
      }
    } else {
      if DealsType == DealsTypes.New && !isDealNewCategoryApply{
        CategoryAPICall()
      }  else  if DealsType == DealsTypes.Trending && !isDealTrendingCategoryApply {
        CategoryAPICall()
      }
    }
  }

   func initializeSetUp() {
      lblFilterTitle.textColor = AppThemeManager.shared.labelColor
      btnClearAll.setTitleColor(AppThemeManager.shared.labelColor, for: .normal)
      btnCancel.setTitleColor(AppThemeManager.shared.tertiaryColor, for: .normal)
      btnApply.setTitleColor(AppThemeManager.shared.labelColor, for: .normal)
   }
}

//MARK: - Button Action
extension FilterVC {
  @IBAction func btnClearAllClk(_ sender: UIButton) {

    isCategoryAllSelected = true
    isRegionAllSelected = true

    // isCategoryApply = false
    isRegionApply = false

    if isFromStores {
      if StoreType == StoresTypes.All {
        AllStoreCategoryCount = 0
        AllStoreRegionCount = 0
        isStoreAllCategoryApply = false
        isStoreAllRegionApply = false

      } else if StoreType ==  StoresTypes.New {
        NewStoreCategoryCount = 0
        NewStoreRegionCount = 0
        isStoreNewCategoryApply = false
        isStoreNewRegionApply = false

      } else if StoreType ==  StoresTypes.Trending {
        TrendingStoreCategoryCount = 0
        TrendingStoreRegionCount = 0
        isStoreTrendingCategoryApply = false
        isStoreTrendingRegionApply = false
      }
    }

    imgAll.image = IMAGES.ICN_FILTER_SELECTED

    for i in 0 ..< arrCategoryLists.count {
      arrCategoryLists[i].isSelected = false
    }

    for i in 0 ..< arrRegionLists.count {
      arrRegionLists[i].isSelected = false
    }

    if isFromStores {
      if StoreType == StoresTypes.All {
        arrAllStoreCategoriesIds.removeAll()
        arrAllStoreRegionIds.removeAll()
        //   currentAllStorePage = 1
        filterByDelegate.filterByAll(categoryList: arrCategoryLists, regionList: arrRegionLists, isFilterApply: true, CategoryCount: AllStoreCategoryCount, RegionCount: AllStoreRegionCount,isClearAll: true,categoryIds: arrAllStoreCategoriesIds,regionIds: arrAllStoreRegionIds,isCategoryApply: false,isRegionApply: false,currentPage: 1)

      } else if StoreType == StoresTypes.New {
        arrNewStoreCategoriesIds.removeAll()
        arrNewStoreRegionIds.removeAll()
        filterByDelegate.filterByNew(categoryList: arrCategoryLists, regionList: arrRegionLists, isFilterApply: true, CategoryCount: NewStoreCategoryCount, RegionCount: NewStoreRegionCount,isClearAll: true,NewcategoryIds: arrNewStoreCategoriesIds,NewregionIds: arrNewStoreRegionIds,isCategoryApply: false,isRegionApply: false,currentPage: 1)

      } else if StoreType == StoresTypes.Trending {
        arrTrendingStoreCategoriesIds.removeAll()
        arrTrendingStoreRegionIds.removeAll()
        filterByDelegate.filterByTrending(categoryList: arrCategoryLists, regionList: arrRegionLists, isFilterApply: true, CategoryCount: TrendingStoreCategoryCount, RegionCount: TrendingStoreRegionCount,isClearAll: true,TrendingcategoryIds: arrTrendingStoreCategoriesIds,TrendingregionIds: arrTrendingStoreRegionIds,isCategoryApply: false,isRegionApply: false,currentPage: 1)
      }
    }

    self.tblFilterBy.reloadData()
    self.tblFilterLists.reloadData()
  }


  @IBAction func btnCancelClk(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func btnApplyClk(_ sender: UIButton) {

    if isFromStores {
      if StoreType == StoresTypes.All {

        if AllStoreCategoryCount == 0 && AllStoreRegionCount == 0  {
          alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.INVALIDFILTER.localized())
        } else {
          filterByDelegate.filterByAll(categoryList: arrCategoryLists, regionList: arrRegionLists, isFilterApply: true, CategoryCount: AllStoreCategoryCount, RegionCount: AllStoreRegionCount, isClearAll: false,categoryIds: arrAllStoreCategoriesIds,regionIds: arrAllStoreRegionIds,isCategoryApply: isStoreAllCategoryApply,isRegionApply: isStoreAllRegionApply,currentPage: 1)
        }

      } else if StoreType == StoresTypes.New {
        if NewStoreCategoryCount == 0 && NewStoreRegionCount == 0  {
          alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.INVALIDFILTER.localized())
        } else {
          filterByDelegate.filterByNew(categoryList: arrCategoryLists, regionList: arrRegionLists, isFilterApply: true, CategoryCount: NewStoreCategoryCount, RegionCount: NewStoreRegionCount, isClearAll: false,NewcategoryIds: arrNewStoreCategoriesIds,NewregionIds: arrNewStoreRegionIds,isCategoryApply: isStoreNewCategoryApply,isRegionApply: isStoreNewRegionApply,currentPage: 1)
        }
      } else if StoreType == StoresTypes.Trending {
        if TrendingStoreCategoryCount == 0 && TrendingStoreRegionCount == 0  {
          alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.INVALIDFILTER.localized())
        } else {

          filterByDelegate.filterByTrending(categoryList: arrCategoryLists, regionList: arrRegionLists, isFilterApply: true, CategoryCount: TrendingStoreCategoryCount, RegionCount: TrendingStoreRegionCount, isClearAll: false,TrendingcategoryIds: arrTrendingStoreCategoriesIds,TrendingregionIds: arrTrendingStoreRegionIds,isCategoryApply: isStoreTrendingCategoryApply,isRegionApply: isStoreTrendingRegionApply,currentPage: 1)
        }
      }
    }
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func btnAllClk(_ sender: UIButton) {

    if isCategorySelected {
      if isCategoryAllSelected {
        isCategoryAllSelected = false

        for i in 0 ..< arrCategoryLists.count {
          arrCategoryLists[i].isSelected = true
        }

        self.imgAll.image = IMAGES.ICN_FILTER_SELECTED

        if isFromStores {
          if StoreType == StoresTypes.All {
            AllStoreCategoryCount = arrCategoryLists.count

            for i in 0 ..< arrCategoryLists.count {
              if !arrAllStoreCategoriesIds.contains(arrCategoryLists[i].categoryId) {
                arrAllStoreCategoriesIds.append(arrCategoryLists[i].categoryId)
              }
            }

          } else if StoreType == StoresTypes.New {
            NewStoreCategoryCount = arrCategoryLists.count

            for i in 0 ..< arrCategoryLists.count {
              if !arrNewStoreCategoriesIds.contains(arrCategoryLists[i].categoryId) {
                arrNewStoreCategoriesIds.append(arrCategoryLists[i].categoryId)
              }
            }

          } else {
            TrendingStoreCategoryCount = arrCategoryLists.count

            for i in 0 ..< arrCategoryLists.count {
              if !arrTrendingStoreCategoriesIds.contains(arrCategoryLists[i].categoryId) {
                arrTrendingStoreCategoriesIds.append(arrCategoryLists[i].categoryId)
              }
            }
          }
        } else {
          if DealsType == DealsTypes.New {
            NewDealsCategoryCount = arrCategoryLists.count
          } else  {
            TrendingDealsCategoryCount = arrCategoryLists.count
          }
        }

      } else {

        isCategoryAllSelected = true

        for i in 0 ..< arrCategoryLists.count {
          arrCategoryLists[i].isSelected = false
        }
        self.imgAll.image = IMAGES.ICN_FILTER_UNSELECTED

        if isFromStores {
          if StoreType == StoresTypes.All {
            AllStoreCategoryCount = 0
            arrAllStoreCategoriesIds.removeAll()

          } else if StoreType == StoresTypes.New {
            NewStoreCategoryCount = 0
            arrNewStoreCategoriesIds.removeAll()
          } else {
            TrendingStoreCategoryCount = 0
            arrTrendingStoreCategoriesIds.removeAll()
          }
        } else {
          if DealsType == DealsTypes.New {
            NewDealsCategoryCount = 0
          } else  {
            TrendingDealsCategoryCount = 0
          }
        }
      }
    } else {
      if isRegionAllSelected {
        isRegionAllSelected = false
        for i in 0 ..< arrRegionLists.count {
          arrRegionLists[i].isSelected = true
        }
        self.imgAll.image = IMAGES.ICN_FILTER_SELECTED

        if isFromStores {
          if StoreType == StoresTypes.All {
            AllStoreRegionCount = arrRegionLists.count
            for i in 0 ..< arrRegionLists.count {
              if !arrAllStoreRegionIds.contains(arrRegionLists[i].RegionId) {
                arrAllStoreRegionIds.append(arrRegionLists[i].RegionId)
              }
            }

          } else if StoreType == StoresTypes.New {
            NewStoreRegionCount = arrRegionLists.count
            for i in 0 ..< arrRegionLists.count {
              if !arrNewStoreRegionIds.contains(arrRegionLists[i].RegionId) {
                arrNewStoreRegionIds.append(arrRegionLists[i].RegionId)
              }
            }
          } else {
            TrendingStoreRegionCount = arrRegionLists.count
            for i in 0 ..< arrRegionLists.count {
              if !arrTrendingStoreRegionIds.contains(arrRegionLists[i].RegionId) {
                arrTrendingStoreRegionIds.append(arrRegionLists[i].RegionId)
              }
            }
          }
        } else {
          if DealsType == DealsTypes.New {
            NewDealsRegionCount = arrRegionLists.count
          } else  {
            TrendingDealsRegionCount = arrRegionLists.count
          }
        }

      } else {

        isRegionAllSelected = true

        for i in 0 ..< arrRegionLists.count {
          arrRegionLists[i].isSelected = false
        }
        self.imgAll.image = IMAGES.ICN_FILTER_UNSELECTED

        if isFromStores {
          if StoreType == StoresTypes.All {
            AllStoreRegionCount = 0
            arrAllStoreRegionIds.removeAll()
          } else if StoreType == StoresTypes.New {
            NewStoreRegionCount = 0
            arrNewStoreRegionIds.removeAll()
          } else {
            TrendingStoreRegionCount = 0
            arrTrendingStoreRegionIds.removeAll()
          }
        } else {
          if DealsType == DealsTypes.New {
            NewDealsRegionCount = 0
          } else  {
            TrendingDealsRegionCount = 0
          }
        }
      }
    }
    self.tblFilterBy.reloadData()
    self.tblFilterLists.reloadData()
  }
}

//MARK: - UITableViewDataSource
extension FilterVC : UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.tblFilterBy {
      return arrFilterBy.count
    } else {
      if isCategorySelected {
        return arrCategoryLists.count
      } else {
        return arrRegionLists.count
      }
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == self.tblFilterBy {
      let FilterByCell = tableView.dequeueCell(ofType: FilterByTableViewCell.self)
      FilterByCell.selectionStyle = .none
      FilterByCell.lblName.text = arrFilterBy[indexPath.row].Name
      FilterByCell.bgView.backgroundColor = .appEFF8FF

      if indexPath.row == (arrFilterBy.count - 1) {
        FilterByCell.bottomView.isHidden = true
      } else {
        FilterByCell.bottomView.isHidden = false
      }

      if isCategorySelected {
        UpdateIndex = 0

        FilterByCell.viewTop.isHidden = true

        if indexPath.row == 0 {

          if isFromStores {
            if StoreType == StoresTypes.All {
              FilterByCell.lblCategoryCount.isHidden = AllStoreCategoryCount == 0 ? true : false

              FilterByCell.lblCategoryCount.text = AllStoreCategoryCount<10 ? String(format: "%02d", AllStoreCategoryCount) : String(AllStoreCategoryCount)
            } else if StoreType == StoresTypes.New {
              FilterByCell.lblCategoryCount.isHidden = NewStoreCategoryCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = NewStoreCategoryCount<10 ? String(format: "%02d", NewStoreCategoryCount) : String(NewStoreCategoryCount)
            } else {
              FilterByCell.lblCategoryCount.isHidden = TrendingStoreCategoryCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = TrendingStoreCategoryCount<10 ? String(format: "%02d", TrendingStoreCategoryCount) : String(TrendingStoreCategoryCount)
            }
          } else {
            if DealsType == DealsTypes.New {
              FilterByCell.lblCategoryCount.isHidden = NewDealsCategoryCount == 0 ? true : false

              FilterByCell.lblCategoryCount.text = NewDealsCategoryCount<10 ? String(format: "%02d", NewDealsCategoryCount) : String(NewDealsCategoryCount)
            } else  {
              FilterByCell.lblCategoryCount.isHidden = TrendingDealsCategoryCount == 0 ? true : false

              FilterByCell.lblCategoryCount.text = TrendingDealsCategoryCount<10 ? String(format: "%02d", TrendingDealsCategoryCount) : String(TrendingDealsCategoryCount)
            }
          }

        } else {

          if isFromStores {
            if StoreType == StoresTypes.All {

              if AllStoreRegionCount != 0 {
                FilterByCell.lblCategoryCount.text = AllStoreRegionCount<10 ? String(format: "%02d", AllStoreRegionCount) : String(AllStoreRegionCount)
              } else {
                FilterByCell.lblCategoryCount.text = ""
              }

            } else if StoreType == StoresTypes.New {
              if NewStoreRegionCount != 0 {
                FilterByCell.lblCategoryCount.text = NewStoreRegionCount<10 ? String(format: "%02d", NewStoreRegionCount) : String(NewStoreRegionCount)
              } else {
                FilterByCell.lblCategoryCount.text = ""
              }
            } else {
              if TrendingStoreRegionCount != 0 {
                FilterByCell.lblCategoryCount.text = TrendingStoreRegionCount<10 ? String(format: "%02d", TrendingStoreRegionCount) : String(TrendingStoreRegionCount)
              } else {
                FilterByCell.lblCategoryCount.text = ""
              }
            }
          } else {
            if DealsType == DealsTypes.New {

              if NewDealsRegionCount != 0 {
                FilterByCell.lblCategoryCount.text = NewDealsRegionCount<10 ? String(format: "%02d", NewDealsRegionCount) : String(NewDealsRegionCount)
              } else {
                FilterByCell.lblCategoryCount.text = ""
              }
            } else {
              if TrendingDealsRegionCount != 0 {
                FilterByCell.lblCategoryCount.text = TrendingDealsRegionCount<10 ? String(format: "%02d", TrendingDealsRegionCount) : String(TrendingDealsRegionCount)
              } else {
                FilterByCell.lblCategoryCount.text = ""
              }
            }
          }
        }
      } else {
        UpdateIndex = 1

        if indexPath.row == 1 {

          if isFromStores {
            if StoreType == StoresTypes.All {

              FilterByCell.lblCategoryCount.isHidden = AllStoreRegionCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = AllStoreRegionCount<10 ? String(format: "%02d", AllStoreRegionCount) : String(AllStoreRegionCount)

            } else if StoreType == StoresTypes.New {

              FilterByCell.lblCategoryCount.isHidden = NewStoreRegionCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = NewStoreRegionCount<10 ? String(format: "%02d", NewStoreRegionCount) : String(NewStoreRegionCount)
            } else {
              FilterByCell.lblCategoryCount.isHidden = TrendingStoreRegionCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = TrendingStoreRegionCount<10 ? String(format: "%02d", TrendingStoreRegionCount) : String(TrendingStoreRegionCount)
            }
          } else {
            if DealsType == DealsTypes.New {

              FilterByCell.lblCategoryCount.isHidden = NewDealsRegionCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = NewDealsRegionCount<10 ? String(format: "%02d", NewDealsRegionCount) : String(NewDealsRegionCount)

            } else  {
              FilterByCell.lblCategoryCount.isHidden = TrendingDealsRegionCount == 0 ? true : false
              FilterByCell.lblCategoryCount.text = TrendingDealsRegionCount<10 ? String(format: "%02d", TrendingDealsRegionCount) : String(TrendingDealsRegionCount)
            }
          }

        } else {

          if isFromStores {
            if StoreType == StoresTypes.All {

              if AllStoreCategoryCount != 0 {
                FilterByCell.lblCategoryCount.text =  AllStoreCategoryCount<10 ? String(format: "%02d", AllStoreCategoryCount) : String(AllStoreCategoryCount)
              } else {
                FilterByCell.lblCategoryCount.text =  ""
              }

            } else if StoreType == StoresTypes.New {
              if NewStoreCategoryCount != 0 {
                FilterByCell.lblCategoryCount.text =  NewStoreCategoryCount<10 ? String(format: "%02d", NewStoreCategoryCount) : String(NewStoreCategoryCount)
              } else {
                FilterByCell.lblCategoryCount.text =  ""
              }

            } else {
              if TrendingStoreCategoryCount != 0 {
                FilterByCell.lblCategoryCount.text =  TrendingStoreCategoryCount<10 ? String(format: "%02d", TrendingStoreCategoryCount) : String(TrendingStoreCategoryCount)
              } else {
                FilterByCell.lblCategoryCount.text =  ""
              }
            }
          } else {
            if DealsType == DealsTypes.New {
              if NewDealsCategoryCount != 0 {
                FilterByCell.lblCategoryCount.text =  NewDealsCategoryCount<10 ? String(format: "%02d", NewDealsCategoryCount) : String(NewDealsCategoryCount)
              } else {
                FilterByCell.lblCategoryCount.text =  ""
              }
            } else  {
              if TrendingDealsCategoryCount != 0 {
                FilterByCell.lblCategoryCount.text =  TrendingDealsCategoryCount<10 ? String(format: "%02d", TrendingDealsCategoryCount) : String(TrendingDealsCategoryCount)
              } else {
                FilterByCell.lblCategoryCount.text =  ""
              }
            }
          }
        }

        FilterByCell.viewTop.isHidden = false
      }

      if UpdateIndex == indexPath.row {
        FilterByCell.lblName.font = AFont(size: 14, type: .Heavy)
         FilterByCell.lblName.textColor = AppThemeManager.shared.labelColor
         FilterByCell.bgView.backgroundColor = AppThemeManager.shared.backgroundColor
        FilterByCell.bottomView.isHidden = false

      } else {
        FilterByCell.lblName.font =  AFont(size: 14, type: .Roman)
        FilterByCell.lblName.textColor = .app00000060
        FilterByCell.bgView.backgroundColor = .appEFF8FF
      }

      return FilterByCell

    } else {
      let FilterListCell = tableView.dequeueCell(ofType: FilterListsTableViewCell.self)

      if isCategorySelected == true {

        FilterListCell.lblFilterName.text = arrCategoryLists[indexPath.row].categoryName

        if isFromStores {
          if StoreType == StoresTypes.All {
            FilterListCell.imgSelect.image = arrAllStoreCategoriesIds.contains(arrCategoryLists[indexPath.row].categoryId) ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
          } else if StoreType == StoresTypes.New {
            FilterListCell.imgSelect.image = arrNewStoreCategoriesIds.contains(arrCategoryLists[indexPath.row].categoryId) ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
          } else {
            FilterListCell.imgSelect.image = arrTrendingStoreCategoriesIds.contains(arrCategoryLists[indexPath.row].categoryId) ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
          }
        }

        for i in 0 ..< arrCategoryLists.count {
          if arrCategoryLists[i].isSelected == false {
            imgAll.image = IMAGES.ICN_FILTER_UNSELECTED
            isCategoryAllSelected = true

            break
          } else {
            imgAll.image = IMAGES.ICN_FILTER_SELECTED
            isCategoryAllSelected = false
          }
        }

      } else {

        FilterListCell.lblFilterName.text =  UserDefaultHelper.selectedLanguage == Language.Code.German ? arrRegionLists[indexPath.row].RegionNameData.de : arrRegionLists[indexPath.row].RegionNameData.en

        if isFromStores {
          if StoreType == StoresTypes.All {
            FilterListCell.imgSelect.image = arrAllStoreRegionIds.contains(arrRegionLists[indexPath.row].RegionId) ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
          } else if StoreType == StoresTypes.New {
            FilterListCell.imgSelect.image = arrNewStoreRegionIds.contains(arrRegionLists[indexPath.row].RegionId) ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
          } else {
            FilterListCell.imgSelect.image = arrTrendingStoreRegionIds.contains(arrRegionLists[indexPath.row].RegionId) ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
          }
        }

        for i in 0 ..< arrRegionLists.count {
          if arrRegionLists[i].isSelected == false {
            imgAll.image = IMAGES.ICN_FILTER_UNSELECTED
            isRegionAllSelected = true

            break
          } else {
            imgAll.image = IMAGES.ICN_FILTER_SELECTED
            isRegionAllSelected = false
          }
        }
      }
      return FilterListCell
    }
  }
}

//MARK: - UITableViewDelegate
extension FilterVC: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == self.tblFilterBy {

      if indexPath.row == 0 {
        isCategorySelected = true

        if !isCategoryAllSelected {
          self.imgAll.image = IMAGES.ICN_FILTER_SELECTED
        } else {
          self.imgAll.image = IMAGES.ICN_FILTER_UNSELECTED
        }

        if isFromStores {
          if StoreType == StoresTypes.All {
            if !isStoreAllCategoryApply {
              CategoryAPICall()
            }
          } else if StoreType == StoresTypes.New {
            if !isStoreNewCategoryApply {
              CategoryAPICall()
            }
          } else if StoreType == StoresTypes.Trending{
            if !isStoreTrendingCategoryApply {
              CategoryAPICall()
            }
          }
        } else {
          if DealsType == DealsTypes.New {
            if !isDealNewCategoryApply {
              CategoryAPICall()
            }
          } else {
            if !isDealTrendingCategoryApply {
              CategoryAPICall()
            }
          }
        }
      } else {
        isCategorySelected = false

        if !isRegionAllSelected {
          self.imgAll.image = IMAGES.ICN_FILTER_SELECTED
        } else {
          self.imgAll.image = IMAGES.ICN_FILTER_UNSELECTED
        }

        if isFromStores {
          if StoreType == "All" {
            if !isStoreAllRegionApply {
              RegionAPICall()
            }
          } else if StoreType == "New" {
            if !isStoreNewRegionApply {
              RegionAPICall()
            }
          } else if StoreType == "Trending"{
            if !isStoreTrendingRegionApply {
              RegionAPICall()
            }
          }
        } else {
          if DealsType == "New" {
            if !isDealNewRegionApply {
              RegionAPICall()
            }
          } else {
            if !isDealTrendingRegionApply {
              RegionAPICall()
            }
          }
        }
      }

    } else {
      if isCategorySelected == true {
        if arrCategoryLists[indexPath.row].isSelected == true {
          arrCategoryLists[indexPath.row].isSelected = false
          if isFromStores {

            if StoreType == StoresTypes.All {
              if arrCategoryLists[indexPath.row].categoryName == "All" {
                arrAllStoreCategoriesIds.removeAll()
                AllStoreCategoryCount = 0
              }
              else {
                let removeindex = arrAllStoreCategoriesIds.firstIndex(of: arrCategoryLists[indexPath.row].categoryId)
                arrAllStoreCategoriesIds.remove(at: removeindex!)
                AllStoreCategoryCount -= 1
              }

            } else if StoreType == StoresTypes.New {
              if arrCategoryLists[indexPath.row].categoryName == "All" {
                arrNewStoreCategoriesIds.removeAll()
                NewStoreCategoryCount = 0
              } else {
                let removeindex = arrNewStoreCategoriesIds.firstIndex(of: arrCategoryLists[indexPath.row].categoryId)
                arrNewStoreCategoriesIds.remove(at: removeindex!)
                NewStoreCategoryCount -= 1
              }

            } else {
              if arrCategoryLists[indexPath.row].categoryName == "All" {
                arrTrendingStoreCategoriesIds.removeAll()
                TrendingStoreCategoryCount = 0
              } else {
                let removeindex = arrTrendingStoreCategoriesIds.firstIndex(of: arrCategoryLists[indexPath.row].categoryId)
                arrTrendingStoreCategoriesIds.remove(at: removeindex!)
                TrendingStoreCategoryCount -= 1
              }
            }
          }

        } else {
          arrCategoryLists[indexPath.row].isSelected = true

          if isFromStores {
            if StoreType == StoresTypes.All {

              if arrCategoryLists[indexPath.row].categoryName == "All" {
                AllStoreCategoryCount = arrCategoryLists.count

                for i in 0 ..< arrCategoryLists.count {
                  if !arrAllStoreCategoriesIds.contains(arrCategoryLists[i].categoryId) {
                    arrAllStoreCategoriesIds.append(arrCategoryLists[i].categoryId)
                  }
                }
              } else {
                if !arrAllStoreCategoriesIds.contains(arrCategoryLists[indexPath.row].categoryId) {
                  arrAllStoreCategoriesIds.append(arrCategoryLists[indexPath.row].categoryId)
                  AllStoreCategoryCount += 1
                }
              }

            } else if StoreType == StoresTypes.New {
              if arrCategoryLists[indexPath.row].categoryName == "All" {
                NewStoreCategoryCount = arrCategoryLists.count

                for i in 0 ..< arrCategoryLists.count {
                  if !arrNewStoreCategoriesIds.contains(arrCategoryLists[i].categoryId) {
                    arrNewStoreCategoriesIds.append(arrCategoryLists[i].categoryId)
                  }
                }
              } else {
                if !arrNewStoreCategoriesIds.contains(arrCategoryLists[indexPath.row].categoryId) {
                  arrNewStoreCategoriesIds.append(arrCategoryLists[indexPath.row].categoryId)
                  NewStoreCategoryCount += 1
                }
              }
            } else {
              if arrCategoryLists[indexPath.row].categoryName == "All" {
                TrendingStoreCategoryCount = arrCategoryLists.count

                for i in 0 ..< arrCategoryLists.count {
                  if !arrTrendingStoreCategoriesIds.contains(arrCategoryLists[i].categoryId) {
                    arrTrendingStoreCategoriesIds.append(arrCategoryLists[i].categoryId)
                  }
                }
              } else {
                if !arrTrendingStoreCategoriesIds.contains(arrCategoryLists[indexPath.row].categoryId) {
                  arrTrendingStoreCategoriesIds.append(arrCategoryLists[indexPath.row].categoryId)
                  TrendingStoreCategoryCount += 1
                }
              }
            }
          }
        }

      } else {
        if arrRegionLists[indexPath.row].isSelected == true {
          arrRegionLists[indexPath.row].isSelected = false


          if isFromStores {
            if StoreType == StoresTypes.All {
              if arrRegionLists[indexPath.row].RegionNameData.en == "All" {
                AllStoreRegionCount = 0
                arrAllStoreRegionIds.removeAll()
              } else {
                let removeindex = arrAllStoreRegionIds.firstIndex(of: arrRegionLists[indexPath.row].RegionId)
                arrAllStoreRegionIds.remove(at: removeindex!)
                AllStoreRegionCount -= 1
              }

            } else if StoreType == StoresTypes.New {
              if arrRegionLists[indexPath.row].RegionNameData.en == "All" {
                NewStoreRegionCount = 0
                arrNewStoreRegionIds.removeAll()
              } else {
                let removeindex = arrNewStoreRegionIds.firstIndex(of: arrRegionLists[indexPath.row].RegionId)
                arrNewStoreRegionIds.remove(at: removeindex!)
                NewStoreRegionCount -= 1
              }

            } else {
              if arrRegionLists[indexPath.row].RegionNameData.en == "All" {
                TrendingStoreRegionCount = 0
                arrTrendingStoreRegionIds.removeAll()
              } else {
                let removeindex = arrTrendingStoreRegionIds.firstIndex(of: arrRegionLists[indexPath.row].RegionId)
                arrTrendingStoreRegionIds.remove(at: removeindex!)
                TrendingStoreRegionCount -= 1
              }
            }
          }
        } else {
          arrRegionLists[indexPath.row].isSelected = true

          if isFromStores {
            if StoreType == StoresTypes.All {
              if arrRegionLists[indexPath.row].RegionNameData.en == "All" {
                AllStoreRegionCount = arrRegionLists.count

                for i in 0 ..< arrRegionLists.count {
                  if !arrAllStoreRegionIds.contains(arrRegionLists[i].RegionId) {
                    arrAllStoreRegionIds.append(arrRegionLists[i].RegionId)
                  }
                }
              } else {

                if !arrAllStoreRegionIds.contains(arrRegionLists[indexPath.row].RegionId) {
                  arrAllStoreRegionIds.append(arrRegionLists[indexPath.row].RegionId)
                  AllStoreRegionCount += 1
                }
              }
            } else if StoreType == StoresTypes.New {
              if arrRegionLists[indexPath.row].RegionNameData.en == "All" {
                NewStoreRegionCount = arrRegionLists.count

                for i in 0 ..< arrRegionLists.count {
                  if !arrNewStoreRegionIds.contains(arrRegionLists[i].RegionId) {
                    arrNewStoreRegionIds.append(arrRegionLists[i].RegionId)
                  }
                }
              } else {

                if !arrNewStoreRegionIds.contains(arrRegionLists[indexPath.row].RegionId) {
                  arrNewStoreRegionIds.append(arrRegionLists[indexPath.row].RegionId)
                  NewStoreRegionCount += 1
                }
              }
            } else {
              if arrRegionLists[indexPath.row].RegionNameData.en == "All" {
                TrendingStoreRegionCount = arrRegionLists.count

                for i in 0 ..< arrRegionLists.count {
                  if !arrTrendingStoreRegionIds.contains(arrRegionLists[i].RegionId) {
                    arrTrendingStoreRegionIds.append(arrRegionLists[i].RegionId)
                  }
                }
              } else {
                if !arrTrendingStoreRegionIds.contains(arrRegionLists[indexPath.row].RegionId) {
                  arrTrendingStoreRegionIds.append(arrRegionLists[indexPath.row].RegionId)
                  TrendingStoreRegionCount += 1
                }
              }
            }

          }
        }
      }
    }

    tblFilterBy.reloadData()
    tblFilterLists.reloadData()
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    return UITableView.automaticDimension

  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView == self.tblFilterBy {
      return 50
    } else {
      return UITableView.automaticDimension
    }

  }
}

extension FilterVC {

  //MARK: - RegionAPICAll
  func RegionAPICall() {
    viewModelFilter.FilterRegionDelegate = self
    viewModelFilter.getFilterRegionLists()


    if isFromStores {
      if StoreType == StoresTypes.All {
        isStoreAllRegionApply = true
      } else  if StoreType == StoresTypes.New {
        isStoreNewRegionApply = true
      } else if StoreType == StoresTypes.Trending {
        isStoreTrendingRegionApply = true
      }
    } else {
      if DealsType == DealsTypes.New {
        isDealNewRegionApply = true
      } else if DealsType == DealsTypes.Trending {
        isDealTrendingRegionApply = true
      }
    }

  }

  //MARK: - CategoryAPICAll
  func CategoryAPICall() {
    viewModelFilter.FilterCategoryDelegate = self
    viewModelFilter.getFilterCategoryLists()

    if isFromStores {
      if StoreType == StoresTypes.All {
        isStoreAllCategoryApply = true
      } else  if StoreType == StoresTypes.New {
        isStoreNewCategoryApply = true
      } else if StoreType == StoresTypes.Trending {
        isStoreTrendingCategoryApply = true
      }
    } else {
      if DealsType == DealsTypes.New {
        isDealNewCategoryApply = true
      } else if DealsType == DealsTypes.Trending  {
        isDealTrendingCategoryApply = true
      }
    }
  }
}

extension FilterVC : FilterRegionDelegate {
  func getFilterRegionLists(arrFilterRegion: [FilterRegionDataObject]) {
    self.arrRegionLists = arrFilterRegion
    tblFilterLists.reloadData()
  }
}

extension FilterVC : FilterCategoryDelegate {

  func getFilterCategoryLists(arrCaetgoryRegion: [FilterCategoriesData]) {
    self.arrCategoryLists = arrCaetgoryRegion
    tblFilterLists.reloadData()
  }
}
