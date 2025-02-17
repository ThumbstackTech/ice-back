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
  
  @IBOutlet weak var btnGoForward: UIButton!
  @IBOutlet weak var btnGoBackward: UIButton!
  @IBOutlet weak var btnRefresh: UIButton!
  @IBOutlet weak var btnURLText: UIButton!
  @IBOutlet weak var btnDone: UIButton!
  @IBOutlet weak var btnDetails: UIButton!
  var objDealsAndVoucherDetailData : DealsAndVoucherDetailData?
  var objStoreDetail: StoreDetailsNewModel?
  

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
  var isHideDetailButton: Bool = false

  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setCashbackStatus()
    setUpController()
    setSwipeGesture()
    btnDone.setTitle(BUTTONTITLE.DONE.localized(), for: .normal)
    btnDetails.setTitle(BUTTONTITLE.DETAIL.localized(), for: .normal)
    if isHideDetailButton {
      btnDetails.isHidden = true
    } else {
      btnDetails.isHidden = false
    }
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
  
  deinit {
    
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

  func manageButtonStates() {
    if wkWebView.canGoBack {
      setButtonVisibilityAndEnability(btn: btnGoBackward)
    } else {
      setButtonVisibilityAndEnability(btn: btnGoBackward, isEnabled: false, alpha: 0.5)
    }
    
    if wkWebView.canGoForward {
      setButtonVisibilityAndEnability(btn: btnGoForward)
    } else {
      setButtonVisibilityAndEnability(btn: btnGoForward, isEnabled: false, alpha: 0.5)
    }
    
    func setButtonVisibilityAndEnability(btn: UIButton, isEnabled: Bool = true, alpha: CGFloat = 1.0) {
      btn.isEnabled = isEnabled
      btn.alpha = alpha
    }
  }
  
  //MARK: - Setup Controller
  func setUpController() {
    manageButtonStates()
    navigationItem.hidesBackButton = true
    viewCashbackStatus.isHidden = isCashbackBottomView ? false : true

    wkWebView.navigationDelegate = self
    dPrint("strWebviewURL = \(strWebviewURL)")
    let link = URL(string: strWebviewURL )!
    let request = URLRequest(url: link )
    wkWebView.load(request)
    if #available(iOS 16.0, *) {
      btnURLText.setTitle(wkWebView.url?.host(), for: .normal)
    } else {
      btnURLText.setTitle(wkWebView.url?.absoluteString ?? "", for: .normal)
    }
    constWkWebViewBottom.constant = isCashbackBottomView ? 70 : 70
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
  
  @IBAction func btnGoBackward(_ sender: UIButton) {
    if (self.wkWebView.canGoBack) {
      self.wkWebView.goBack()
    }
    manageButtonStates()
  }
  
  @IBAction func btnGoForward(_ sender: UIButton) {
    if (self.wkWebView.canGoForward) {
      self.wkWebView.goForward()
    }
    manageButtonStates()
  }
  
  @IBAction func btnRefresh(_ sender: UIButton) {
    timer.invalidate()
    appDelegate.timeLeft = 0
    setUpController()
  }
  
  @IBAction func btnDetails(_ sender: UIButton) {
    let vc: ContentDetailsViewController = ContentDetailsViewController.instantiate(appStoryboard:.stores)
    if let obStore = objStoreDetail {
      vc.objStoreDetail = obStore
    }
    if let obDeals = objDealsAndVoucherDetailData {
      vc.objDealsAndVoucherDetailData = obDeals
    }
    vc.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    if #available(iOS 15.0, *) {
      if let sheetPresentationController = vc.presentationController as? UISheetPresentationController {
        sheetPresentationController.prefersGrabberVisible = true
        // Define which heights are allowed for our sheet
        sheetPresentationController.detents = [
          UISheetPresentationController.Detent.medium(),
          UISheetPresentationController.Detent.large()
        ]
      }
    } else {
      // Fallback on earlier versions
    }
    self.present(vc, animated: true)
  }
}

//MARK: - WKNavigationDelegate
extension WKWebViewVC: WKNavigationDelegate  {
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    dPrint("WEBVIEW ERROR: \(error.localizedDescription)")
    manageButtonStates()
  }

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    dPrint("WEBVIEW LOAD START")
    if !isFirstTimeLoad {
      HUD.show()
      isFirstTimeLoad = true
    }
    manageButtonStates()
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("WEBVIEW LOAD FINISH: \(webView.canGoBack)")
    HUD.hide()
    manageButtonStates()
  }

  func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    guard let serverTrust = challenge.protectionSpace.serverTrust  else {
      completionHandler(.useCredential, nil)
      return
    }
    manageButtonStates()
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
