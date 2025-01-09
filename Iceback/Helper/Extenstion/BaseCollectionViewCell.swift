//
//  BaseCollectionViewCell.swift
//  Counos
//
//  Created by Admin on 28/07/23.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    class func cellID() -> String {
        return String(describing: self)
    }
    
    func setup<T>(_ object: T){
       
    }
    
    func configureUI(){
        
    }
    
}
