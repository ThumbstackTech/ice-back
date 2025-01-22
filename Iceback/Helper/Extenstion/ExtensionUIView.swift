//
//  ExtensionUIView.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension of UIView For giving the round shape to any UIView.
extension UIView {
    
    /// This method is used to giving the round shape to any UIView
    func roundView() {
        self.layer.cornerRadius = (CViewHeight(self)/2.0)
        self.layer.masksToBounds = true
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
}

// MARK: - Extension of UIView For NSLayoutConstraint.
extension UIView {
  
  var heightOFConstraint: NSLayoutConstraint? {
    get {
      return constraints.first(where: {
        $0.firstAttribute == .height && $0.relation == .equal
      })
    }
    set { setNeedsLayout() }
  }
  
  var widthOFConstraint: NSLayoutConstraint? {
    get {
      return constraints.first(where: {
        $0.firstAttribute == .width && $0.relation == .equal
      })
    }
    set { setNeedsLayout() }
  }
  
}
// MARK: - Extension of UIView For getting any UIView from XIB.
extension UIView {
    
    /// This static Computed property is used to getting any UIView from XIB. This Computed property returns UIView? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("UIView!") then application will crash.
    static var viewFromXib:UIView? {
        return self.viewWithNibName(strViewName: "\(self)")
    }
    
    /// This static method is used to getting any UIView with specific name.
    ///
    /// - Parameter strViewName: A String Value of UIView.
    /// - Returns: This Method returns UIView? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("UIView!") then application will crash.
    static func viewWithNibName(strViewName:String) -> UIView? {
        
        guard let view = CBundle.loadNibNamed(strViewName, owner: self, options: nil)?[0] as? UIView else { return nil }
        
        return view
    }
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
                //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
}

// MARK: - Extension of UIView For removing all the subviews of UIView.
extension UIView {
    
    /// This method is used for removing all the subviews of UIView.
    func removeAllSubviews() {
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// This method is used for removing all the subviews from InterfaceBuilder for perticular tag.
    ///
    /// - Parameter tag: Pass the tag value of UIView , and that UIView and its all subviews will remove from InterfaceBuilder.
    func removeAllSubviewsOfTag(tag:Int) {
        
        for subview in self.subviews {
            if subview.tag == tag {
                subview.removeFromSuperview()
            }
        }
    }
    
}

// MARK: - Extension of UIView For draw a shadowView of it.
extension UIView {
    
    /// This method is used to draw a shadowView for perticular UIView.
    ///
    /// - Parameters:
    ///   - color: Pass the UIColor that you want to see as shadowColor.
    ///   - shadowOffset: Pass the CGSize value for how much far you want shadowView from parentView.
    ///   - shadowRadius: Pass the CGFloat value for how much length(Blur Spreadness) you want in shadowView.
    func shadow(color:UIColor , shadowOffset:CGSize , shadowRadius:CGFloat, isAspect: Bool = false) {

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.5
        var boundsView = self.bounds
        if isAspect {
            
            boundsView = CGRect(x: boundsView.minX, y: boundsView.minY, width: CScreenWidth-20, height: CViewHeight(self))
        }
        self.layer.shadowPath = UIBezierPath(rect: boundsView).cgPath
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = CScreen.scale
    }
}

// MARK: - Extension of UIView For adding the border to UIView at any position.
extension UIView {
    
    /// A Enum UIPosition Describes the Different Postions.
    ///
    /// - top: Will add border at top of The UIView.
    /// - left: Will add border at left of The UIView.
    /// - bottom: Will add border at bottom of The UIView.
    /// - right: Will add border at right of The UIView.
    enum UIPosition {
        case top
        case left
        case bottom
        case right
    }
    
