//
//  ExtensionUITextField.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 13/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

// TODO :- Delegate Issue

// MARK: - Extension of UITextField For UITextField's placeholder Color.
extension UITextField {

  /// Placeholder Color of UITextField , as it is @IBInspectable so you can directlly set placeholder color of UITextField From Interface Builder , No need to write any number of Lines.
  @IBInspectable var placeholderColor:UIColor?  {

    get  {
      return self.placeholderColor
    } set {

      if let newValue = newValue {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "" , attributes: [NSAttributedString.Key.foregroundColor:newValue])
      }
    }
  }

}


// MARK: - Extension of UITextField For Adding max length For UITextField.
private var __maxLengths = [UITextField: Int]()
extension UITextField {
  @IBInspectable var maxLength: Int {
    get {
      guard let l = __maxLengths[self] else {
        return 150 // (global default-limit. or just, Int.max)
      }
      return l
    }
    set {
      __maxLengths[self] = newValue
      addTarget(self, action: #selector(fix), for: .editingChanged)
    }
  }
  @objc func fix(textField: UITextField) {
    textField.text = String(textField.text!.prefix(maxLength))
  }
}

// MARK: - Extension of UITextField For Adding Left & Right View For UITextField.
extension UITextField {

  override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    guard inputView != nil else { return super.canPerformAction(action, withSender: sender) }

    return action == #selector(UIResponderStandardEditActions.paste(_:)) ?
    false : super.canPerformAction(action, withSender: sender)
  }

  /// This method is used to add a leftView of UITextField.
  ///
  /// - Parameters:
  ///   - strImgName: String value - Pass the Image name.
  ///   - leftPadding: CGFloat value - (Optional - so you can pass nil if you don't want any spacing from left side) OR pass how much spacing you want from left side.
  func addLeftImageAsLeftView(strImgName:String? , leftPadding:CGFloat?) {

    let leftView = UIImageView(image: UIImage(named: strImgName ?? ""))

    leftView.frame = CGRect(x: 0.0, y: 0.0, width: (((leftView.image?.size.width) ?? 0.0) + (leftPadding ?? 0.0)), height: ((leftView.image?.size.height ?? 0.0)))

    leftView.contentMode = .center

    self.leftViewMode = .always
    self.leftView = leftView
  }

  /// This method is used to add a rightView of UITextField.
  ///
  /// - Parameters:
  ///   - strImgName: String value - Pass the Image name.
  ///   - rightPadding: CGFloat value - (Optional - so you can pass nil if you don't want any spacing from right side) OR pass how much spacing you want from right side.
  func addRightImageAsRightView(strImgName:String? , rightPadding:CGFloat?) {

    let rightView = UIImageView(image: UIImage(named: strImgName ?? ""))
    rightView.tintColor = .white
    rightView.tintColorDidChange()
    rightView.contentMode = .scaleAspectFit
    if rightPadding == 12 {
      rightView.image?.withRenderingMode(.alwaysTemplate)
      rightView.tintColor = UIColor.init(hexString: "#B2B2B2")
    }

    rightView.frame = CGRect(x: 0.0, y: 0.0, width: (((rightView.image?.size.width) ?? 0.0) + (rightPadding ?? 0.0)), height: ((rightView.image?.size.height ?? 0.0)))
    rightView.contentMode = .center

    self.rightViewMode = .always
    self.rightView = rightView
  }

}

typealias selectedDateHandler = ((Date) -> ())

// MARK: - Extension of UITextField For DatePicker as UITextField's inputView.
extension UITextField {

  /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
  fileprivate struct AssociatedObjectKey {

    static var txtFieldDatePicker = "txtFieldDatePicker"
    static var datePickerDateFormatter = "datePickerDateFormatter"
    static var selectedDateHandler = "selectedDateHandler"
    static var defaultDate = "defaultDate"
    static var isPrefilledDate = "isPrefilledDate"
    static var strDateSelected = "strDateSelected"
  }

  /// A Computed Property of UIDatePicker , If its already in memory then return it OR not then create new one and store it in memory reference.
  fileprivate var txtFieldDatePicker:UIDatePicker? {

    if let txtFieldDatePicker = objc_getAssociatedObject(self, &AssociatedObjectKey.txtFieldDatePicker) as? UIDatePicker {

      return txtFieldDatePicker
    } else {
      return self.addDatePicker()
    }
  }

