//
//  EditProfileData.swift
//  Iceback
//
//  Created by apple on 06/05/24.
//

//
//  EditProfileData.swift
//  Iceback
//
//  Created by apple on 03/05/24.
//

import Foundation

class EditProfile {
    
    let preSignedURL: String
    let objectURL: String
    
     required init(jsonDic : [String:Any]) {
        
        preSignedURL = jsonDic["preSignedUrl"]  as? String ?? ""
        objectURL = jsonDic["objectUrl"] as? String ?? ""
    }
}


class EditAvatarData {
    
    let status, message: String
    
    required init(jsonDic : [String:Any]){
        
        status = jsonDic["status"] as? String ?? ""
        message  = jsonDic["message"] as? String ?? ""
    }
}