    /// This method is used to add the border to perticular UIView at any position.
    ///
    /// - Parameters:
    ///   - position: Pass the enum value of UIPosition , according to the enum value it will add the border for that position.
    ///   - color: Pass the UIColor which you want to see in a border.
    ///   - width: CGFloat value - (Optional - if you are passing nil then method will automatically set this value same as Parent's width) OR pass how much width you want for border. For top and bottom UIPosition you can pass nil.
    ///   - height: CGFloat value - (Optional - if you are passing nil then method will automatically set this value same as Parent's height) OR pass how much height you want for border. For left and right UIPosition you can pass nil.
    func addBorder(position:UIPosition , color:UIColor , width:CGFloat? , height:CGFloat?) {
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        
        switch position {
            
        case .top:
            
            borderLayer.frame = CGRect(origin: .zero, size: CGSize(width: (width ?? CViewWidth(self)), height: (height ?? 0.0)))
            
        case .left:
            
            borderLayer.frame = CGRect(origin: .zero, size: CGSize(width: (width ?? 0.0), height: (height ?? CViewHeight(self))))
            
        case .bottom:
            
            borderLayer.frame = CGRect(origin: CGPoint(x: 0.0, y: (CViewHeight(self) - (height ?? 0.0))), size: CGSize(width: (width ?? CViewWidth(self)), height: (height ?? 0.0)))
            
        case .right:
            
            borderLayer.frame = CGRect(origin: CGPoint(x: (CViewWidth(self) - (width ?? 0.0)), y: 0.0), size: CGSize(width: (width ?? 0.0), height: (height ?? CViewHeight(self))))
            
        }
        
        self.layer.addSublayer(borderLayer)
    }
}

typealias tapInsideViewHandler = (() -> ())

extension UIView {
    
    private struct AssociatedObjectKey {
        static var tapInsideViewHandler = "tapInsideViewHandler"
    }
    
    func tapInsideViewHandler(tapInsideViewHandler: @escaping tapInsideViewHandler) {
        
        self.isUserInteractionEnabled = true
        
        if let tapGesture = self.gestureRecognizers?.first(where: {$0.isEqual(UITapGestureRecognizer.self)}) as? UITapGestureRecognizer {
            
            tapGesture.addTarget(self, action: #selector(handleTapGesture(sender:)))
            
        } else {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:))))
        }
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.tapInsideViewHandler, tapInsideViewHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc private func handleTapGesture(sender:UITapGestureRecognizer) {
        
        if let tapInsideViewHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.tapInsideViewHandler) as? tapInsideViewHandler {
            
            tapInsideViewHandler()
        }
    }
}

extension UIView {

  var snapshotImage : UIImage? {

    var snapShotImage:UIImage?

    UIGraphicsBeginImageContext(self.CViewSize)

    if let context = UIGraphicsGetCurrentContext() {

      self.layer.render(in: context)

      if let image = UIGraphicsGetImageFromCurrentImageContext() {
        UIGraphicsEndImageContext()
        snapShotImage = image
      }
    }
    return snapShotImage
  }
}

extension UIView {

    func addTopBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        border.clipsToBounds = false
        
        self.addSubview(border)
       
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.height,
            multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.top,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.leading,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.trailing,
            multiplier: 1, constant: 0))
    }

    func addBottomBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
      
        border.clipsToBounds = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.height,
            multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.leading,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.trailing,
            multiplier: 1, constant: 0))
    }

    func addLeftBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        border.clipsToBounds = false
       
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.width,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.width,
            multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.leading,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.top,
            multiplier: 1, constant: 0))
    }

    func addRightBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        border.clipsToBounds = false
      
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.width,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.width,
            multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.trailing,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.top,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.top,
            multiplier: 1, constant: 0))
    }
}

extension UIView {
  enum dashedOrientation {
    case horizontal
    case vertical
  }

