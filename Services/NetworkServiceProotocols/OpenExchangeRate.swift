//
//  OpenExchangeRate.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 09.02.2021.
//

import Foundation

struct OpenExchangeRate: NetworkServiceDescription {
    
    var serviceKey: String = "3e58b5f8575742b7817e51d5e1196c0b"
    var baseURL: String = "https://openexchangerates.org/"
    var api: String = "api/"
    var endpoint: String = "latest.json"
    var requestParams: [String:String]
    
    init(with params:[String:String]) {
        self.requestParams = params
    }
}
