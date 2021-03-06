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
    func getTitle(for section:Int) -> String
    func headerForTable() -> String
    
}

class CurrencyDetailViewModel: CurrencyDetailViewModelProtocol {

    var currencyName = ""  // code of currency shown on detail
    var otherCurrencies: [String] = []
    var rates: CurrencyRate = [:] //contains all currency/exchange rate pairs

    // MARK: UITableview delegate/source
    
    func headerForTable() -> String {
        return NSLocalizedString("SELECTECURRENCY", comment: "") + " - " + self.currencyName
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
    
    func getTitle(for section:Int) -> String {
        var title: String = ""
        
        switch section {
        case 0:
            title = self.headerForTable()
        case 1:
            title = NSLocalizedString("ALLOTHERCURRENCIES", comment: "")
        default:
            break
        }
        return title
    }
    
    // MARK: Convenience methods
    
    // return currency code for given row
    func getCurrency(for row:Int) -> String {
        return self.otherCurrencies[row]
    }
    
    // return currency exchange rate against base currency
    func getRate(for currencyCode: String) -> Float {
        return self.rates["\(currencyCode)"]!
    }
    
    // return currency exchange rate for given cureency againd selected currency
    func calculateRate(for currencyCode: String) -> Float {
        
        let selectedUSDRate = self.getRate(for: self.currencyName)
        let passedUSDRate = self.getRate(for: currencyCode)
        let calculatedRate =  selectedUSDRate/passedUSDRate
        return calculatedRate
    }
}
