//
//  MyProfileMenuCell.swift
//  Iceback
//
//  Created by apple on 03/05/24.
//

import UIKit

class MyProfileMenuCell:BaseTableViewCell {
    
    @IBOutlet weak var vieWContent: UIView!
    @IBOutlet weak var switchEnable: UISwitch!
    @IBOutlet weak var imgNxt: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      //  imgNxt.rotate(radians: .pi/2)
//        let image = UIImage(named: "ic_back_black")!
//        let newImage = image.rotate(radians: .pi/2) // Rotate 90 degrees
//
//        imgNxt.image = newImage
        
        vieWContent.layer.cornerRadius = 10.0
        vieWContent.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setup<T>(_ object: T) {
        if let objSideMenu = object as? String {
            lblTitle.text = objSideMenu.localized()
        }
    }
}
