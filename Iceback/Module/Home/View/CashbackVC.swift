//
//  CashbackVC.swift
//  Iceback
//
//  Created by Admin on 02/02/24.
//

import UIKit

class CashbackVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblCashbackTitle: UILabel!
    @IBOutlet weak var lblCashbackDescription: UILabel!
    @IBOutlet weak var imgCashback: UIImageView!
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    //MARK: - Constant & Variables
    var homeViewModel = HomeViewModel()
    var objCashbackProgram : ReferalProgramData?
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        languageLocalize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        homeViewModel.cashbackProgramDelegate = self
        homeViewModel.cashbackProgram()
    }
    
    //MARK: - Language Localize
    func languageLocalize() {
        lblErrorMsg.text = lblErrorMsg.text?.localized()
    }
}

//MARK: - Button Action
extension CashbackVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - CashbackProgramDelegate
extension CashbackVC: CashbackProgramDelegate {
    func cashbackProgram(_ cashbackProgramData: ReferalProgramData) {
        if cashbackProgramData.content?.first?.text == nil {
            lblErrorMsg.isHidden = false
            lblCashbackDescription.isHidden = true
            imgCashback.isHidden = true
            lblCashbackTitle.text = "Cashback"
        } else {
            lblErrorMsg.isHidden = true
            lblCashbackDescription.isHidden = false
            imgCashback.isHidden = false
            self.objCashbackProgram = cashbackProgramData
            lblCashbackTitle.text = cashbackProgramData.title
            
            lblCashbackDescription.attributedText = cashbackProgramData.content?.first?.text?.htmlAttributed(using: AFont(size: 12, type: .Roman), color: .app00000070)
            lblCashbackDescription.setLineSpacing(lineSpacing: lineSpacingBetweenText)
            
            imgCashback.sd_setImage(with:URL(string: cashbackProgramData.primaryImage?.url ?? "") , placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
        }
    }
}
