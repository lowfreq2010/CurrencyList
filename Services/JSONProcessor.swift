//
//  JSONProcessor.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 30.01.2021.
//

import Foundation


class JSONProcessor: NSObject {
    
    func decode(from jsonData:Data) -> CurrencyResponse {

        let currencyList: CurrencyResponse = try! JSONDecoder().decode(CurrencyResponse.self, from: jsonData)
        return currencyList
    }
}
