//
//  BaseTableViewCell.swift
//  Counos
//
//  Created by Admin on 28/07/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        configureUI()
    }
    
    class func cellID() -> String {
        return String(describing: self)
    }
    
    class func heightForCell() -> CGFloat {
        return 44.0;
    }
    
    func setup<T>(_ object: T){
    }
    
    func configureUI(){
        
    }

}
