//
//  currencyListModelView.swift
//  currencyList
//
//  Created by VNS Work on 29.01.2021.
//

import Foundation

protocol CurrencyListViewModelProtocol {
    func processStar()
    func numberOfSections() -> Int
    func numberOfRows(for section:Int) -> Int
    func getTitle(for section:Int) -> String?
    
}

class CurrencyListViewModel: CurrencyListViewModelProtocol {

    private var rates: [String:Float] = [:] //contains all currency/exchange rate pairs
    
    private var selectedCurrencies: [String] = ["AOA","AFN"]
    private var currencies: [String] = []   // contains all currency codes to display
    
    var selectedRow: Int  = 0

    // MARK: Service class objects
    let jsonFetcher: Fetcher = JSONOfflineFetcher()
    let jsonProcessor: JSONProcessor = JSONProcessor()

    // MARK: UITableview delegate/source
    func numberOfSections()->Int {
        return self.selectedCurrencies.count == 0 ? 1 : 2
    }
    
    func numberOfRows(for section:Int)->Int {
        var numOfRows = 0

        if (section == 1)  {
            numOfRows = self.currencies.count
        } else if ((section == 0) && (self.selectedCurrencies.count == 0)) {
            numOfRows = self.currencies.count
        } else if ((section == 0) && (self.selectedCurrencies.count > 0)) {
            numOfRows = self.selectedCurrencies.count
        }
        return numOfRows
    }
    
    func getTitle(for section:Int) -> String? {
        var title = NSLocalizedString("COMMONLIST", comment: "")
        
        if (section == 1)  {
        } else if ((section == 0) && (self.selectedCurrencies.count == 0)) {
            title = NSLocalizedString("COMMONLIST", comment: "")
        } else if ((section == 0) && (self.selectedCurrencies.count > 0)) {
            title = NSLocalizedString("SELECTEDLIST", comment: "")
        }
        return title
    }
    
    // MARK: Convenience methods
    
    // fetch all currency data
    func getData(with callback:@escaping () -> ()) {
        let jsonData = self.jsonFetcher.fetch()
        let currencyList: CurrencyResponse = self.jsonProcessor.decode(from: jsonData)
        self.rates = currencyList.rates
        let names =  self.rates.map {$0.key}
        self.currencies = names.sorted(by:<)
        
        // force view to do whatever it needs to do
        callback()
    }
    
    // return currency code for given row
    func getCurrency(for row:Int) -> String {
        return self.currencies[row]
    }
    
    // return currency exchange rate for given row
    func getRate(for row:Int) -> Float {
        return self.rates["\(self.getCurrency(for: row))"]!
    }
    
    
    func processStar() {
        print("Tapped on star in row:\(self.selectedRow)")
    }
    
    
}
