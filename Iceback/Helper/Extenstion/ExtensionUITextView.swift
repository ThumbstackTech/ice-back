//
//  ExtensionUITextView.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


private var kPlaceHolderString          : UInt8 = 0
private var kPlaceHolderColor           : UInt8 = 0
private var kPlaceHolderInternal        : UInt8 = 0
private var kPlaceHolderAlignment       : UInt8 = 0

extension UITextView:UITextViewDelegate {
    func set(placeholder ph:String) -> Void {
        self.set(object: ph as AnyObject, forKey: &kPlaceHolderString)
        self.delegate = self
        self.addObserver()
        self.updatePlaceholder()
    }
    
    func set(placeholder ph:String, color:UIColor) -> Void {
        self.set(object: color, forKey: &kPlaceHolderColor)
        self.set(placeholder: ph)
    }
    
    fileprivate func addObserver() -> Void {
        self.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }

    // MARK: - Deinitialization
    fileprivate func removeObserver() -> Void {
        if (self.observationInfo != nil) {
            removeObserver(self, forKeyPath: "text")
        }
    }
    
    func updatePlaceholder() -> Void {
        if (self.text.count == 0) {
            self.set(object: self.object(forKey: &kPlaceHolderString), forKey: &kPlaceHolderInternal)
        } else {
            self.set(object: "" as AnyObject, forKey: &kPlaceHolderInternal)
        }
        self.setNeedsDisplay()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if (newSuperview == nil) {
            self.removeObserver()
        }
    }

    //MARK:- ObserveValueForKeyPath
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ((object as? UITextView) == self) {
            self.updatePlaceholder()
        }
    }

    //MARK:-
    //MARK:- UITextViewDelegate
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.updatePlaceholder()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.updatePlaceholder()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.updatePlaceholder()
    }
}
