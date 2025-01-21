//
//  FilterRegionsModel.swift
//  Iceback
//
//  Created by APPLE on 24/01/24.
//

import Foundation
import ObjectMapper

class FilterRegionsModel : NSObject,Mappable{

  var status = ""
  var FilterRegionData = [FilterRegionDataObject]()

  override init() {
  }

  required init?(map: Map) {
    status <- map["status"]
    FilterRegionData <- map["data"]
  }

  func mapping(map: Map) {
    status <- map["status"]
    FilterRegionData <- map["data"]
  }
}

class FilterRegionDataObject : NSObject,Mappable{

  var RegionId = 0
  var RegionNameData = RegionNameDataObject()
  var createdAt = ""
  var updatedAt = ""
  var isSelected = false

  override init() {
  }

  required init?(map: Map) {
    RegionId <- map["id"]
    RegionNameData <- map["name"]
    createdAt <- map["created_at"]
    updatedAt <- map["updated_at"]
  }

  func mapping(map: Map) {

    RegionId <- map["id"]
    RegionNameData <- map["name"]
    createdAt <- map["created_at"]
    updatedAt <- map["updated_at"]
  }
}

class RegionNameDataObject : NSObject,Mappable{
  
  var en = ""
  var de = ""

  override init() {
  }

  required init?(map: Map) {
    en <- map["en"]
    de <- map["de"]
  }

  func mapping(map: Map) {
    en <- map["en"]
    de <- map["de"]
  }
}
