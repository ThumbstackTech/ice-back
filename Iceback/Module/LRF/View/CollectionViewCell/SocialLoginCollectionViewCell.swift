//
//  SocialLoginCollectionViewCell.swift
//  Iceback
//
//  Created by Admin on 21/03/24.
//

import UIKit

class SocialLoginCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgSocialLogin: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let data = object as? SocialLoginModel {
            imgSocialLogin.image = data.image
        }
    }

}
