//
//  ExtensionUIImage.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension of UIImage For Converting UIImage TO Data
extension UIImage {
    
    /// This Method is Used For Converting UIImage TO Data?
    ///
    /// - Parameter compressionQuality: A CGFloat value that indicates how much compressionQuality you want , its optional so you can pass nil.
    /// - Returns: This Method returns Data? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("Data!") then application will crash.
    
    func convertToJPEGData() -> Data? {
        
        return autoreleasepool(invoking: { () -> Data? in
            return self.jpegData(compressionQuality: 0.1)
        })
    }
    
    
        func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }
    
    func imgData(compressionQuality:CGFloat?) -> Data? {
        
        return self.jpegData(compressionQuality: compressionQuality ?? 0.0)
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? nil
    }
    
    func blurImage(radius:CGFloat) -> UIImage? {
        
        guard let cgImage = self.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let affineClampFilter = CIFilter(name: "CIAffineClamp")
        affineClampFilter?.setDefaults()
        affineClampFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let clampedCIImage = affineClampFilter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let exposureAdjustFilter = CIFilter(name: "CIExposureAdjust")
        
        exposureAdjustFilter?.setValue(-1, forKey: kCIInputEVKey)
        exposureAdjustFilter?.setValue(clampedCIImage, forKey: kCIInputImageKey)
        
        guard let exposuredCIImage = exposureAdjustFilter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        
        gaussianBlurFilter?.setValue("\(radius)", forKey: kCIInputRadiusKey)
        gaussianBlurFilter?.setValue(exposuredCIImage, forKey: kCIInputImageKey)
        
        guard let gaussianCIImage = gaussianBlurFilter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let context = CIContext(options: nil)
        
        guard let gaussianCGImage =
            
            context.createCGImage(gaussianCIImage, from: ciImage.extent)
            
            else { return nil }
        
        return UIImage(cgImage: gaussianCGImage)
    }
    
}

/*
 
 Reference :-  https://github.com/bahlo/SwiftGif
 
*/

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: URL) -> UIImage? {
        
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return gif(data: imageData)
    }
    
    public class func gifName(name: String) -> UIImage? {
        
        guard let bundleURL = CBundle.url(forResource: name, withExtension: "gif") else { return nil }
        
        return gif(url: bundleURL)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
               dPrint("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
           dPrint("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
           dPrint("image doesn't exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        
        var a = a
        var b = b
        
        if b == nil || a == nil {
            
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        
        while true {
            
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }
        
        let duration: Int = {
            
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        
        for i in 0..<count {
            
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}

extension UIImage {
    
    public func getThumbnailFromVideo(size: CGFloat) -> UIImage? {
        
        let imageData = self.jpegData(compressionQuality: 1.0)
        
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: size] as CFDictionary
        
        guard let source = CGImageSourceCreateWithData(imageData! as CFData, nil) else { return nil }
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }
        
        return UIImage(cgImage: imageReference)
        
    }
    
    public func getThumbnail() -> UIImage? {
        
        let imageData = self.jpegData(compressionQuality: 1.0)
        
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 200] as CFDictionary
        
        guard let source = CGImageSourceCreateWithData(imageData! as CFData, nil) else { return nil }
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }
        
        return UIImage(cgImage: imageReference)
        
    }
    
    func rotated(byDegrees radians: Float) -> UIImage {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func cropToRect(_ rect: CGRect) -> UIImage {
        let imageRef = self.cgImage?.cropping(to: rect)
        let croppedImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
    
    func cropToBounds(width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: self.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = contextSize.width
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = contextSize.height
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
    
    func cropImage(toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
    func setCropAspectRect(aspect: String) -> UIImage {
        
        var aspectRatioWidth: CGFloat = CGFloat.zero
        var aspectRatioHeight: CGFloat = CGFloat.zero
        
        let elements = aspect.components(separatedBy: ":")
        aspectRatioWidth = CGFloat(Float(elements.first!)!)
        aspectRatioHeight = CGFloat(Float(elements.last!)!)
        
        var size = self.size
        let mW = size.width / aspectRatioWidth
        let mH = size.height / aspectRatioHeight
        
        if (mH < mW) {
            size.width = size.height / aspectRatioHeight * aspectRatioWidth
        }
        else if(mW < mH) {
            size.height = size.width / aspectRatioWidth * aspectRatioHeight
        }
        
        let x = (self.size.width - size.width) / 2
        let y = (self.size.height - size.height) / 2
        
        let rect = CGRect(x:x, y:y, width: size.width, height: size.height)
        
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
        
    }
    
    
}
