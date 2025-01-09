//
//  GenericButton.swift
//  HealthLayby
//
//  Created by CMR010 on 22/05/23.
//

import Foundation
import UIKit
class GenericButton: UIButton {
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    var originalImage : UIImage?
    var color : UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:
    // MARK: initialize
    
    func initialize() {
        
//        if self.tag == 11 {
//            
//            let height = CViewHeight(self)*CScreenWidth/414
//            self.layer.cornerRadius = height/2
//            //self.layer.masksToBounds = false
//
//        }
        
        self.titleLabel?.font =  self.titleLabel?.font.convertToAppFont()
        
        self.setTitle(self.titleLabel?.text, for: .normal)
    }
    
    func changeTextAndBorderColor(color: UIColor) {
        
        // handle btn images
        if var image = self.image(for: .normal) {
            image = image.withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: .normal)
        }
        
        if var image = self.image(for: .selected) {
            image = image.withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: .selected)
        }
        self.tintColor = color
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: UIControl.State.normal)
        self.isUserInteractionEnabled = false
        
        originalImage = self.image(for: UIControl.State.normal)
        self.setImage(nil, for: UIControl.State.normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        
        if let indicator = activityIndicator {
            
            indicator.stopAnimating()
        }
        
        self.setTitle(originalButtonText, for: UIControl.State.normal)
        self.setImage(originalImage, for: UIControl.State.normal)
        self.isUserInteractionEnabled = true
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        //  activityIndicator.color = UIColor.black
        
        if let color = color {
            
            activityIndicator.color = color
        }
        else{
            activityIndicator.color = UIColor.black
        }
        
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}
