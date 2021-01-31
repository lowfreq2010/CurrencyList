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
    var otherCurrencies: [String] = []
    var rates: [String:Float] = [:] //contains all currency/exchange rate pairs

    // MARK: UITableview delegate/source
    
    func headerForTable() -> String? {
        return self.currencyName
    }
    
    func numberOfSections()->Int {
        return 2
    }
    
    func numberOfRows(for section:Int)->Int {
        
        var numOfRows: Int = 0
        
        switch section {
        case 0:
            numOfRows = 0
        case 1:
            numOfRows = self.otherCurrencies.count
        default:
            break
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
