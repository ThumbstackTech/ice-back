//
//  IWantToKnowMoreVC.swift
//  Iceback
//
//  Created by Admin on 10/01/24.
//

import UIKit

class IWantToKnowMoreVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblIWantToKnowMoreDescription: UILabel!
    @IBOutlet weak var lblFriendsRegisteredTitle: UILabel!
    @IBOutlet weak var lblIWantToKnowMoreTitle: UILabel!
    @IBOutlet weak var constTblIWantToKnowMoreHeight: NSLayoutConstraint!
    @IBOutlet weak var lblFriendsRegisteredValue: UILabel!
    @IBOutlet weak var tblWantToKnowMore: UITableView!
    @IBOutlet weak var lblFriendsRegisteredSubTitle: UILabel!
    @IBOutlet weak var lblReferralBonusValue: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblReferralBonusTitle: UILabel!
    @IBOutlet weak var lblReferralDonationsValue: UILabel!
    @IBOutlet weak var lblReferralDonationsTitle: UILabel!
    
    //MARK: - Constant & Variables
    var arrIWantToKnowMoreSteps :[HowItWorksItem] = []
    var strTitle = ""
    var homeViewModel = HomeViewModel()
    var objReferalProgram : ReferalProgramData?
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        xibRegister()
       initializeSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        GCDMainThread.async { [self] in
            btnBack.circleCorner = true
            self.tblWantToKnowMore.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            
        }
    }

   func initializeSetUp() {
      setLabelTextColor(labelColor: AppThemeManager.shared.labelColor)

      func setLabelTextColor(labelColor: UIColor) {
         lblReferralBonusTitle.textColor = labelColor
         lblReferralBonusValue.textColor = labelColor
         lblFriendsRegisteredTitle.textColor = labelColor
         lblFriendsRegisteredValue.textColor = labelColor
         lblReferralDonationsTitle.textColor = labelColor
         lblReferralDonationsValue.textColor = labelColor
         lblFriendsRegisteredSubTitle.textColor = labelColor
         lblReferralBonusValue.textColor = labelColor
         lblReferralBonusTitle.textColor = labelColor
         lblReferralDonationsTitle.textColor = labelColor
         lblReferralDonationsValue.textColor = labelColor
         lblIWantToKnowMoreTitle.textColor = labelColor
         lblIWantToKnowMoreDescription.textColor = labelColor
      }
   }

    //MARK: - Observe Value Of Tableview Content Size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                GCDMainThread.async {
                    let newsize  = newvalue as! CGSize
                    self.constTblIWantToKnowMoreHeight.constant = newsize.height
                }
            }
        }
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblWantToKnowMore.delegate = self
        tblWantToKnowMore.dataSource = self
        tblWantToKnowMore.registerCell(ofType: IWantToKnowMoreTableViewCell.self)
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
        lblReferralBonusTitle.text = lblReferralBonusTitle.text?.localized()
        lblFriendsRegisteredTitle.text = lblFriendsRegisteredTitle.text?.localized()
        lblReferralDonationsTitle.text = lblReferralDonationsTitle.text?.localized()
        
        homeViewModel.referalProgramDelegate = self
        homeViewModel.referalProgram()
        
    }
}

//MARK: - Button Action
extension IWantToKnowMoreVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - UITableViewDataSource
extension IWantToKnowMoreVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIWantToKnowMoreSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: IWantToKnowMoreTableViewCell.self)
        cell.tag = indexPath.row + 1
        cell.setup(arrIWantToKnowMoreSteps[indexPath.row])
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension IWantToKnowMoreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaultHelper.isLogin {
            switch indexPath.row {
            case 0:
                UIPasteboard.general.string = UserDefaultHelper.referral_link
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.REFERRALLINKCOPIED.localized(), withTimeoutImterval: 0.3)
                
            case 1:
                guard let sharedLinkUrl = URL(string: UserDefaultHelper.referral_link) else {
                  return
                }
                
                sharePost(url: sharedLinkUrl, str: AlertMsg.ICEBACKREFERALMESSAGE.localized())
                break
                
            default:
                break
            }
        }
    }
}

//MARK: - ReferalProgramDelegate
extension IWantToKnowMoreVC: ReferalProgramDelegate {
    func referalProgram(_ referalProgramData: ReferalProgramData) {
        
        self.lblIWantToKnowMoreTitle.text = referalProgramData.title
        
        let dataTableView = referalProgramData.content?.filter({$0.type == "how_it_works_block"})
        if dataTableView?.count != 0 {
            self.arrIWantToKnowMoreSteps = dataTableView?.first?.howItWorksItems ?? []
            tblWantToKnowMore.reloadData()
        }
        
        let dataSubtitle = referalProgramData.content?.filter({($0.type == "text") && ($0.text != "")})
        if dataSubtitle?.count != 0 {
            lblIWantToKnowMoreDescription.text = dataSubtitle?.first?.text?.htmlToString
            lblIWantToKnowMoreDescription.setLineSpacing(lineSpacing: lineSpacingBetweenText)
        }
        
        let dataReferalStatistic = referalProgramData.content?.filter({$0.type == "referral_statistics"})
        if dataReferalStatistic?.count != 0 {
            lblFriendsRegisteredSubTitle.text = dataReferalStatistic?.first?.title?.htmlToString
        }
        
    }
}
