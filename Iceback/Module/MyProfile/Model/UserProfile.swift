//
//  UserProfile.swift
//  Iceback
//
//  Created by Admin on 02/04/24.
//

import Foundation
// MARK: - UserProfileData
struct UserProfile {
    var id: Int
    var firstName, lastName, email, username: String
    var emailVerifiedAt, address, city, postcode: String
    var state, country: String
    var phone: String
    var dateOfBirth: String
    var balance, donationBalance, donated: Double
    var userStatus: String
    var referralCode, createdAt, updatedAt: String
    var dataSuper: Int
    var avatar: String
    var preferences, lastLogin, language: String
    var isViewcapitalUser: Bool
    var referralData: ReferralData?
    var areaRecovered, iceBearsSaved, waterSupplyForPeople, fountainsBuilt: Int
    var expectedUserCashback: Double
    var transactions: [TransactionList]
    var activities: [Activity]
    //    var payouts, donations: [Any?]
    var invitations: [Invitation]
    
    init(jsonData: [String: Any]) {
        var arrActivity = [Activity]()
        var arrInvitation = [Invitation]()
        var arrTransaction = [TransactionList]()
        
        id = jsonData["id"] as? Int ?? 0
        firstName = jsonData["first_name"] as? String ?? ""
        lastName = jsonData["last_name"] as? String ?? ""
        email = jsonData["email"] as? String ?? ""
        username = jsonData["username"] as? String ?? ""
        emailVerifiedAt = jsonData["email_verified_at"] as? String ?? ""
        address = jsonData["address"] as? String ?? ""
        city = jsonData["city"] as? String ?? ""
        postcode = jsonData["postcode"] as? String ?? ""
        state = jsonData["state"] as? String ?? ""
        country = jsonData["country"] as? String ?? ""
        phone = jsonData["phone"] as? String ?? ""
        dateOfBirth = jsonData["date_of_birth"] as? String ?? ""
        balance = jsonData["balance"] as? Double ?? 0.0
        donationBalance = jsonData["donation_balance"] as? Double ?? 0.0
        donated = jsonData["donated"] as? Double ?? 0.0
        userStatus = jsonData["user_status"] as? String ?? ""
        referralCode = jsonData["referral_code"] as? String ?? ""
        createdAt = jsonData["created_at"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        dataSuper = jsonData["super"] as? Int ?? 0
        avatar = jsonData["avatar"] as? String ?? ""
        preferences = jsonData["preferences"] as? String ?? ""
        lastLogin = jsonData["last_login"] as? String ?? ""
        language = jsonData["language"] as? String ?? ""
        isViewcapitalUser = jsonData["is_viewcapital_user"] as? Bool ?? false
        
        if let objReferralData = jsonData["referral_data"] as? [String: Any] {
            let obj = ReferralData(jsonData: objReferralData)
            referralData = obj
        }
        
        areaRecovered = jsonData["area_recovered"] as? Int ?? 0
        iceBearsSaved = jsonData["ice_bears_saved"] as? Int ?? 0
        waterSupplyForPeople = jsonData["water_supply_for_people"] as? Int ?? 0
        fountainsBuilt = jsonData["fountains_built"] as? Int ?? 0
        expectedUserCashback = jsonData["expected_user_cashback"] as? Double ?? 0.0
        
        
        if let activityData = jsonData["activities"] as? [[String: Any]] {
            for dict in activityData {
                let obj = Activity(jsonData: dict)
                arrActivity.append(obj)
            }
        }
        activities = arrActivity
        
        if let invitationData = jsonData["invitations"] as? [[String: Any]] {
            for dict in invitationData {
                let obj = Invitation(jsonData: dict)
                arrInvitation.append(obj)
            }
        }
        invitations = arrInvitation
        
        if let transactionData = jsonData["transactions"] as? [[String: Any]] {
            for dict in transactionData {
                let obj = TransactionList(jsonData: dict)
                arrTransaction.append(obj)
            }
        }
        
        transactions = arrTransaction
    }
}

// MARK: - Activity
struct Activity {
    var id, userId, storeId: Int
    var createdAt, updatedAt: String
    var dealId: Int
    var deleted: Int
    var store: Store?
    var deal: Deal?
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        userId = jsonData["user_id"] as? Int ?? 0
        storeId = jsonData["store_id"] as? Int ?? 0
        createdAt = jsonData["created_at"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        dealId = jsonData["deal_id"] as? Int ?? 0
        deleted = jsonData["deleted"] as? Int ?? 0
        
        if let objStore = jsonData["store"] as? [String: Any] {
            let obj = Store(jsonData: objStore)
            store = obj
        }
        
        if let objDeal = jsonData["deal"] as? [String: Any] {
            let obj = Deal(jsonData: objDeal)
            deal = obj
        }
        
    }
}

// MARK: - Deal
class Deal {
    var id: Int
    var name: String
    var type: String
    var redirectURL: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        type = jsonData["type"] as? String ?? ""
        redirectURL = jsonData["redirectUrl"] as? String ?? ""
    }
}