  func makeDashedBorderLine(strokeColor: CGColor, lineWidth: Int, spacing: Int) {
    let orientation: dashedOrientation
    let path = CGMutablePath()
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineWidth = 1
    shapeLayer.strokeColor = strokeColor
    shapeLayer.lineDashPattern = [NSNumber(value: lineWidth), NSNumber(value: spacing)]
    orientation = .horizontal
    if orientation == .vertical {
      path.addLines(between: [CGPoint(x: bounds.midX, y: bounds.minY),
                              CGPoint(x: bounds.midX, y: bounds.maxY)])
    } else if orientation == .horizontal {
      path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.midY),
                              CGPoint(x: bounds.maxX, y: bounds.midY)])
    }
    shapeLayer.path = path
    layer.addSublayer(shapeLayer)
  }

  func addLineDashedStroke(radius: CGFloat) -> CALayer {
    let borderLayer = CAShapeLayer()

    borderLayer.strokeColor = UIColor.appBorder.cgColor
    borderLayer.lineDashPattern = [4, 4]
    borderLayer.frame = bounds
    borderLayer.fillColor = UIColor(red: 64/255, green: 197/255, blue: 229/255, alpha: 0.1).cgColor
    borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

    layer.addSublayer(borderLayer)
    return borderLayer
  }
}

extension UIView {

    var CViewSize:CGSize {
        return self.frame.size
    }
        
    func CViewSetSize(width:CGFloat , height:CGFloat) {
        CViewSetWidth(width: width)
        CViewSetHeight(height: height)
    }

    func CViewSetOrigin(x:CGFloat , y:CGFloat) {
        CViewSetX(x: x)
        CViewSetY(y: y)
    }

    func CViewSetWidth(width:CGFloat) {
        self.frame.size.width = width
    }

    func CViewSetHeight(height:CGFloat) {
        self.frame.size.height = height
    }

    func CViewSetX(x:CGFloat) {
        self.frame.origin.x = x
    }

    func CViewSetY(y:CGFloat) {
        self.frame.origin.y = y
    }

    func CViewSetCenter(x:CGFloat , y:CGFloat) {
        CViewSetCenterX(x: x)
        CViewSetCenterY(y: y)
    }

    func CViewSetCenterX(x:CGFloat) {
        self.center.x = x
    }

    func CViewSetCenterY(y:CGFloat) {
        self.center.y = y
    }
}

extension UIView {
    
    func setupGradientLayer(_ height: CGFloat = CScreenHeight, _ width: CGFloat = CScreenWidth) {
        // Initialize Gradient Layer
        let gradientLayer = CAGradientLayer()
        let gradientDefaultColors: [CGColor] = [UIColor(hexString: "#00B4DB").cgColor, UIColor(hexString: "#6C40E9").cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 1)
        gradientLayer.colors = gradientDefaultColors
        self.layer.addSublayer(gradientLayer)
    }
}

extension UIView {
    
    func roundedTopLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedTopLeftAndRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedTopRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottomLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft],
                                     cornerRadii: CGSize(width: 50, height: 50))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottomRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedAllCorner(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight , .topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var cardView: Bool = true
    
    override func layoutSubviews() {
        
        if cardView {
            
            layer.cornerRadius = cornerRadius
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            
            layer.masksToBounds = false
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
            layer.shadowOpacity = Float(shadowOpacity)
            layer.shadowPath = shadowPath.cgPath
            
            if self.tag == 100 {
                //Corner Radius
                self.layer.cornerRadius = self.frame.size.height / 2
                self.clipsToBounds = true
            }
        }
    }
    
    //    MARK: - Gradient
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isDigonal: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ] //, therdColor.cgColor
        
        if isDigonal {
            
            layer.startPoint = CGPoint(x: 0.0, y: 1.0)
            layer.endPoint = CGPoint(x: 1.0, y: 0.0)
            
        } else if (horizontalGradient) {
            
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        
        if cardView {
            layer.cornerRadius = cornerRadius
        }
    }
}

extension UIView{
    enum RoundCornersAt {
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
    //multiple corners using CACornerMask
    func roundCorners(corners: [RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
}
