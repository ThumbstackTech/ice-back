//
//  WKWebViewVC.swift
//  Iceback
//
//  Created by Admin on 22/02/24.
//

import UIKit
import WebKit

class WKWebViewVC: UIViewController {

  //MARK: - IBOutlet
  @IBOutlet weak var wkWebView: WKWebView!
  @IBOutlet weak var viewBottom: UIView!
  @IBOutlet weak var imgCashbackStatus: UIImageView!
  @IBOutlet weak var viewCashbackStatus: UIView!
  @IBOutlet weak var lblCashbackStatus: UILabel!
  @IBOutlet weak var constWkWebViewBottom: NSLayoutConstraint!
  @IBOutlet weak var btnBack: UIButton!

  //MARK: - Constant & Variables
  private var storesViewModel = StoresViewModel()
  private var dealsAndVouchersViewModel = DealsAndVouchersViewModel()
  var strWebviewURL: String = ""
  private var HUD = SVProgress()
  var isCashbackStatusActive = false
  var isCashbackBottomView = false
  private var endTime: Date?
  private var timer = Timer()
  var intStoreId = 0
  var isStore = false
  private var isFirstTimeLoad = false

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setCashbackStatus()
    setUpController()
    setSwipeGesture()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    dPrint("WEBVIEW VIEW DID DISAPPEAR")
    timer.invalidate()
    appDelegate.timeLeft = INTEGER.TIMEDURATION
  }

  //MARK: - Set Swipe Gesture
  func setSwipeGesture() {
    let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
    swipeRightRecognizer.direction = .right
    wkWebView.addGestureRecognizer(swipeRightRecognizer)
  }

  @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {

    if (recognizer.direction == .right) {
      if wkWebView.canGoBack {
        wkWebView.goBack()
      } else {
        timer.invalidate()
        appDelegate.timeLeft = INTEGER.TIMEDURATION
        self.navigationController?.popViewController(animated: false)
      }
    }
  }

  //MARK: - Setup Controller
  func setUpController() {
    navigationItem.hidesBackButton = true
    viewBottom.isHidden = isCashbackBottomView ? false : true

    wkWebView.navigationDelegate = self

    let link = URL(string: strWebviewURL )!
    let request = URLRequest(url: link )
    wkWebView.load(request)
    constWkWebViewBottom.constant = isCashbackBottomView ? 70 : 0
    if isCashbackBottomView {
      if appDelegate.timeLeft < 0 {
        appDelegate.timeLeft = 2
      }
      endTime = Date().addingTimeInterval(appDelegate.timeLeft)
      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
  }

  func setCashbackStatus() {
    imgCashbackStatus.image = isCashbackStatusActive ? IMAGES.ICN_CASHBACKSTATUSACTIVE : IMAGES.ICN_CASHBACKSTATUSINACTIVE
    lblCashbackStatus.text =  isCashbackStatusActive ? LABELTITLE.CASHBACKSTATUSACTIVE.localized() : LABELTITLE.CASHBACKSTATUSINACTIVE.localized()
    viewCashbackStatus.backgroundColor = isCashbackStatusActive ? .app008000 : .appED1925
  }

  //MARK: - Update Time
  @objc func updateTime() {
    if appDelegate.timeLeft > 0 {
      appDelegate.timeLeft = endTime?.timeIntervalSinceNow ?? 0
      dPrint("TIME LEFT:",  appDelegate.timeLeft )
    } else {
      timer.invalidate()
      dPrint("CASHBACK API STATUS CALL")
      if isStore {
        storesViewModel.StoreDetailsData(storeId: intStoreId, isHideLoader: true)
        storesViewModel.StoreDetailsDelegate = self
      } else {
        self.dealsAndVouchersViewModel.dealsAndVouchersDetailDelegate = self
        self.dealsAndVouchersViewModel.dealsAndVoucherDetails(storeId: intStoreId)
      }
    }
  }
}

//MARK: - Button Action
extension WKWebViewVC {
   // This will work for back and then close the web view
  @IBAction func btnCloseAction(_ sender: UIButton) {
    if (self.wkWebView.canGoBack) {
      self.wkWebView.goBack()
    } else {
      timer.invalidate()
      appDelegate.timeLeft = INTEGER.TIMEDURATION
      self.navigationController?.popViewController(animated: false)
    }
  }

   @IBAction func btnClose(_ sender: UIButton) {
      timer.invalidate()
      appDelegate.timeLeft = INTEGER.TIMEDURATION
      self.navigationController?.popViewController(animated: false)
   }
}

//MARK: - WKNavigationDelegate
extension WKWebViewVC: WKNavigationDelegate  {
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    dPrint("WEBVIEW ERROR: \(error.localizedDescription)")
  }

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    dPrint("WEBVIEW LOAD START")
    if !isFirstTimeLoad {
      HUD.show()
      isFirstTimeLoad = true
    }
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("WEBVIEW LOAD FINISH: \(webView.canGoBack)")
    HUD.hide()
  }

  func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    guard let serverTrust = challenge.protectionSpace.serverTrust  else {
      completionHandler(.useCredential, nil)
      return
    }
    let credential = URLCredential(trust: serverTrust)
    completionHandler(.useCredential, credential)
  }
}

//MARK: - StoreDetailsDelegate
extension WKWebViewVC: StoreDetailsDelegate {
  func StoreDetails(_ objData: StoreDetailsNewModel) {
    if objData.clickThroughUrl.isEmpty {
      isCashbackStatusActive = false
      setCashbackStatus()
    }

    appDelegate.timeLeft = INTEGER.TIMEDURATION
    endTime = Date().addingTimeInterval(appDelegate.timeLeft)
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
  }
}

//MARK: - DealsAndVouchersDetailDelegate
extension WKWebViewVC: DealsAndVouchersDetailDelegate {
  func dealsAndVouchersDetail(_ objData: DealsAndVoucherDetailData) {
    if objData.clickThroughUrl.isEmpty {
      isCashbackStatusActive = false
      setCashbackStatus()
    }

    appDelegate.timeLeft = INTEGER.TIMEDURATION
    endTime = Date().addingTimeInterval(appDelegate.timeLeft)
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
  }
}
