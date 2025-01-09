//
//  DealsAndVouchersProtocol.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation

protocol DealsAndVouchersDetailDelegate {
    func dealsAndVouchersDetail(_ objData: DealsAndVoucherDetailData)
}

protocol RegionListDelegate {
    func regionList(_ arrData: [RegionData])
}

protocol NewDealsAndVouchersSuccessDelegate {
    func newDealsAndVouchersSuccess(_ arrData: [DealsAndVouchersData])
}

protocol NewDealsAndVouchersFailureDelegate {
    func newDealsAndVouchersFailure(_ isFailure: Bool)
}

protocol TrendingDealsAndVouchersSuccessDelegate {
    func trendingDealsAndVouchersSuccess(_ arrData: [DealsAndVouchersData])
}

protocol TrendingDealsAndVouchersFailureDelegate {
    func trendingDealsAndVouchersFailure(_ isFailure: Bool)
}
