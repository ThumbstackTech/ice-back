//
//  ExtensionUIButton.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

var kActionHandler: UInt8 = 0

extension UIButton
{
    typealias ClosureActionHandler = @convention(block) (_ sender: UIButton) -> Void
    
    func set(normalTitle nTitle:String) -> Void {
        self.setTitle(nTitle, for: UIControl.State())
    }
    
    func set(highlightedTitle hTitle:String) -> Void {
        self.setTitle(hTitle, for: .highlighted)
    }
    
    func set(selectedTitle sTitle:String) -> Void {
        self.setTitle(sTitle, for: .selected)
    }
    
    func set(normalTitle nTitle:String, highlightedTitle:String) -> Void {
        self.set(normalTitle: nTitle)
        self.set(highlightedTitle: highlightedTitle)
    }
    
    func set(normalTitle nTitle:String, selectedTitle:String) -> Void {
        self.set(normalTitle: nTitle)
        self.set(selectedTitle: selectedTitle)
    }
    
    func set(normalTitle nTitle:String, highlightedTitle:String, selectedTitle:String) -> Void {
        self.set(normalTitle: nTitle)
        self.set(highlightedTitle: highlightedTitle)
        self.set(selectedTitle: selectedTitle)
    }
    
    
    
    
    
    
    func set(normalImage nImage:String) -> Void {
        self.setImage(UIImage(named: nImage), for: UIControl.State())
    }
    
    func set(highlightedImage hImage:String) -> Void {
        self.setImage(UIImage(named: hImage), for: .highlighted)
    }
    
    func set(selectedImage sImage:String) -> Void {
        self.setImage(UIImage(named: sImage), for: .selected)
    }
    
    func set(normalImage nImage:String, highlightedImage:String) -> Void {
        self.set(normalImage: nImage)
        self.set(highlightedImage: highlightedImage)
    }
    
    func set(normalImage nImage:String, selectedImage:String) -> Void {
        self.set(normalImage: nImage)
        self.set(selectedImage: selectedImage)
    }
    
    func set(normalImage nImage:String, highlightedImage:String, selectedImage:String) -> Void {
        self.set(normalImage: nImage)
        self.set(highlightedImage: highlightedImage)
        self.set(selectedImage: selectedImage)
    }
    
    
    
    func touchUpInsideClicked(_ handler: @escaping ClosureActionHandler)
    {
        self.set(object: unsafeBitCast(handler, to: AnyObject.self), forKey: &kActionHandler)
        self.addTarget(self, action: #selector(touchUpInsideFired(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func touchUpInsideFired(_ sender: UIButton)
    {
        let handler = unsafeBitCast(self.object(forKey: &kActionHandler), to: ClosureActionHandler.self)
        handler(sender)
    }
    
    
    func addRightIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.tintColorDidChange()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        let length = CGFloat(15)
        titleEdgeInsets.right += length
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    
}


extension UIBarButtonItem
{
    typealias ClosureActionHandler = @convention(block) (_ sender: UIButton) -> Void
    
    func touchUpInsideClicked(_ handler: @escaping ClosureActionHandler)
    {
        self.set(object: unsafeBitCast(handler, to: AnyObject.self), forKey: &kActionHandler)
        self.action = #selector(touchUpInsideFired(_:))
        self.target = self
    }
    
    @objc fileprivate func touchUpInsideFired(_ sender: UIButton)
    {
        let handler = unsafeBitCast(self.object(forKey: &kActionHandler), to: ClosureActionHandler.self)
        handler(sender)
    }
}