  public var strDateSelected: String? {

    get {
      return objc_getAssociatedObject(self, &AssociatedObjectKey.strDateSelected) as? String ?? ""
    }
    set {
      var propertyVal : String = ""
      if let value = newValue {
        propertyVal = value
      }
      dPrint("newValue == \(propertyVal)")
      objc_setAssociatedObject(self, &AssociatedObjectKey.strDateSelected, propertyVal, .OBJC_ASSOCIATION_RETAIN)
    }
  }


  /// A Private method used to create a UIDatePicker and store it in a memory reference.
  ///
  /// - Returns: return a newly created UIDatePicker.
  private func addDatePicker() -> UIDatePicker {

    let txtFieldDatePicker = UIDatePicker()
    self.inputView = txtFieldDatePicker
    txtFieldDatePicker.addTarget(self, action: #selector(self.handleDateSelection(sender:)), for: .valueChanged)

    objc_setAssociatedObject(self, &AssociatedObjectKey.txtFieldDatePicker, txtFieldDatePicker, .OBJC_ASSOCIATION_RETAIN)

    self.inputAccessoryView = self.addToolBar()
    self.tintColor = .clear

    return txtFieldDatePicker
  }

  /// A Computed Property of DateFormatter , If its already in memory then return it OR not then create new one and store it in memory reference.
  fileprivate var datePickerDateFormatter:DateFormatter? {

    if let datePickerDateFormatter = objc_getAssociatedObject(self, &AssociatedObjectKey.datePickerDateFormatter) as? DateFormatter {

      return datePickerDateFormatter
    } else {
      return self.addDatePickerDateFormatter()
    }
  }

  /// A Private methos used to create a DateFormatter and store it in a memory reference.
  ///
  /// - Returns: return a newly created DateFormatter.
  private func addDatePickerDateFormatter() -> DateFormatter {

    let datePickerDateFormatter = DateFormatter()

    objc_setAssociatedObject(self, &AssociatedObjectKey.datePickerDateFormatter, datePickerDateFormatter, .OBJC_ASSOCIATION_RETAIN)

    return datePickerDateFormatter
  }

  /// A Private method used to handle the date selection event everytime when value changes from UIDatePicker.
  ///
  /// - Parameter sender: UIDatePicker - helps to trach the selected date from UIDatePicker
  @objc private func handleDateSelection(sender:UIDatePicker) {

    self.strDateSelected = self.datePickerDateFormatter?.string(from: sender.date)
    objc_setAssociatedObject(self, &AssociatedObjectKey.defaultDate, sender.date, .OBJC_ASSOCIATION_RETAIN)

    if let selectedDateHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.selectedDateHandler) as? selectedDateHandler {
      selectedDateHandler(sender.date)
    }
  }

  /// This method is used to set the UIDatePickerMode.
  ///
  /// - Parameter mode: Pass the value of Enum(UIDatePickerMode).
  func setDatePickerMode(mode:UIDatePicker.Mode) {
    self.txtFieldDatePicker?.datePickerMode = mode
  }

  /// This method is used to set the maximumDate of UIDatePicker.
  ///
  /// - Parameter maxDate: Pass the maximumDate you want to see in UIDatePicker.
  func setMaximumDate(maxDate:Date) {
    self.txtFieldDatePicker?.maximumDate = maxDate
  }

  /// This method is used to set the minimumDate of UIDatePicker.
  ///
  /// - Parameter minDate: Pass the minimumDate you want to see in UIDatePicker.
  func setMinimumDate(minDate:Date) {
    self.txtFieldDatePicker?.minimumDate = minDate
  }

  /// This method is used to set the (DateFormatter.Style).
  ///
  /// - Parameter dateStyle: Pass the value of Enum(DateFormatter.Style).
  func setDateFormatterStyle(dateStyle:DateFormatter.Style) {
    self.datePickerDateFormatter?.dateStyle = dateStyle
  }

