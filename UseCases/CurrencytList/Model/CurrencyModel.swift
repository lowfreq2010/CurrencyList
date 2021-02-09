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
    
    // MARK: Private properties
    private var rates: CurrencyRate = [:] //contains all currency/exchange rate pairs
    private var originalList: [String] = [] // contains all currency codes that existed originally
    private let jsonFetcher: Fetchable
    private let jsonProcessor: JSONProcessor = JSONProcessor()
    
    // MARK: Public properties
    var originalCurrencies: [String] { get { return self.originalList }}
    var originalRates: CurrencyRate { get { return self.rates }}
    
    // MARK: Class initializers and methods
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
