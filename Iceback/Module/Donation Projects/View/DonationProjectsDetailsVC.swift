//
//  DonationProjectsDetailsVC.swift
//  Iceback
//
//  Created by Admin on 10/01/24.
//

import UIKit
import SDWebImage

struct MultipleClickURL {
    var targetLinkRange: NSRange
    var urlString: String
}

class DonationProjectsDetailsVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblDonationProjectDetail: UILabel!
    @IBOutlet weak var lblDonationProjectsTitle: UILabel!
    @IBOutlet weak var lblProjectCostTitle: UILabel!
    @IBOutlet weak var collDonationProject: UICollectionView!
    @IBOutlet weak var imgDonation: UIImageView!
    @IBOutlet weak var lblProjectCost: UILabel!
    @IBOutlet weak var lblDonatedTitle: UILabel!
    @IBOutlet weak var lblDonated: UILabel!
    @IBOutlet weak var lblLeftTitle: UILabel!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblSimilarProjectHeading: UILabel!
    
    //MARK: - Constant & Variables
    var objDonationProjectDetail: DonationProjectsData?
    var arrSimilarDonationProject: [DonationProjectsData] = []
    var donationProjectsViewModel = DonationProjectsViewModel()
    var isHome = false
    private var currentPage : Int = 1
    private var totalDonationProjectsCount : Int = 0
    private var pageLimit : Int = 10
    private var arrTargetLink: [MultipleClickURL] = []
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        donationProjectsViewModel.donation()
        donationProjectsViewModel.donationDelegate = self
        setUpController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        collDonationProject.delegate = self
        collDonationProject.dataSource = self
        collDonationProject.register(nibWithCellClass: DonationProjectCollectionViewCell.self)
    }
    
    //MARK: - Set TapGesture
    func setTapGesture() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        lblDonationProjectDetail.isUserInteractionEnabled = true
        lblDonationProjectDetail.addGestureRecognizer(labelTap)
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        for linkRange in arrTargetLink {
            if gesture.didTapAttributedTextInLabel(label: lblDonationProjectDetail, inRange: linkRange.targetLinkRange) {
//                guard let url = URL(string: linkRange.urlString) else {
//                    return //be safe
//                }
//                UIApplication.shared.open(url)
                let vc: WKWebViewVC = WKWebViewVC.instantiate(appStoryboard:.stores)
                vc.strWebviewURL = linkRange.urlString
                self.navigationController?.pushViewController(vc, animated: false)
            }else {
               dPrint("Tapped none")
            }
        }
    }
    
    //MARK: - Check String Contain URL
    func checkStringContainURL(description: String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in:  description, options: [], range: NSRange(location: 0, length: description.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: description) else { continue }
            let url = description[range]
           dPrint("DETECTED LINK: \(url)")
            let strLink = String(url)
            let targetLink = description.nsRange(from: range)
            arrTargetLink.append(MultipleClickURL(targetLinkRange: targetLink, urlString: strLink))
        }
        
        setTapGesture()
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        //Localization Title Set
        lblProjectCostTitle.text = lblProjectCostTitle.text?.localized()
        lblDonatedTitle.text = lblDonatedTitle.text?.localized()
        lblLeftTitle.text = lblLeftTitle.text?.localized()
        lblSimilarProjectHeading.text = lblSimilarProjectHeading.text?.localized()
        btnViewMore.setTitle(BUTTONTITLE.VIEWMORE.localized(), for: .normal)
        btnDonate.setTitle(BUTTONTITLE.DONATE.localized(), for: .normal)
        
        //Donation Project Detail Data Set
        lblDonationProjectsTitle.text = objDonationProjectDetail?.title
        lblDonationProjectDetail.attributedText = objDonationProjectDetail?.content?.first?.text?.attributedString(withRegularFont: AFont(size: 15, type: .Roman), andBoldFont:  AFont(size: 15, type: .Black))
        lblDonationProjectDetail.setLineSpacing(lineSpacing: lineSpacingBetweenText)
        
        checkStringContainURL(description: lblDonationProjectDetail.text ?? "")
        
        if let imageUrl = URL(string:objDonationProjectDetail?.bannerImage?.url ?? "") {
            imgDonation.sd_setImage(with:imageUrl, placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
        } else {
                imgDonation.sd_setImage(with:URL(string:objDonationProjectDetail?.mainImage?.url ?? ""), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
        }
        
        donationProjectsViewModel.donationProjectsList(pageCount: currentPage, limitCount: pageLimit)
        donationProjectsViewModel.donationProjectsListDelegate = self
    }
    
}

//MARK: - Button Action
extension DonationProjectsDetailsVC {
    @IBAction func btnBackAction(_ sender: UIButton) {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                self.navigationController?.popViewController(animated: false)
                
                if isHome {
                    if let vc = viewController as? HomeVC {
                        self.navigationController?.popToViewController(vc, animated: false)
                        return
                    }
                }
            }
        }
    }
    
    @IBAction func btnViewMoreAction(_ sender: UIButton) {
        UserDefaultHelper.selectedPreviousTabIndex = 5
        UserDefaultHelper.selectedTabIndex = 3
        
        appendControllerToNavigationStack()
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
        
        self.navigationController?.navigateToViewController(type: DonationProjectsVC.self, animated: false, storyboard: AppStoryboard.donationProjects)
    }
    
    @IBAction func btnDonateAction(_ sender: Any) {
        let vc: WKWebViewVC = WKWebViewVC.instantiate(appStoryboard:.stores)
        vc.strWebviewURL = "\(REDIRECTIONURL.DONATEURL.localized())/\(objDonationProjectDetail?.slug ?? "")"
        self.navigationController?.pushViewController(vc, animated: false)
    }
}


//MARK: - UICollectionViewDataSource
extension DonationProjectsDetailsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSimilarDonationProject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: DonationProjectCollectionViewCell.self, indexPath: indexPath)
        cell.setup(arrSimilarDonationProject[indexPath.row])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension DonationProjectsDetailsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: DonationProjectsDetailsVC = DonationProjectsDetailsVC.instantiate(appStoryboard:.donationProjects)
        vc.objDonationProjectDetail = arrSimilarDonationProject[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegate
extension DonationProjectsDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 100), height: collectionView.bounds.height)
    }
}

//MARK: - DonationProjectsListDelegate
extension DonationProjectsDetailsVC: DonationProjectsListDelegate {
    func DonationProjectsListSuccess(_ arrData: [DonationProjectsData], totalData: Int, pageLimit: Int) {
        let data = arrData.filter({$0.id != objDonationProjectDetail?.id})
        arrSimilarDonationProject.append(contentsOf: data)
        totalDonationProjectsCount = totalData
        xibRegister()
    }
    
}

//MARK: - DonationDelegate
extension DonationProjectsDetailsVC: DonationDelegate {
    func donation(_ arrData: [DonationData]) {
        let data = arrData.filter({$0.slug == objDonationProjectDetail?.slug })
        lblProjectCost.text = "\(objDonationProjectDetail?.projectCost ?? "0") CHF"
        let donatedAmount = data.map({$0.amount}).reduce(0, +)
        lblDonated.text = "\(removeDecimalIfZeroTwoDigit(from: donatedAmount)) CHF"
        let donationLeftAmount = (Double(objDonationProjectDetail?.projectCost ?? "0") ?? 0.0) - (data.map({$0.amount}).reduce(0, +))
        lblLeft.text = "\(removeDecimalIfZeroTwoDigit(from: donationLeftAmount)) CHF"
    }
    
}
