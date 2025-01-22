//
//  FilterListsTableViewCell.swift
//  Iceback
//
//  Created by APPLE on 16/01/24.
//

import UIKit

class FilterListsTableViewCell: BaseTableViewCell {
  
  //MARK: - IBOutlet
  @IBOutlet weak var imgSelect: UIImageView!
  @IBOutlet weak var lblFilterName: UILabel!
  
  //MARK: - Awake From Nib
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  //MARK: - Setup
  override func setup<T>(_ object: T) {
    if let objFilterCategoriesDataObject = object as? FilterCategoriesData {
      lblFilterName.text = objFilterCategoriesDataObject.categoryName
      imgSelect.image = objFilterCategoriesDataObject.isSelected ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
    }
    
    if let objStoreData = object as? AllStoreData {
      lblFilterName.text = objStoreData.name
      imgSelect.image = objStoreData.isSelected ? IMAGES.ICN_FILTER_SELECTED : IMAGES.ICN_FILTER_UNSELECTED
    }
  }
  
}
