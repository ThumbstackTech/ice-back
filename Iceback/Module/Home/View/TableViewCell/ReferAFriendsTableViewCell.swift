//
//  ReferAFriendsTableViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit
import SDWebImage

class ReferAFriendsTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnIWantToKnowMore: UIButton!
    @IBOutlet weak var imgReferAFriend: UIImageView!
    @IBOutlet weak var lblReferAFriendDescription: UILabel!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        GCDMainThread.async { [self] in
            btnIWantToKnowMore.circleCorner = true
        }
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        if let objReferFriend = object as? ContentData {
            lblReferAFriendDescription.text = objReferFriend.content?.withoutHtml.replacingOccurrences(of: "\n", with: "")
            lblReferAFriendDescription.setLineSpacing(lineSpacing: lineSpacingBetweenText)
            btnIWantToKnowMore.setTitle(objReferFriend.button2_Text, for: .normal)
                imgReferAFriend.sd_setImage(with: URL(string: objReferFriend.image?.first?.url ?? "" ), placeholderImage: IMAGES.ICN_PLACEHOLDER_IMAGE)
        }
    }
}
