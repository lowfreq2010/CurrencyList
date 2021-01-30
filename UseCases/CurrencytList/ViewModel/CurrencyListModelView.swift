//
//  currencyListModelView.swift
//  currencyList
//
//  Created by VNS Work on 21.01.2021.
//

import Foundation

protocol CurrencyListViewModelProtocol {
    func buyProduct()
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    
}

class CurrencyListViewModel: CurrencyListViewModelProtocol {
    
    private var currencies: [String] = []   // contains all currency codes to display
    private var rates: [String:Float] = [:] //contains all currency/exchange rate pairs
    
    var selectedCurrencies: [Currency] = []
    var selectedRow: Int  = 0

    // Service objects
    let jsonFetcher: Fetcher = JSONOfflineFetcher()
    let jsonProcessor: JSONProcessor = JSONProcessor()

    
    func buyProduct() {
        print("Tapped on button to Buy product in row:\(self.selectedRow)")
    }
    
    func numberOfSections()->Int {
        return 1
    }
    
    func numberOfRows()->Int {
        return self.currencies.count
    }
    
    func getData(with callback:@escaping () -> ()) {
        let jsonData = self.jsonFetcher.fetch()
        let currencyList: CurrencyResponse = self.jsonProcessor.decode(from: jsonData)
        let rates = currencyList.rates
        let names =  rates.map {$0.key}
        self.currencies = names.sorted(by:<)
//
//        print(String(describing: type(of: rates)))
//        print(String(describing: type(of: self.currencies)))
//        print(self.currencies)
        callback()
    }
    
    func getCurrency(for row:Int) -> String {
       return self.currencies[row]
    }
    
    
}
