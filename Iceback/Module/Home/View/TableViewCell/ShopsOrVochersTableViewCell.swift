//
//  ShopsOrVochersTableViewCell.swift
//  Iceback
//
//  Created by Admin on 09/01/24.
//

import UIKit

class ShopsOrVochersTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var collShopsOrVochers: UICollectionView!
    @IBOutlet weak var constCollShopsOrVochersHeight: NSLayoutConstraint!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    
    //MARK: - Constant & Variables
    var arrCashback = [ShopWithCashbackData]() {
        didSet {
            collShopsOrVochers.reloadData()
            setUpControls()
        }
    }
    var arrVouchers = [SpecialAndVoucherData]() {
        didSet {
            collShopsOrVochers.reloadData()
            setUpControls()
        }
    }
    var isCashback = false
    var navigateToStoreDetailDelegate: NavigateToStoreDetailDelegate!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        xibRegister()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        collShopsOrVochers.delegate = self
        collShopsOrVochers.dataSource = self
        collShopsOrVochers.register(nibWithCellClass: ShopsWithCashbackCollectionViewCell.self)
        collShopsOrVochers.register(nibWithCellClass: ShopsOrVochersCollectionViewCell.self)
    }
    
    func setUpControls() {
        if isCashback {
            lblEmptyMsg.isHidden = arrCashback.isEmpty ?  false : true
        } else {
            lblEmptyMsg.isHidden = arrVouchers.isEmpty ?  false : true
        }
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        
    }
}

//MARK: - UICollectionViewDataSource
extension ShopsOrVochersTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCashback ?  arrCashback.count : arrVouchers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCashback {
            let cell = collectionView.dequeueCell(ofType: ShopsWithCashbackCollectionViewCell.self, indexPath: indexPath)
            cell.setup(arrCashback[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: ShopsOrVochersCollectionViewCell.self, indexPath: indexPath)
            cell.setup(arrVouchers[indexPath.row])
            return cell
        }
    }
}


//MARK: - UICollectionViewDelegate
extension ShopsOrVochersTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCashback {
            navigateToStoreDetailDelegate.navigateToStoreDetail(arrCashback[indexPath.row].id, arrCashback[indexPath.row].id, isCashback, name: arrCashback[indexPath.row].name, expiryDate: arrCashback[indexPath.row].expiryDate, couponCode: arrCashback[indexPath.row].code)
        } else {
            navigateToStoreDetailDelegate.navigateToStoreDetail(arrVouchers[indexPath.row].storeId,arrVouchers[indexPath.row].id ,isCashback, name: arrVouchers[indexPath.row].name, expiryDate: arrVouchers[indexPath.row].expiryDate, couponCode: arrVouchers[indexPath.row].code)
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ShopsOrVochersTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 15)/2, height: collectionView.bounds.height)
    }
}
