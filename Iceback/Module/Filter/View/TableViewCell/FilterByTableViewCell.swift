//
//  FilterByTableViewCell.swift
//  Iceback
//
//  Created by APPLE on 16/01/24.
//

import UIKit

class FilterByTableViewCell: BaseTableViewCell {
  
  //MARK: - IBOutlet
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblCategoryCount: UILabel!
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var viewTop: UIView!
  
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
    if let objFilterListModel = object as? FilterListModel {
      lblName.text = objFilterListModel.Name
      
      if objFilterListModel.count == 0 {
        lblCategoryCount.text = ""
      } else {
        lblCategoryCount.text =  objFilterListModel.count<10 ? String(format: "%02d", objFilterListModel.count) : String(objFilterListModel.count)
      }
      
      lblName.font = objFilterListModel.isSelected ? AFont(size: 14, type: .Heavy) : AFont(size: 14, type: .Roman)
      lblName.textColor = objFilterListModel.isSelected ? .app000000 : .app00000060
      bgView.backgroundColor = objFilterListModel.isSelected ?  .appFFFFFF : .appEFF8FF
      
    }
  }
}
