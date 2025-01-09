//
//  SortByTableViewCell.swift
//  Iceback
//
//  Created by Admin on 12/01/24.
//

import UIKit

class SortByTableViewCell: BaseTableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblSortByTitle: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objSortBy = object as? SortByModel {
            lblSortByTitle.text = objSortBy.title.localized()
            lblSortByTitle.textColor = objSortBy.isSelect ? UIColor.app000000 : UIColor.app00000060
            lblSortByTitle.font = objSortBy.isSelect ? AFont(size: 14, type: .Medium) : AFont(size: 14, type: .Roman)
            viewBackground.backgroundColor = objSortBy.isSelect ? .app00000010 : .clear
        }
    }
    
}
