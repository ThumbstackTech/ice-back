//
//  DesignTokensConfig.swift
//  Iceback
//
//  Created by Gourav Joshi on 23/01/25.
//

import Foundation
import UIKit

enum Config {
   static let FileName = "DesignTokens"
   static let DirectoryName = "App Theme"

   enum FileType {
      static let JSON = "json"
      static let HTML = "html"
      static let PDF = "pdf"
   }
}

class DesignTokensConfig {
   private func getFilePathForDesignTokens() -> String {
      if let filePath = Bundle.main.path(forResource: Config.FileName, ofType: Config.FileType.JSON) {
         print("filePath = \(filePath)")
         return filePath
      }
      return ""
   }

   func parseDesignTokensData() -> DesignTokens {
      let decoder = JSONDecoder()
      let strFilePath = getFilePathForDesignTokens()
      do {
         let jsonData = try Data(contentsOf: URL(fileURLWithPath: strFilePath), options: .mappedIfSafe)
         dPrint("json data = \(jsonData)")
         do {
            return try decoder.decode(DesignTokens.self, from: jsonData)
         } catch let error {
            dPrint("exception error in parsing json data = \(String(describing: error))")
         }
      } catch {
         dPrint("Eror in parsing file path")
      }
      return DesignTokens()
   }

   func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString {
      let range = (fullString as NSString).range(of: subString)
      let attributedString = NSMutableAttributedString(string:fullString)
      attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fullStringColor, range: NSRange(location: 0, length: fullString.count))
      attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subStringColor, range: range)
      return attributedString
   }
}
