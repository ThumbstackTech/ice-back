//
//  FavouritesVC.swift
//  Iceback
//
//  Created by Admin on 02/05/24.
//

import UIKit

class FavouritesVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblFavouritesList: UITableView!
    @IBOutlet weak var lblFavouriteTitle: UILabel!
    @IBOutlet weak var lblNoDataAvailableMsg : UILabel!
    
    //MARK: - Constant & Variables
    var myProfileViewModel = MyProfileViewModel()
    var storesViewModel = StoresViewModel()
    var arrFavourite: [storeDataListObject] = []
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
        languageLocalize()
        self.tblFavouritesList.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpController()
        xibRegister()
    }
    
    //MARK: - SetupController
    func setUpController() {
        isLoadMore = false
        arrFavourite.removeAll()
        tblFavouritesList.reloadData()
        myProfileViewModel.favouriteStoresDelegate = self
        myProfileViewModel.favouriteStores(intPage: intCurrentPage)
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblFavouriteTitle.text = lblFavouriteTitle.text?.localized()
        lblNoDataAvailableMsg.text = lblNoDataAvailableMsg.text?.localized()
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblFavouritesList.delegate = self
        tblFavouritesList.dataSource = self
        tblFavouritesList.registerCell(ofType: StoresAndDealsVouchersCell.self)
        tblFavouritesList.registerCell(ofType: BottomEmptyTableViewCell.self)
        tblFavouritesList.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - RefreshControl
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        arrFavourite.removeAll()
        isLoadMore = false
        lblNoDataAvailableMsg.isHidden = true
        intCurrentPage = 1
        tblFavouritesList.reloadData()
        myProfileViewModel.favouriteStores(intPage: intCurrentPage)
        refreshControl.endRefreshing()
    }
}


//MARK: - Button Actions
extension FavouritesVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func btnShopNowAction(_ sender: UIButton) {
        let vc: CouponDetailsVC = CouponDetailsVC.instantiate(appStoryboard:.stores)
        vc.intStoreId = arrFavourite[sender.tag].storeId
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @objc func btnFavouriteAction(_ sender: UIButton) {
        storesViewModel.favouriteStoreRemoveDelegate = self
        storesViewModel.favouriteStoreRemove(storeId: arrFavourite[sender.tag].storeId, intIndex: sender.tag)
    }
    
}

//MARK: - UITableViewDataSource
extension FavouritesVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isLoadMore ? arrFavourite.count + 1 :  arrFavourite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == arrFavourite.count && isLoadMore {
            let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
            emptyCell.setup(EMPTYCELLMESSAGE.FAVOURITEEMPTY)
            return emptyCell
        } else {
            let cell = tableView.dequeueCell(ofType: StoresAndDealsVouchersCell.self)
            cell.btnShopNow.tag = indexPath.row
            cell.btnFavourite.tag = indexPath.row
            cell.btnShopNow.addTarget(self, action: #selector(btnShopNowAction), for: .touchUpInside)
            cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteAction), for: .touchUpInside)
            cell.setup(arrFavourite[indexPath.row])
            cell.btnFavourite.isHidden = false
            return cell
        }
    }
    
}

//MARK: - UITableViewDelegate
extension FavouritesVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       guard tableView.cellForRow(at: indexPath) is StoresAndDealsVouchersCell else { return }
        let vc: CouponDetailsVC = CouponDetailsVC.instantiate(appStoryboard:.stores)
        vc.intStoreId = arrFavourite[indexPath.row].storeId
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - UIScrollViewDelegate
extension FavouritesVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblFavouritesList {
                if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                    if (arrFavourite.count/Global.sharedManager.intStoreAndVouchersPageLimit) == intCurrentPage {
                        tblFavouritesList.showLoadingFooter()
                        intCurrentPage += 1
                        myProfileViewModel.favouriteStores(intPage: intCurrentPage)
                       dPrint("Works Favourite Pagination")
                    } else {
                        self.isLoadMore = arrFavourite.isEmpty ? false : true
                    }
                }
        }
    }
}

//MARK: - FavouriteStoresDelegate
extension FavouritesVC: FavouriteStoresDelegate {
    func favouriteStoresSucess(_ arrData: [storeDataListObject]) {
        tblFavouritesList.hideLoadingFooter()
        arrFavourite.append(contentsOf: arrData)
        arrFavourite.forEach({$0.isFavourite = 1})
        
        guard !arrData.isEmpty else {
            self.isLoadMore = arrFavourite.isEmpty ? false : true
            lblNoDataAvailableMsg.isHidden = arrFavourite.isEmpty ? false : true
            tblFavouritesList.reloadData()
            return
        }
        
        if arrData.count != Global.sharedManager.intStoreAndVouchersPageLimit{
            self.isLoadMore = arrFavourite.isEmpty ? false : true
        }
      
        lblNoDataAvailableMsg.isHidden = arrFavourite.isEmpty ? false : true
        tblFavouritesList.reloadData()
    }
}

//MARK: - FavouriteStoreRemoveDelegate
extension FavouritesVC: FavouriteStoreRemoveDelegate {
    func favouriteStoreRemoveSuccess(_ isSuccess: Bool, intIndex: Int) {
        let dict:[String: Any] = ["storeId": arrFavourite[intIndex].storeId]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RemoveFavouriteStore"), object: nil, userInfo: dict)
        arrFavourite.remove(at: intIndex)
        self.isLoadMore = arrFavourite.isEmpty ? false : true
        lblNoDataAvailableMsg.isHidden = arrFavourite.isEmpty ? false : true
        tblFavouritesList.reloadData()
    }
    
}

