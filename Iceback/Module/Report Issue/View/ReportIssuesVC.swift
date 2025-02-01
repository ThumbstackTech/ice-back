//
//  BiometricLoginVC.swift
//  Iceback
//
//  Created by Admin on 22/03/24.
//

import UIKit

class ReportIssuesVC: UIViewController {
  
  //MARK: - IBOutlet
  @IBOutlet weak var lblReportIssueTitle: UILabel!
  @IBOutlet weak var lblNoDataFound: UILabel!
  @IBOutlet weak var tblReportIssues: UITableView!
  @IBOutlet weak var btnReportIssue: UIButton!
  
  //MARK: - Constant & Variables
  var arrReportList : [ReportListData] = []
  var reportList  = ReportViewModel()
  var currentPage: Int = 1
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
    navigationItem.hidesBackButton = true
    languageLocalize()
    initialSetUp()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpController()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  //MARK: - Setup Controller
  func setUpController(){
    isLoadMore = false
    arrReportList.removeAll()
    tblReportIssues.reloadData()
    currentPage = 1
    reportList.reportListDelegate = self
    reportList.report(pageCount: currentPage)
  }
  
  //MARK: - XIB Register
  func xibRegister() {
    tblReportIssues.delegate = self
    tblReportIssues.dataSource = self
    tblReportIssues.registerCell(ofType: ReportIssueTableViewCell.self)
    tblReportIssues.registerCell(ofType: BottomEmptyTableViewCell.self)
    tblReportIssues.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
    tblReportIssues.addSubview(self.refreshControl)
  }
  
  //MARK: - Language Localize
  func languageLocalize() {
    lblNoDataFound.text = lblNoDataFound.text?.localized()
    lblReportIssueTitle.text = lblReportIssueTitle.text?.localized()
    btnReportIssue.setTitle(BUTTONTITLE.REPORTISSUE.localized(), for: .normal)
  }
  
  //MARK: - RefreshControl
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    isLoadMore = false
    currentPage = 1
    lblNoDataFound.isHidden = true
    arrReportList.removeAll()
    tblReportIssues.reloadData()
    reportList.report(pageCount: currentPage)
    refreshControl.endRefreshing()
  }

   func initialSetUp() {
      lblNoDataFound.textColor = AppThemeManager.shared.labelColor
      lblReportIssueTitle.textColor = AppThemeManager.shared.secondaryColor
      btnReportIssue.backgroundColor = AppThemeManager.shared.primaryColor
   }
}


//MARK: - Button Action
extension ReportIssuesVC {
  @IBAction func btnBackAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: false)
  }
  
  @IBAction func btnReportIssue(_ sender: UIButton) {
    let vc: CreateReportIssueVC = CreateReportIssueVC.instantiate(appStoryboard: .reportIssue)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: - UITableViewDataSource
extension ReportIssuesVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  isLoadMore ? arrReportList.count + 1 :  arrReportList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == arrReportList.count && isLoadMore{
      let emptyCell = tableView.dequeueCell(ofType: BottomEmptyTableViewCell.self)
      emptyCell.setup(EMPTYCELLMESSAGE.REPORTISSUESEMPTY)
      return emptyCell
    } else {
      let cell = tableView.dequeueCell(ofType: ReportIssueTableViewCell.self)
      cell.setup(arrReportList[indexPath.row])
      return cell
    }
  }
}

//MARK: - UITableViewDelegate
extension ReportIssuesVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard tableView.cellForRow(at: indexPath) is ReportIssueTableViewCell else { return }
    let vc: ReportIssueDetailVC = ReportIssueDetailVC.instantiate(appStoryboard:.reportIssue)
    vc.intReportId = arrReportList[indexPath.row].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

//MARK: - UIScrollViewDelegate
extension ReportIssuesVC: UIScrollViewDelegate {
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    if scrollView == tblReportIssues {
      if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (arrReportList.count/Global.sharedManager.intPaginationLimit) == currentPage {
          tblReportIssues.showLoadingFooter()
          currentPage += 1
          reportList.report(pageCount: currentPage)
          dPrint("Works")
        } else {
          self.isLoadMore = arrReportList.isEmpty ? false : true
        }
      }
    }
  }
}

//MARK: - ReportListDelegate
extension ReportIssuesVC : ReportListDelegate {
  
  func reportListSucess(_ arrData: [ReportListData]) {
    tblReportIssues.hideLoadingFooter()
    if !arrData.isEmpty {
      arrReportList.append(contentsOf: arrData)
      xibRegister()
      if arrData.count != Global.sharedManager.intPaginationLimit {
        self.isLoadMore = arrReportList.isEmpty ? false : true
      }
      tblReportIssues.reloadData()
      
    } else {
      isLoadMore = true
    }
    lblNoDataFound.isHidden = arrReportList.isEmpty ? false : true
  }
}

