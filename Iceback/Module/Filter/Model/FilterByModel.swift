//
//  FilterByModel.swift
//  Iceback
//
//  Created by APPLE on 16/01/24.
//

import Foundation

//MARK: - FilterByModel
class FilterByModel {
  
  var id,selectedIndex : Int
  var Name : String
  
  init(id: Int, selectedIndex:Int, Name: String) {
    self.id = id
    self.selectedIndex = selectedIndex
    self.Name = Name
  }
}


//MARK: - AllStoreData
struct AllStoreData {
  var id : Int
  var name : String
  var redirectUrl : String
  var isSelected: Bool = false
  
  init(jsonData: [String: Any]) {
    id = jsonData["id"] as? Int ?? 0
    name = jsonData["name"] as? String ?? ""
    redirectUrl = jsonData["redirectUrl"] as? String ?? ""
  }
}
