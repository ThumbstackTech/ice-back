//
//  DealsAndVouchersFilterVC.swift
//  Iceback
//
//  Created by Admin on 25/01/24.
//

import UIKit

class DealsAndVouchersFilterVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnSearchClear: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var constTblFilterListsTop: NSLayoutConstraint!
    @IBOutlet weak var tblFilterBy: UITableView!
    @IBOutlet weak var tblFilterLists: UITableView!
    @IBOutlet weak var lblFilterTitle: UILabel!
    @IBOutlet weak var btnClearAll: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    
    //MARK: - Constant & Variables
    var arrFilterBy : [FilterListModel] = [(FilterListModel(id: 1, Name: "Category".localized(), isSelected: true, count: 0)),(FilterListModel(id: 2, Name: "Shop".localized().localized(), isSelected: false, count: 0))]
    var arrFilterCategoryList: [FilterCategoriesData] = []
    var arrFilterStoreLists : [AllStoreData] = []
    var arrTempFilterStoreList : [AllStoreData] = []
    private var filterViewModel = FilterViewModel()
    var newDealsAndVoucherFilterDelegate: NewDealsAndVoucherFilterDelegate!
    var trendingDealsAndVoucherFilterDelegate: TrendingDealsAndVoucherFilterDelegate!
    var intPreviousFilterByIndex = 0
    var isNewFilter = false
    var isStoreNameAPICall = false
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        languageLocalize()
        setUpController()
        xibRegister()
        tblFilterLists.rowHeight = UITableView.automaticDimension
        tblFilterLists.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        
        arrFilterBy.indices.forEach { arrFilterBy[$0].isSelected = false }
        arrFilterBy[intPreviousFilterByIndex].isSelected = true
        
        if arrFilterCategoryList.isEmpty {
            filterViewModel.FilterCategoryDelegate = self
            filterViewModel.getFilterCategoryLists()
        }
        
        if !arrFilterStoreLists.isEmpty {
            arrTempFilterStoreList = arrFilterStoreLists
            isStoreNameAPICall = true
        }
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        txtSearch.placeholder = txtSearch.placeholder?.localized()
        
        lblFilterTitle.text = lblFilterTitle.text?.localized()
        lblEmptyMsg.text = lblEmptyMsg.text?.localized()
        
        btnClearAll.setTitle(BUTTONTITLE.CLEARALL.localized(), for: .normal)
        btnApply.setTitle(BUTTONTITLE.APPLY.localized(), for: .normal)
        btnCancel.setTitle(BUTTONTITLE.CANCEL.localized(), for: .normal)
    }
    
}

