//
//  currencyListModelView.swift
//  currencyList
//
//  Created by VNS Work on 29.01.2021.
//

import Foundation

protocol CurrencyListViewModelProtocol {
    func buyProduct()
    func numberOfSections() -> Int
    func numberOfRows(for section:Int) -> Int
    
}

class CurrencyListViewModel: CurrencyListViewModelProtocol {

    private var currencies: [String] = []   // contains all currency codes to display
    private var rates: [String:Float] = [:] //contains all currency/exchange rate pairs
    
    var selectedCurrencies: [String] = []
    var selectedRow: Int  = 0

    // Service objects
    let jsonFetcher: Fetcher = JSONOfflineFetcher()
    let jsonProcessor: JSONProcessor = JSONProcessor()

    
    func buyProduct() {
        print("Tapped on button to Buy product in row:\(self.selectedRow)")
    }
    
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
    
    func getData(with callback:@escaping () -> ()) {
        let jsonData = self.jsonFetcher.fetch()
        let currencyList: CurrencyResponse = self.jsonProcessor.decode(from: jsonData)
        self.rates = currencyList.rates
        let names =  self.rates.map {$0.key}
        self.currencies = names.sorted(by:<)
        
        // force view to do whatever it needs to do
        callback()
    }
    
    func getCurrency(for row:Int) -> String {
        return self.currencies[row]
    }
    
    func getRate(for row:Int) -> Float {
        return self.rates["\(self.getCurrency(for: row))"]!
    }
    
    
}
