//
//  FilterListsModel.swift
//  Iceback
//
//  Created by APPLE on 16/01/24.
//

import Foundation

//MARK: - FilterListModel
struct FilterListModel {
    
    var id : Int
    var Name : String
    var isSelected : Bool
    var count : Int
    
    init(id: Int, Name: String, isSelected: Bool, count: Int) {
        self.id = id
        self.Name = Name
        self.isSelected = isSelected
        self.count = count
    }
}