  /// This method is used to enable the UIDatePicker into UITextField. Before using this method you can use another methods for set the UIDatePickerMode , maximumDate , minimumDate & dateFormat) , it will help you to see proper UIDatePickerMode , maximumDate , minimumDate etc into UIDatePicker.
  ///
  /// - Parameters:
  ///   - dateFormate: A String Value used to set the dateFormat you want.
  ///   - defaultDate: A Date? (optional - you can pass nil if you don't want any defualt value) Or pass proper date which will behave like it is already selected from UIDatePicker(you can see this date into UIDatePicker First when UIDatePicker present).
  ///   - isPrefilledDate: A Bool value will help you to prefilled the UITextField with Default Value when UIDatePicker Present.
  ///   - selectedDateHandler: A Handler Block returns a selected date.
  func setDatePickerWithDateFormate(dateFormate:String , defaultDate:Date? , isPrefilledDate:Bool , selectedDateHandler: @escaping selectedDateHandler) {

    self.inputView = self.txtFieldDatePicker
    self.setDateFormate(dateFormat: dateFormate)

    objc_setAssociatedObject(self, &AssociatedObjectKey.selectedDateHandler, selectedDateHandler, .OBJC_ASSOCIATION_RETAIN)
    objc_setAssociatedObject(self, &AssociatedObjectKey.defaultDate, defaultDate, .OBJC_ASSOCIATION_RETAIN)
    objc_setAssociatedObject(self, &AssociatedObjectKey.isPrefilledDate, isPrefilledDate, .OBJC_ASSOCIATION_RETAIN)

    self.delegate = self
  }

  /// A Private method is used to set the dateFormat of UIDatePicker.
  ///
  /// - Parameter dateFormat: A String Value used to set the dateFormatof UIDatePicker.
  private func setDateFormate(dateFormat:String) {
    self.datePickerDateFormatter?.dateFormat = dateFormat
  }

  /// A fileprivate method is used to add a UIToolbar above UIDatePicker. This UIToolbar contain only one UIBarButtonItem(Done).
  ///
  /// - Returns: return newly created UIToolbar
  fileprivate func addToolBar() -> UIToolbar {

    let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: 44.0))

    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.btnDoneTapped(sender:)))

    toolBar.setItems([flexibleSpace , btnDone], animated: true)

    return toolBar
  }

  /// A Private method used to handle the touch event of button Done(A UIToolbar Button).
  ///
  /// - Parameter sender: UIBarButtonItem
  @objc private func btnDoneTapped(sender:UIBarButtonItem) {

    self.resignFirstResponder()

    if let _ = self.inputView as? UIDatePicker {
      self.text = self.strDateSelected
      if let selectedDateHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.selectedDateHandler) as? selectedDateHandler {
        selectedDateHandler((self.datePickerDateFormatter?.date(from: self.strDateSelected!))!)
      }
    }
  }
}

typealias selectedPickerDataHandler = ((_ text:String , _ row:Int , _ component:Int) -> ())

extension UITextField : UIPickerViewDataSource , UIPickerViewDelegate {

  fileprivate struct AssociatedObjectKeyTwo {
    static var txtFieldPickerView = "txtFieldPickerView"
    static var selectedPickerDataHandler = "selectedPickerDataHandler"
    static var arrPickerData = "arrPickerData"
  }

