//
//  HeaderTitleTableViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit

class HeaderTitleTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
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
        
    }
}
