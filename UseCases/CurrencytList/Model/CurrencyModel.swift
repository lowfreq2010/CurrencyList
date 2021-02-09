//
//  currencyListModel.swift
//  currencyList
//
//  Created by VNS Work on 21.01.2021.
//

import Foundation

typealias CurrencyRate = [String:Float]

struct CurrencyResponse: Decodable {
    let disclaimer:String
    let license:String
    let timestamp: Double
    let base: String
    let rates: CurrencyRate
}

class CurrencyModel {
    private var rates: CurrencyRate = [:] //contains all currency/exchange rate pairs
    var originalRates: CurrencyRate { get { return self.rates }}
    
    private var originalList: [String] = [] // contains all currency codes that existed originally
    var originalCurrencies: [String] { get { return self.originalList }}
    
    let jsonFetcher: Fetchable
    let jsonProcessor: JSONProcessor = JSONProcessor()
    
    init(with fetcher:Fetchable) {
        self.jsonFetcher = fetcher
    }
    
    // fetch all currency data
    func getData(_ completion: @escaping () -> ()) {
        
        let _: Void = self.jsonFetcher.fetch({[unowned self] jsonData in
            
            let currencyList: CurrencyResponse = self.jsonProcessor.decode(from: jsonData)
            self.rates = currencyList.rates
            let names =  self.rates.map {$0.key}
            self.originalList = names.sorted(by:<)
            completion()
        })
    }
    
    
}