  fileprivate var txtFieldPickerView:UIPickerView? {

    if let txtFieldPickerView = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.txtFieldPickerView) as? UIPickerView {
      return txtFieldPickerView
    } else {
      return self.addPickerView()
    }
  }

  private func addPickerView() -> UIPickerView {

    let txtFieldPickerView = UIPickerView()

    txtFieldPickerView.dataSource  = self
    txtFieldPickerView.delegate  = self

    self.inputView = txtFieldPickerView

    objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.txtFieldPickerView, txtFieldPickerView, .OBJC_ASSOCIATION_RETAIN)
    self.inputAccessoryView = self.addToolBar()
    self.tintColor = .clear

    return txtFieldPickerView
  }

  fileprivate var arrPickerData:[Any]? {

    get {

      if let arrPickerData = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.arrPickerData) as? [Any] {
        return arrPickerData
      }
      return nil
    }
  }

  func setPickerData(arrPickerData:[Any] , selectedPickerDataHandler: @escaping selectedPickerDataHandler , defaultPlaceholder:String?) {

    self.inputView = txtFieldPickerView

    self.setUpArrPickerData(arrPickerData: arrPickerData, defaultPlaceholder: defaultPlaceholder)
    objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler, selectedPickerDataHandler, .OBJC_ASSOCIATION_RETAIN)

    self.delegate = self
  }

  private func setUpArrPickerData(arrPickerData:[Any] , defaultPlaceholder:String?) {

    var arrPickerData = arrPickerData

    if defaultPlaceholder != nil {
      arrPickerData.insert(defaultPlaceholder!, at: 0)
    } else {
      if self.placeholder != nil {
        arrPickerData.insert(self.placeholder!, at: 0)
      }
    }

    objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.arrPickerData, arrPickerData, .OBJC_ASSOCIATION_RETAIN)

    txtFieldPickerView?.reloadAllComponents()
  }

  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrPickerData?.count ?? 0
  }

  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    return "\(arrPickerData?[row] ?? "")"
  }

  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    self.text = "\(arrPickerData?[row] ?? "")"

    if let selectedPickerDataHandler = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler) as? selectedPickerDataHandler {

      selectedPickerDataHandler(self.text ?? "", row, component)
    }
  }
}

extension UITextField : UITextFieldDelegate {

  /// Delegate method of UITextFieldDelegate.
  public func textFieldDidBeginEditing(_ textField: UITextField) {

    if let _ = self.inputView as? UIDatePicker {

      if let isPrefilledDate = objc_getAssociatedObject(self, &AssociatedObjectKey.isPrefilledDate) as? Bool {

        if isPrefilledDate {

          if let defaultDate = objc_getAssociatedObject(self, &AssociatedObjectKey.defaultDate) as? Date {
            self.txtFieldDatePicker?.date = defaultDate
            self.strDateSelected = self.datePickerDateFormatter?.string(from: defaultDate)

          } else{
            self.strDateSelected = self.datePickerDateFormatter?.string(from: Date())
          }
        }
      }

    } else if let _ = self.inputView as? UIPickerView {

      if let arrPickerData = arrPickerData {

        if let index = arrPickerData.index(where: {($0 as? String) == textField.text}) {

          self.text = "\(arrPickerData[index])"
          txtFieldPickerView?.selectRow(index, inComponent: 0, animated: false)
          if let selectedPickerDataHandler = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler) as? selectedPickerDataHandler {

            selectedPickerDataHandler(self.text ?? "", index, 0)
          }
        } else {
          self.text = "\(arrPickerData[0])"
          txtFieldPickerView?.selectRow(0, inComponent: 0, animated: false)
          if let selectedPickerDataHandler = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler) as? selectedPickerDataHandler {
            selectedPickerDataHandler(self.text ?? "", 0, 0)
          }
        }
      }
    }
  }

  private class Label: UILabel {
    private var _textColor = UIColor.lightGray
    override var textColor: UIColor! {
      set { super.textColor = _textColor }
      get { return _textColor }
    }

    init(label: UILabel, textColor: UIColor = .lightGray) {
      _textColor = textColor
      super.init(frame: label.frame)
      self.text = label.text
      self.font = label.font
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
  }


  private class ClearButtonImage {
    static private var _image: UIImage?
    static private var semaphore = DispatchSemaphore(value: 1)
    static func getImage(closure: @escaping (UIImage?)->()) {
      DispatchQueue.global(qos: .userInteractive).async {
        semaphore.wait()
        DispatchQueue.main.async {
          if let image = _image { closure(image); semaphore.signal(); return }
          guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
          let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
          window.rootViewController?.view.addSubview(searchBar)
          searchBar.text = "txt"
          searchBar.layoutIfNeeded()
          _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
          closure(_image)
          searchBar.removeFromSuperview()
          semaphore.signal()
        }
      }
    }
  }

  func setClearButton(color: UIColor) {
    ClearButtonImage.getImage { [weak self] image in
      guard   let image = image,
              let button = self?.getClearButton() else { return }
      button.imageView?.tintColor = color
      button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    }
  }

  var placeholderLabel: UILabel? { return value(forKey: "placeholderLabel") as? UILabel }

  func setPlaceholder(textColor: UIColor) {
    guard let placeholderLabel = placeholderLabel else { return }
    let label = Label(label: placeholderLabel, textColor: textColor)
    setValue(label, forKey: "placeholderLabel")
  }

  func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}