//MARK: - Button Action
extension DealsAndVouchersFilterVC {
    @IBAction func btnClearAllClk(_ sender: UIButton) {
        txtSearch.text = ""
        btnSearchClear.isHidden = true
        
        arrFilterBy.indices.forEach { arrFilterBy[$0].count = 0 }
        arrFilterCategoryList.indices.forEach { arrFilterCategoryList[$0].isSelected = false }
        arrTempFilterStoreList.indices.forEach { arrTempFilterStoreList[$0].isSelected = false }
        arrFilterStoreLists = arrTempFilterStoreList
        lblEmptyMsg.isHidden = true

        if isNewFilter {
            newDealsAndVoucherFilterDelegate.newDealsAndVoucherFilter(arrCategory: arrFilterCategoryList, arrStore: arrFilterStoreLists, arrFilterBy: arrFilterBy)
        } else {
            trendingDealsAndVoucherFilterDelegate.trendingDealsAndVoucherFilterDelegate(arrCategory: arrFilterCategoryList, arrStore: arrFilterStoreLists, arrFilterBy: arrFilterBy)
        }
        
        self.tblFilterBy.reloadData()
        self.tblFilterLists.reloadData()
        
    }
    
    
    @IBAction func btnCancelClk(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnApplyClk(_ sender: UIButton) {
        
        if arrFilterBy.first?.count == 0 && arrFilterBy.last?.count == 0  {
            alertWithTitle(AlertMsg.TITLE.localized(), message: AlertMsg.INVALIDFILTER.localized())
        } else {
            if isNewFilter {
                newDealsAndVoucherFilterDelegate.newDealsAndVoucherFilter(arrCategory: arrFilterCategoryList, arrStore: arrTempFilterStoreList, arrFilterBy: arrFilterBy)
            } else {
                trendingDealsAndVoucherFilterDelegate.trendingDealsAndVoucherFilterDelegate(arrCategory: arrFilterCategoryList, arrStore: arrTempFilterStoreList, arrFilterBy: arrFilterBy)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSearchClearAction(_ sender: UIButton) {
        txtSearch.text = ""
        arrFilterStoreLists = arrTempFilterStoreList
        btnSearchClear.isHidden = true
        tblFilterLists.reloadData()
    }
    
    @IBAction func txtSearchAction(_ sender: UITextField) {
        let strSearch = sender.text  ?? ""
        arrFilterStoreLists = arrTempFilterStoreList
        
        if txtSearch.text != ""{
            btnSearchClear.isHidden = false
            let data = arrFilterStoreLists.filter({$0.name.lowercased().contains(strSearch.lowercased())})
            if data.isEmpty{
                lblEmptyMsg.isHidden = false
            } else {
                lblEmptyMsg.isHidden = true
            }
            arrFilterStoreLists = data
        } else {
            arrFilterStoreLists = arrTempFilterStoreList
            lblEmptyMsg.isHidden = true
            btnSearchClear.isHidden = true
        }
        tblFilterLists.reloadData()
    }
}


//MARK: - UITableViewDataSource
extension DealsAndVouchersFilterVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblFilterBy {
            return arrFilterBy.count
        } else {
            if intPreviousFilterByIndex == 0 {
                return arrFilterCategoryList.count
            } else {
                return arrFilterStoreLists.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblFilterBy {
            let FilterByCell = tableView.dequeueCell(ofType: FilterByTableViewCell.self)
            
            FilterByCell.setup(arrFilterBy[indexPath.row])
            if indexPath.row == (arrFilterBy.count - 1) {
                FilterByCell.bottomView.isHidden = true
            } else {
                FilterByCell.bottomView.isHidden = false
            }
            
            return FilterByCell
        } else {
            let FilterListCell = tableView.dequeueCell(ofType: FilterListsTableViewCell.self)
            
            if intPreviousFilterByIndex == 0 {
                FilterListCell.setup(arrFilterCategoryList[indexPath.row])
            } else {
                FilterListCell.setup(arrFilterStoreLists[indexPath.row])
            }
            
            return FilterListCell
        }
        
    }
    
}

//MARK: - UITableViewDelegate
extension DealsAndVouchersFilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblFilterBy {
            if intPreviousFilterByIndex != indexPath.row {
                arrFilterBy[intPreviousFilterByIndex].isSelected = false
                arrFilterBy[indexPath.row].isSelected = true
                intPreviousFilterByIndex = indexPath.row
                
                if arrTempFilterStoreList.isEmpty {
                    filterViewModel.getAllStoreNameDelegate = self
                    filterViewModel.getAllStoreName()
                }
                txtSearch.resignFirstResponder()
                if indexPath.row == 0 {
                    lblEmptyMsg.isHidden  =  true
                    constTblFilterListsTop.constant = 0
                } else {
                    constTblFilterListsTop.constant = 50
                    if isStoreNameAPICall {
                        lblEmptyMsg.isHidden  =  arrFilterStoreLists.isEmpty ? false : true
                    } else {
                        lblEmptyMsg.isHidden  =  true
                    }
                }
                
            }
            
        } else {
            if intPreviousFilterByIndex == 0 {
                if arrFilterCategoryList[indexPath.row].isSelected == true {
                    arrFilterCategoryList[indexPath.row].isSelected = false
                } else {
                    arrFilterCategoryList[indexPath.row].isSelected = true
                }
                
                arrFilterBy[intPreviousFilterByIndex].count = arrFilterCategoryList.filter({$0.isSelected == true}).count
            } else {
                
                if arrFilterStoreLists[indexPath.row].isSelected == true {
                    arrFilterStoreLists[indexPath.row].isSelected = false
                    
                    if let index = arrTempFilterStoreList.firstIndex(where: { $0.id ==  arrFilterStoreLists[indexPath.row].id }) {
                        arrTempFilterStoreList[index].isSelected = false
                    }
                } else {
                    
                    arrFilterStoreLists.indices.forEach { arrFilterStoreLists[$0].isSelected = false }
                    
                    arrTempFilterStoreList.indices.forEach { arrTempFilterStoreList[$0].isSelected = false }
                    
                    arrFilterStoreLists[indexPath.row].isSelected = true
                    
                    if let index = arrTempFilterStoreList.firstIndex(where: { $0.id == arrFilterStoreLists[indexPath.row].id }) {
                        arrTempFilterStoreList[index].isSelected = true
                    }
                }
                
                arrFilterBy[intPreviousFilterByIndex].count = arrFilterStoreLists.filter({$0.isSelected == true}).count
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

//MARK: - FilterCategoryDelegate
extension DealsAndVouchersFilterVC: FilterCategoryDelegate {
    func getFilterCategoryLists(arrCaetgoryRegion: [FilterCategoriesData]) {
        self.arrFilterCategoryList = arrCaetgoryRegion
        tblFilterLists.reloadData()
    }
    
}

//MARK: - GetAllStoreNameDelegate
extension DealsAndVouchersFilterVC: GetAllStoreNameDelegate {
    func getAllStoreNameSuccess(_ arrData: [AllStoreData]) {
        arrFilterStoreLists = arrData
        arrTempFilterStoreList = arrData
        isStoreNameAPICall = true
        tblFilterLists.reloadData()
    }
    
}
