//
//  DonationProjectsVC.swift
//  Iceback
//
//  Created by Admin on 10/01/24.
//

import UIKit

class DonationProjectsVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var lblEmptyMsg: UILabel!
  @IBOutlet weak var tblDonation: UITableView!
  @IBOutlet weak var containerTabBarView: UIView!
  @IBOutlet weak var lblDonationProjectsTitle: UILabel!

  //MARK: - Constant & Variables
  var arrDonationProject: [DonationProjectsData] = []
  var donationProjectsViewModel = DonationProjectsViewModel()
  var intCurrentPage : Int = 1
  var totalDonationProjectsCount : Int = 0
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
    refreshControl.tintColor = UIColor.appEFF8FF
    return refreshControl
  }()

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    xibRegister()
    languageLocalize()
    setUpController()
     initializeSetUp()
  }

  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "tabChanged"), object: nil)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  override func viewDidLayoutSubviews() {
    GCDMainThread.async { [self] in
      containerTabBarView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
  }

  //MARK: - XIB Register
  func xibRegister() {
    tblDonation.delegate = self
    tblDonation.dataSource = self
    tblDonation.registerCell(ofType: DonationTableViewCell.self)
    tblDonation.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 8, right: 0)
  }

  //MARK: - Setup Controller
  func setUpController() {
    donationProjectsViewModel.donationProjectsList(pageCount: intCurrentPage, limitCount: Global.sharedManager.intPaginationLimit)
    donationProjectsViewModel.donationProjectsListDelegate = self
    self.tblDonation.addSubview(self.refreshControl)
  }

  //MARK: - Language Localize
  func languageLocalize() {
    lblEmptyMsg.text = lblEmptyMsg.text?.localized()
    lblDonationProjectsTitle.text = lblDonationProjectsTitle.text?.localized()
  }

  //MARK: - RefreshControl
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    lblEmptyMsg.isHidden = true
    intCurrentPage = 1
    arrDonationProject.removeAll()
    tblDonation.reloadData()

    donationProjectsViewModel.donationProjectsList(pageCount: intCurrentPage, limitCount: Global.sharedManager.intPaginationLimit)
    refreshControl.endRefreshing()
  }

   func initializeSetUp() {
      lblDonationProjectsTitle.textColor = AppThemeManager.shared.labelColor
      lblEmptyMsg.textColor = AppThemeManager.shared.labelColor
   }
}

//MARK: - UITableViewDataSource
extension DonationProjectsVC: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrDonationProject.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(ofType: DonationTableViewCell.self)
    cell.setup(arrDonationProject[indexPath.row])
    return cell
  }
}

//MARK: - UITableViewDelegate
extension DonationProjectsVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc: DonationProjectsDetailsVC = DonationProjectsDetailsVC.instantiate(appStoryboard:.donationProjects)
    vc.objDonationProjectDetail = arrDonationProject[indexPath.row]
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: - UIScrollViewDelegate
extension DonationProjectsVC: UIScrollViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    if scrollView == tblDonation {
      if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (arrDonationProject.count/Global.sharedManager.intPaginationLimit) == intCurrentPage {
          tblDonation.showLoadingFooter()
          intCurrentPage += 1
          donationProjectsViewModel.donationProjectsList(pageCount: intCurrentPage, limitCount: Global.sharedManager.intPaginationLimit)
          dPrint("Works Donation Pagination")
        }
      }
    }
  }
}

//MARK: - DonationProjectsListDelegate
extension DonationProjectsVC: DonationProjectsListDelegate {
  func DonationProjectsListSuccess(_ arrData: [DonationProjectsData], totalData: Int, pageLimit: Int) {
    self.tblDonation.hideLoadingFooter()

    arrDonationProject.append(contentsOf: arrData)
    totalDonationProjectsCount = totalData

    guard !arrData.isEmpty else {
      self.lblEmptyMsg.isHidden = arrDonationProject.isEmpty ? false : true
      self.tblDonation.reloadData()
      return
    }

    self.tblDonation.reloadData()
  }
}
