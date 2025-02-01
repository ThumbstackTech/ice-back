//
//  DesignTokens.swift
//  Iceback
//
//  Created by Gourav Joshi on 23/01/25.
//

import Foundation

struct DesignTokens: Decodable {
   var brand: Brand? = Brand()
   var platform: [Platform]? = [Platform]()
   var mode: [Mode]? = [Mode]()
   var font: AppFont? = AppFont()
   var typography: [Typography]? = [Typography]()
   var shadow: [Shadow]? = [Shadow]()
   var borderRadius: [BorderRadius]? = [BorderRadius]()
   var baseUrl: [BaseUrl]? = [BaseUrl]()
   var webSupport: WebSupport? = WebSupport()
}

struct Brand: Decodable {
   var name: String? = String()
   var logoPrimary: String? = String()
   var logoSecondary: String? = String()
}

struct AppColor: Decodable {
   var primaryDark: PrimaryColorDark? = PrimaryColorDark()
   var primaryLight: PrimaryColorLight? = PrimaryColorLight()
   var secondaryLight: SecondaryLight? = SecondaryLight()
   var secondaryDark: SecondaryDark? = SecondaryDark()
   var tertiaryDark: TertiaryDark? = TertiaryDark()
   var tertiaryLight: TertiaryLight? = TertiaryLight()
   var backgroundDark: BackgroundDark? = BackgroundDark()
   var backgroundLight: BackgroundLight? = BackgroundLight()
   var foregroundDark: ForegroundDark? = ForegroundDark()
   var foregroundLight: ForegroundLight? = ForegroundLight()
   var textColorDark: TextColorDark? = TextColorDark()
   var textColorLight: TextColorLight? = TextColorLight()
   var labelColorDark: LabelColorDark? = LabelColorDark()
   var labelColorLight: LabelColorLight? = LabelColorLight()
   var titleColorDark: TitleColorDark? = TitleColorDark()
   var titleColorLight: TitleColorLight? = TitleColorLight()
   var placeholderTextColorDark: PlaceholderColorDark? = PlaceholderColorDark()
   var placeholderTextColorLight: PlaceholderColorLight? = PlaceholderColorLight()
   var buttonTitleDark: ButtonTitleDark? = ButtonTitleDark()
   var buttonTitleLight: ButtonTitleLight? = ButtonTitleLight()
   var borderColorDark: BorderColorDark? = BorderColorDark()
   var borderColorLight: BorderColorLight? = BorderColorLight()
   var gradientDark: [String]? = [String]()
   var gradientLight: [String]? = [String]()
}

struct Mode: Decodable {
   var theme: String? = String()
   var backgroundColor: String? = String()
   var textColor: String? = String()
}

struct AppFont: Decodable {
   var family: String? = String()
   var size: Float? = Float()
   var weight: [String]? = [String]()
}

struct Typography: Decodable {
   var type: String? = String()
   var fontSize: Int? = Int()
   var lineHeight: Float? = Float()
   var fontWeight: String? = String()
}

struct Shadow : Decodable{
   var size: String? = String()
   var value: String? = String()
}

struct BorderRadius: Decodable {
   var border: String? = String()
   var value: Int? = Int()
}

struct BaseUrl: Decodable {
   var server: String? = String()
   var url: String? = String()
}

struct WebSupport: Decodable {
   var aboutUs: String? = String()
   var termsConditions: String? = String()
   var privacyPolicy: String? = String()
}

struct PrimaryColorDark: Decodable {
   var value: String? = String()
   var type: String? = String()
}

struct PrimaryColorLight: Decodable {
   var value: String? = String()
   var type: String? = String()
}

struct SecondaryLight: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct SecondaryDark: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct TertiaryDark: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct TertiaryLight: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct BackgroundDark: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct BackgroundLight: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct ForegroundDark: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct ForegroundLight: Decodable {
   var type: String? = String()
   var value: String? = String()
}

struct TextColorDark: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct TextColorLight: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct LabelColorDark: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct LabelColorLight: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct TitleColorDark: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct TitleColorLight: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct PlaceholderColorDark: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct PlaceholderColorLight: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct ButtonTitleDark: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct ButtonTitleLight: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct BorderColorDark: Decodable {
   var type: String? = String()
   var value: String? =  String()
}

struct BorderColorLight: Decodable {
   var type: String? = String()
   var value: String? =  String()
}


struct Platform: Decodable {
   var type: String? = String()
   var content: Content? = Content()
}

struct Content: Decodable {
   var appColor: AppColor? = AppColor()
}
