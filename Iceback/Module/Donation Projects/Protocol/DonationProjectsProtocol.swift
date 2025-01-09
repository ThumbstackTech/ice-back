//
//  DonationProjectsProtocol.swift
//  Iceback
//
//  Created by Admin on 19/01/24.
//

import Foundation


protocol DonationProjectsListDelegate{
    func DonationProjectsListSuccess(_ arrData: [DonationProjectsData], totalData: Int, pageLimit: Int)
}

protocol DonationDelegate {
    func donation(_ arrData: [DonationData])
}
