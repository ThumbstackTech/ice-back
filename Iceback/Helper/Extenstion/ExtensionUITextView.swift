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

extension UITextView:UITextViewDelegate
{
    func set(placeholder ph:String) -> Void
    {
        self.set(object: ph as AnyObject, forKey: &kPlaceHolderString)
        self.delegate = self
        self.addObserver()
        self.updatePlaceholder()
    }
    
    func set(placeholder ph:String, color:UIColor) -> Void
    {
        self.set(object: color, forKey: &kPlaceHolderColor)
        self.set(placeholder: ph)
    }
    
    fileprivate func addObserver() -> Void
    {
//        self.removeObserver(self, forKeyPath: "text")
        self.addObserver(self, forKeyPath: "text", options: .new, context: nil)

    }

    // MARK: - Deinitialization
    

    fileprivate func removeObserver() -> Void
    {
        if (self.observationInfo != nil)
        {
            removeObserver(self, forKeyPath: "text")
        }
    }
    
    func updatePlaceholder() -> Void
    {
        if (self.text.count == 0) {
            self.set(object: self.object(forKey: &kPlaceHolderString), forKey: &kPlaceHolderInternal)
        } else {
            self.set(object: "" as AnyObject, forKey: &kPlaceHolderInternal)
        }
        
        self.setNeedsDisplay()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?)
    {
        super.willMove(toSuperview: newSuperview)
        if (newSuperview == nil) {
            self.removeObserver()
        }
    }
    
//    open override func draw(_ rect: CGRect)
//    {
//        super.draw(rect)
//        
//        let phString = self.object(forKey: &kPlaceHolderString)
//        if (phString == nil) {
//            return
//        }
//        
//        var phColor = self.object(forKey: &kPlaceHolderColor) as? UIColor
//        if (phColor == nil) {
//            phColor = (self.textColor != nil) ? self.textColor : UIColor.lightGray
//        }
//        
//        let phInter = self.object(forKey: &kPlaceHolderInternal) as? NSString
//        if (phInter != nil && phInter?.length > 0)
//        {
//            if (self.responds(to: #selector(UIView.snapshotView(afterScreenUpdates:))))
//            {
//                let paragraph = NSMutableParagraphStyle()
//                paragraph.alignment = self.textAlignment
//                let width = CViewWidth(self)
//                let rect = CGRect(x: 5, y: 8 + self.contentInset.top, width: width - self.contentInset.left, height: CViewHeight(self) - self.contentInset.top)
//                
//                phInter?.draw(in: rect, withAttributes: [NSAttributedStringKey.font:self.font!, NSAttributedStringKey.foregroundColor:phColor!, NSAttributedStringKey.paragraphStyle:paragraph])
//            }
//            else
//            {
//                phColor?.set()
//                
//                let rect = CGRect(x: 8.0, y: 8.0, width: CViewWidth(self) - 16.0, height: CViewHeight(self) - 16.0)
//                phInter?.draw(in: rect, withAttributes: [NSAttributedStringKey.font:self.font!])
//            }
//        }
//        
//    }
    
    
    
    
    //MARK:-
    //MARK:- ObserveValueForKeyPath
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
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
