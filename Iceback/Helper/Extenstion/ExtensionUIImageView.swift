//
//  ExtensionUIImageView.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    
    
    
    
    func loadGif(name: String) {
        
        DispatchQueue.global().async {

        }
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func setOriginal() {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.image = templateImage
    }
    
    
    
    //The key is a static variable, hidden in a private struct to keep the scope clean
    private struct AssociatedKeys {
        static var completionBlock = "completionBlockAssociatedKey"
    }
    
    //Closure can not be directly stored as associated objects, as associated objects must be objects
    //So wrap the closure in a class
    private class ClosureWrapper {
        fileprivate private(set) var closure: (() -> ())?
        
        init(closure: (() -> ())?) {
            self.closure = closure
        }
    }
    
    //Wrap or extract the closure from the wrapper class in computed property's accessors
    var completionBlock: (() -> ())? {
        get {
            let cw = objc_getAssociatedObject(self, &AssociatedKeys.completionBlock) as? ClosureWrapper
            return cw?.closure
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.completionBlock,
                ClosureWrapper(closure: newValue),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    public func startAnimatingWithCompletionBlock(block: @escaping (() -> ())) {
        guard let animationImages = self.animationImages else {
            block()
            return
        }
        self.completionBlock = block
        
        var cgImages = [CGImage]()
        for image in animationImages {
            if let cgImage = image.cgImage {
                cgImages.append(cgImage)
            }
        }
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "contents"
        animation.values = cgImages
        animation.repeatCount = Float(self.animationRepeatCount)
        animation.duration = self.animationDuration
        animation.delegate = self
        self.layer.add(animation, forKey: nil)
    }
    


}

extension UIImageView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let block = self.completionBlock, let anim = anim as? CAKeyframeAnimation, anim.keyPath == "contents" {
            block()
            self.completionBlock = nil
        }
    }
}
