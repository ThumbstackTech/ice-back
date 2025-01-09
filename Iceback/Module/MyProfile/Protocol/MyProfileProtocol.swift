//
//  MyProfileProtocol.swift
//  Iceback
//
//  Created by Admin on 03/05/24.
//

import Foundation

protocol UserProfileDelegate{
    func getUserProfileDetails(_ objData: UserProfile)
}

protocol ProfilePictureProtocol {
    
    func profilePictureDelegate(response : EditProfile)
}

protocol UpdateProfileProtocol {
    
    func editAvatarDelegate(_ strMessage : String)
}

protocol FavouriteStoresDelegate {
    func favouriteStoresSucess(_ arrData: [storeDataListObject])
}

protocol CustomerSupportDelegate {
    func customerSupport(_ strMsg: String)
}

protocol NotificationsDelegate{
    func getNotifications(_ arrData: [NotifcationData])
}


protocol UserActivitiesDeleteDelegate {
    func userActivitiesDeleteSuccess(isSucess : Bool)
}


protocol UserAccountDeleteDelegate {
    func userAccountDeleteSuccess(isSucess : Bool)
}
