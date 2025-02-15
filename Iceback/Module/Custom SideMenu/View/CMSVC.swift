//
//  CMSVC.swift
//  Iceback
//
//  Created by Admin on 11/01/24.
//

import Foundation
import UIKit

class CMSVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblContant: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    //MARK: - Constant & Variables
    private var CustomerDetiallView = CustomSideMenuViewModel()
    var objAboutUs: PrivacyPolicyDataModel?
    var arrAboutUs: [PrivacyPolicyDataModel] = []
    var arrTargetLink: [MultipleClickURL] = []
    var slug = "About Us"
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
      lblSubTitle.textColor = AppThemeManager.shared.labelColor
      lblContant.textColor = AppThemeManager.shared.labelColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Setup Controller
    func setUpController() {
        navigationItem.hidesBackButton = true
       if slug == CMSPageValue.AboutUs {
            self.lblTitle.text = CMSPAGES.aboutUs.rawValue.localized()
       } else if slug == CMSPageValue.TermsConditions {
            self.lblTitle.text = CMSPAGES.terms.rawValue.localized()
       } else if slug == CMSPageValue.PrivacyPolicy {
            self.lblTitle.text = CMSPAGES.privacy.rawValue.localized()
       }
        CustomerDetiallView.abourUsDelegate = self
        CustomerDetiallView.abousUs(slug: slug)
    }
    
    //MARK: - Set TapGesture
    func setTapGesture() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        lblContant.isUserInteractionEnabled = true
        lblContant.addGestureRecognizer(labelTap)
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        for linkRange in arrTargetLink {
            if gesture.didTapAttributedTextInLabel(label: lblContant, inRange: linkRange.targetLinkRange) {
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
}

//MARK: - Button Action
extension CMSVC {
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - AboutUsDelegate
extension CMSVC: AboutUsDelegate {
    func aboutUsDelegate(_ arrData: [PrivacyPolicyDataModel]) {
        self.objAboutUs = arrData.first
        lblSubTitle.text = objAboutUs?.title
       if slug == CMSPageValue.TermsConditions {
         lblContant.attributedText = objAboutUs?.content.first?.content.htmlAttributed(using: AFont(size: 11, type: .Roman), color: AppThemeManager.shared.textColor)
       } else if  slug == CMSPageValue.PrivacyPolicy {
            lblContant.attributedText = objAboutUs?.content.first?.text.convertHtmlToAttributedStringWithCSS(using: AFont(size: 11, type: .Roman), color: AppThemeManager.shared.textColor)
            checkStringContainURL(description: lblContant.text!)
        }else {
            lblContant.attributedText = objAboutUs?.content.first?.text.htmlAttributed(using: AFont(size: 11, type: .Roman), color: AppThemeManager.shared.textColor)
        }
        lblContant.setLineSpacing(lineSpacing: lineSpacingBetweenText)
    }
}