// MARK: - Store
class Store {
    var id: Int
    var name: String
    var categoryId: Int
    var logo: String
    var website: String
    var maxCashbackAmount, cashbackPercentage: Int
    var redirectUrl: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        categoryId = jsonData["category_id"] as? Int ?? 0
        logo = jsonData["logo"] as? String ?? ""
        website = jsonData["website"] as? String ?? ""
        maxCashbackAmount = jsonData["max_cashback_amount"] as? Int ?? 0
        cashbackPercentage = jsonData["cashback_percentage"] as? Int ?? 0
        redirectUrl = jsonData["redirectUrl"] as? String ?? ""
    }
}

// MARK: - Invitation
class Invitation {
    var id, userId: Int
    var email, status: String
    var showedToUser: Int
    var createdAt, updatedAt: String
    var rewarded: Int
    var rewardedAmount, rewardedCurrency, rewardedDonationAmount: Int
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        userId = jsonData["user_id"] as? Int ?? 0
        email = jsonData["email"] as? String ?? ""
        status = jsonData["status"] as? String ?? ""
        showedToUser = jsonData["showed_to_user"] as? Int ?? 0
        createdAt = jsonData["created_at"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        rewarded = jsonData["rewarded"] as? Int ?? 0
        rewardedAmount = jsonData["rewarded_amount"] as? Int ?? 0
        rewardedCurrency = jsonData["rewarded_currency"] as? Int ?? 0
        rewardedDonationAmount = jsonData["rewarded_donation_amount"] as? Int ?? 0
    }
}

// MARK: - ReferralData
class ReferralData {
    var numAcceptedReferrals, totalDonationsReferrals, bonusFromReferrals, expectedReferralBonus: Int
    
    init(jsonData: [String: Any]) {
        numAcceptedReferrals = jsonData["num_accepted_referrals"] as? Int ?? 0
        totalDonationsReferrals = jsonData["total_donations_referrals"] as? Int ?? 0
        bonusFromReferrals = jsonData["bonus_from_referrals"] as? Int ?? 0
        expectedReferralBonus = jsonData["expected_referral_bonus"] as? Int ?? 0
    }
}

// MARK: - transactionList
class TransactionList {
    var id, userId: Int
    var storeId : Int
    var amount : Double
    var cashback : Double
    var status : String
    var createdAt : String
    var updatedAt : String
    //start - 19-4-24
    var awin_id: Int
    var user_cashback: Double
    var expected_user_cashback: Double
    var cashback_percentage: Double
    var currency:String
    var click_date: String
    var transaction_date: String
    var store_name: String
    var store_deal_id: String  //end 19-4-24
    
    init(jsonData: [String: Any]) {
        awin_id = jsonData["awin_id"] as? Int ?? 0
        userId = jsonData["user_id"] as? Int ?? 0
        storeId = jsonData["store_id"]  as? Int ?? 0
        amount = jsonData["amount"] as? Double ?? 0.0
        cashback = jsonData["cashback"] as? Double ?? 0.0
        createdAt = jsonData["created_at"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        status = jsonData["status"] as? String ?? ""
        //start - 19-4-24
        id = jsonData["id"] as? Int ?? 0
        user_cashback = jsonData["user_cashback"] as? Double ?? 0.0
        expected_user_cashback = jsonData["expected_user_cashback"] as? Double ?? 0.0
        cashback_percentage = jsonData["cashback_percentage"] as? Double ?? 0.0
        currency = jsonData["currency"] as? String ?? ""
        click_date = jsonData["click_date"] as? String ?? ""
        transaction_date = jsonData["transaction_date"] as? String ?? ""
        store_name = jsonData["store_name"] as? String ?? ""
        store_deal_id = jsonData["store_deal_id"] as? String ?? "" //end 19-4-24
        
    }
}
