//
//  SelectLanguageVC.swift
//  Iceback
//
//  Created by Admin on 11/01/24.
//

import UIKit
import IQKeyboardManagerSwift

class SelectLanguageVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblLLanguage: UITableView!
    @IBOutlet weak var btnUpDate: UIButton!
    
    //MARK: - Constant & Variables
   var arrSelectLanguage : [SelectLanguageModel] = [SelectLanguageModel(SelectLanguage: Language.Name.English,langCode: Language.Code.English,  isSelect: false),
                                                    SelectLanguageModel(SelectLanguage: Language.Name.German,langCode: Language.Code.German,  isSelect: false)]
    
    var selectedRows : [IndexPath] = []
    private var intLanguageSelect = 0
    var selectedLanguage: String = ""
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        xibRegister()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        self.lblTitle.text = "Select Language".localized()
        self.btnUpDate.setTitle(BUTTONTITLE.UPDATE.localized(), for: .normal)
        
        arrSelectLanguage[UserDefaultHelper.selectedLanguageIndexPath].isSelect = true
        intLanguageSelect = UserDefaultHelper.selectedLanguageIndexPath
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblLLanguage.dataSource = self
        tblLLanguage.delegate = self
        tblLLanguage.register(nibWithCellClass: MyAccountCell.self)
    }
    
    
    //MARK: - Restart App
    func restartApp() {
        UserDefaultHelper.selectedPreviousTabIndex = 5
        UserDefaultHelper.selectedTabIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
        
        self.navigationController?.viewControllers = [self]
        
        appDelegate.arrNavigationStack = []
        
        let vc: HomeVC = HomeVC.instantiate(appStoryboard: .home)
        self.navigationController?.fadeTo(vc, animated: false)
    }
}

//MARK: - Button Action
extension SelectLanguageVC {
    @IBAction func btnUpDateClick(_ sender: Any) {
        
        UserDefaultHelper.selectedLanguage = arrSelectLanguage[intLanguageSelect].langCode
        UserDefaultHelper.selectedLanguageIndexPath = intLanguageSelect
        
        Global.destroySharedManager()
        
        GCDMainThread.async {
            self.tblLLanguage.reloadData()
            self.restartApp()
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: -  UITableViewDataSource
extension SelectLanguageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MyAccountCell.self)
        cell.setup(arrSelectLanguage[indexPath.item])
        if indexPath.row == arrSelectLanguage.count - 1 {
            cell.viewDashLine.isHidden = true
        } else {
            cell.viewDashLine.isHidden = false
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension SelectLanguageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if intLanguageSelect != indexPath.item {
            arrSelectLanguage[intLanguageSelect].isSelect = false
            arrSelectLanguage[indexPath.row].isSelect = true
            intLanguageSelect = indexPath.item
            tblLLanguage.reloadData()
        }
    }
}


