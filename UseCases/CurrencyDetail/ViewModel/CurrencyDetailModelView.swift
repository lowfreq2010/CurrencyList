//
//  currencyListModelView.swift
//  currencyList
//
//  Created by VNS Work on 29.01.2021.
//

import Foundation
import UIKit

protocol CurrencyDetailViewModelProtocol {
    
    func numberOfSections() -> Int
    func numberOfRows(for section:Int) -> Int
    func getTitle(for section:Int) -> String?
    func headerForTable() -> String?
    
}

class CurrencyDetailViewModel: CurrencyDetailViewModelProtocol {

    var currencyName = "AED"  // code of currency shown on detail
    var originalList: [String] = [] // contains all currency codes that existed originally
    var rates: [String:Float] = [:] //contains all currency/exchange rate pairs

    private var otherCurrencies: [String] = []

    // MARK: UITableview delegate/source
    
    func headerForTable() -> String? {
        return currencyName
    }
    
    func numberOfSections()->Int {
        return 2
    }
    
    func numberOfRows(for section:Int)->Int {
        
        var numOfRows: Int
        
        switch section {
        case 0:
            numOfRows = 0
        default:
            numOfRows = self.otherCurrencies.count
        }
        return numOfRows
    }
    
    func getTitle(for section:Int) -> String? {
        return NSLocalizedString("ALLOTHERCURRENCIES", comment: "")
    }
    
    // MARK: Convenience methods
    
    // return currency code for given row
    func getCurrency(for row:Int) -> String {
        return self.otherCurrencies[row]
    }
    
    // return currency exchange rate for given row
    func calculateRate(for currencyCode: String) -> Float {
        return self.rates["\(currencyCode)"]!
    }
}
