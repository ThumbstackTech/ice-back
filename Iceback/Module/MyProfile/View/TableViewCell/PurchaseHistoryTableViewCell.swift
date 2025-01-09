//
//  PurchaseHistoryTableViewCell.swift
//  Iceback
//
//  Created by Admin on 26/03/24.
//

import UIKit

class PurchaseHistoryTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewDash: UIView!
    @IBOutlet weak var lblExpectedCashback: UILabel!
    @IBOutlet weak var viewCashbackStatus: UIView!
    @IBOutlet weak var lblExpectedCashbackTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCashbackStatus: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblInvoiceAmountTitle: UILabel!
    @IBOutlet weak var lblInvoiceAmount: UILabel!
    @IBOutlet weak var lblCashbackTitle: UILabel!
    @IBOutlet weak var lblCashback: UILabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        languageLocalize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        GCDMainThread.async { [self] in
            viewDash.makeDashedBorderLine(strokeColor: UIColor.app000000.cgColor, lineWidth: 4, spacing: 2)
        }
    }
    //MARK: - Language Localize
    func languageLocalize() {
        lblInvoiceAmountTitle.text = lblInvoiceAmountTitle.text?.localized()
        lblExpectedCashbackTitle.text = lblExpectedCashbackTitle.text?.localized()
        lblCashbackTitle.text = lblCashbackTitle.text?.localized()
        lblCashbackTitle.text = lblCashbackTitle.text?.localized()
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
     
        if let objTransaction = object as? TransactionList {
            //start- 19-4-24
            lblDate.text =  Common.getDateFormattedFromString(dateStr: objTransaction.transaction_date, recievedDateFormat: "yyyy-MM-dd HH:mm:ss", convertedDateFormat: "dd/MM/yyyy - HH:mm")
            lblShopName.text = objTransaction.store_name
            lblInvoiceAmount.text = "\(objTransaction.amount) " + "\(objTransaction.currency)"
            
            if objTransaction.user_cashback != 0.0 {
                lblCashback.text = "\(objTransaction.user_cashback) " + "\(objTransaction.currency)"
            } else {
                lblCashback.text = "-"
            }
            if (objTransaction.expected_user_cashback != 0.0){
                lblExpectedCashback.text = "\(objTransaction.expected_user_cashback) " + "\(objTransaction.currency)"
            } else {
                lblExpectedCashback.text = "-"
            }
            
            if objTransaction.status == "approved" {
                viewCashbackStatus.backgroundColor = UIColor.app008000
                lblCashbackStatus.text = objTransaction.status.capitalizingFirstLetter()
            } else {
                viewCashbackStatus.backgroundColor = UIColor.appED1925
                lblCashbackStatus.text = objTransaction.status.capitalizingFirstLetter()
            }
        }
    }
}
