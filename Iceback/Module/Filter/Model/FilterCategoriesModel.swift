//
//  FilterCategoriesModel.swift
//  Iceback
//
//  Created by APPLE on 24/01/24.
//

import Foundation
import ObjectMapper

class FilterCategoriesModel : NSObject,Mappable{

  var status = ""
  var FilterCategoriesData = [FilterCategoriesDataObject]()

  override init() {
  }

  required init?(map: Map) {
    status <- map["status"]
    FilterCategoriesData <- map["data"]
  }

  func mapping(map: Map) {
    status <- map["status"]
    FilterCategoriesData <- map["data"]
  }
}

struct FilterCategoriesData {
  var categoryId : Int
  var categoryName: String
  var categoryLogo: String
  var createdAt: String
  var updatedAt: String
  var isSelected :Bool = false

  init(jsonData: [String: Any]) {
    categoryId = jsonData["id"] as? Int ?? 0
    categoryName = jsonData["name"] as? String ?? ""
    categoryLogo = jsonData["logo"] as? String ?? ""
    createdAt = jsonData["created_at"] as? String ?? ""
    updatedAt = jsonData["updated_at"] as? String ?? ""
  }
}

class FilterCategoriesDataObject : NSObject,Mappable{

  var categoryId = 0
  var categoryName = ""
  var categoryLogo = ""
  var createdAt = ""
  var updatedAt = ""
  var isSelected :Bool = false

  override init() {
  }

  required init?(map: Map) {

    categoryId <- map["id"]
    categoryName <- map["name"]
    categoryLogo <- map["logo"]
    createdAt <- map["created_at"]
    updatedAt <- map["updated_at"]
  }

  func mapping(map: Map) {

    categoryId <- map["id"]
    categoryName <- map["name"]
    categoryLogo <- map["logo"]
    createdAt <- map["created_at"]
    updatedAt <- map["updated_at"]
  }
}

