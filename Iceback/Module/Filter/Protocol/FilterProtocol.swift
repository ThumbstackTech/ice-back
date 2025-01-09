//
//  FilterProtocol.swift
//  Iceback
//
//  Created by Admin on 17/01/24.
//

import Foundation

protocol FilterByDelegate {
    
    func filterByAll(categoryList:[FilterCategoriesData], regionList:[FilterRegionDataObject], isFilterApply: Bool, CategoryCount: Int, RegionCount: Int, isClearAll: Bool,categoryIds:[Int],regionIds:[Int],isCategoryApply:Bool,isRegionApply:Bool,currentPage:Int)
    
    func filterByNew(categoryList:[FilterCategoriesData], regionList:[FilterRegionDataObject], isFilterApply: Bool, CategoryCount: Int, RegionCount: Int, isClearAll: Bool,NewcategoryIds:[Int],NewregionIds:[Int],isCategoryApply:Bool,isRegionApply:Bool,currentPage:Int)
    
    func filterByTrending(categoryList:[FilterCategoriesData], regionList:[FilterRegionDataObject], isFilterApply: Bool, CategoryCount: Int, RegionCount: Int, isClearAll: Bool,TrendingcategoryIds:[Int],TrendingregionIds:[Int],isCategoryApply:Bool,isRegionApply:Bool,currentPage:Int)
    
}


protocol NewDealsAndVoucherFilterDelegate {
    func newDealsAndVoucherFilter(arrCategory: [FilterCategoriesData], arrStore: [AllStoreData], arrFilterBy: [FilterListModel])
}

protocol TrendingDealsAndVoucherFilterDelegate {
    func trendingDealsAndVoucherFilterDelegate(arrCategory: [FilterCategoriesData], arrStore: [AllStoreData], arrFilterBy: [FilterListModel])
}

protocol FilterRegionDelegate{
    func getFilterRegionLists(arrFilterRegion: [FilterRegionDataObject])
}
protocol FilterCategoryDelegate{
    func getFilterCategoryLists(arrCaetgoryRegion: [FilterCategoriesData])
}


protocol GetAllStoreNameDelegate {
    func getAllStoreNameSuccess(_ arrData : [AllStoreData])
}