extension UISearchBar {

  func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
  func set(textColor: UIColor) { if let textField = getTextField() { textField.textColor = textColor } }
  func setPlaceholder(textColor: UIColor) { getTextField()?.setPlaceholder(textColor: textColor) }
  func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }

  func setTextField(color: UIColor) {
    guard let textField = getTextField() else { return }
    switch searchBarStyle {
      case .minimal:
        textField.layer.backgroundColor = color.cgColor
        textField.layer.cornerRadius = 6
      case .prominent, .default: textField.backgroundColor = color
      @unknown default: break
    }
  }

  func setSearchImage(color: UIColor) {
    guard let imageView = getTextField()?.leftView as? UIImageView else { return }
    imageView.tintColor = color
    imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
  }
}

extension UITextField{

  func checkAmount(_ text:String,range:NSRange) -> Bool{

    let textFiled: NSString = self.text! as NSString
    let resultString = textFiled.replacingCharacters(in: range, with: text)

    let textArray = resultString.components(separatedBy: ".")

    let firstString = textArray.first
    if firstString!.count > 6{
      return false
    }

    if text == "0" || text == "."{
      if self.text!.count == 0 {
        return false
      }
    }

    //Check the specific textField
    if textArray.count > 2 { //Allow only one "."
      return false
    }
    if textArray.count == 2 {
      let lastString = textArray.last
      if lastString!.count > 2 { //Check number of decimal places
        return false
      }
    }
    return true
  }
}

extension UITextField {
  func enablePasswordToggle() {
    let button = UIButton(type: .custom)
    setPasswordToggleImage(button)

    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
    button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(24), height: CGFloat(24))
    button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
    self.rightView = button
    self.rightViewMode = .always
  }

  func setPasswordToggleImage(_ button: UIButton) {
    if isSecureTextEntry {
      let origImage = IMAGES.ICN_EYE_CLOSE
      button.setImage(origImage, for: .normal)
    } else {
      let origImage = IMAGES.ICN_EYE_OPEN
      button.setImage(origImage, for: .normal)
    }
  }

  @objc func togglePasswordView(_ sender: Any) {
    self.isSecureTextEntry = !self.isSecureTextEntry
    setPasswordToggleImage(sender as! UIButton)
  }
}

extension NSMutableAttributedString {

  @discardableResult func bold(_ text: String, withTextField textField: UITextField) -> NSMutableAttributedString {

    //generate the bold font
    guard let textFont = textField.font else { return  NSMutableAttributedString(string: "") }
    var font: UIFont = UIFont(name: textFont.fontName , size: textFont.pointSize)!
    font = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold) ?? font.fontDescriptor, size: font.pointSize)

    //generate attributes
    let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
    let boldString = NSMutableAttributedString(string:text, attributes: attrs)

    //append the attributed text
    append(boldString)

    return self
  }

  @discardableResult func customFont(_ text: String, withTextField textField: UITextField, andFontName name: String) -> NSMutableAttributedString {

    //generate the bold font
    guard let textFont = textField.font else { return  NSMutableAttributedString(string: "") }
    let font: UIFont = UIFont(name: name , size: textFont.pointSize)!

    //generate attributes
    let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
    let boldString = NSMutableAttributedString(string:text, attributes: attrs)

    //append the attributed text
    append(boldString)

    return self
  }
}

@IBDesignable
class AfterOneSecondTextField: UITextField {

  @IBInspectable var delayValue : Double = 1.0
  var timer:Timer?

  var actionClosure : (()->Void)?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.addTarget(self, action: #selector(changedTextFieldValue), for: .editingChanged)
  }

  @objc func changedTextFieldValue(){
    timer?.invalidate()
    //setup timer
    timer = Timer.scheduledTimer(timeInterval: delayValue, target: self, selector: #selector(self.executeAction), userInfo: nil, repeats: false)
  }

  @objc func executeAction(){
    actionClosure?()
  }
}
