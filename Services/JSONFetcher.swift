//
//  JSONFetcher.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 30.01.2021.
//

import Foundation

class Fetcher: NSObject {
    var jsonSource:String = ""
    func fetch() -> Data {
        return Data()
    }
}

class JSONOnlineFetcher: Fetcher {
    
    override func fetch() -> Data {
        guard let url = URL(string: self.jsonSource) else {return Data()}
        guard let data = try? Data(contentsOf: url) else {return Data()}
        return data
    }
    
    override init() {
        super.init()
        self.jsonSource = "https://openexchangerates.org/api/latest.json?app_id=YOUR_APP_ID"
    }
}

class JSONOfflineFetcher: Fetcher {
    
    override func fetch() -> Data {
        self.jsonSource = """
        {
           "disclaimer":"https://openexchangerates.org/terms/",
           "license":"https://openexchangerates.org/license/",
           "timestamp":1449877801,
           "base":"USD",
           "rates":{
              "AED":3.672538,
              "AFN":66.809999,
              "ALL":125.716501,
              "AMD":484.902502,
              "ANG":1.788575,
              "AOA":135.295998,
              "ARS":9.750101,
              "AUD":1.390866
           }
        }
        """
        let data = self.jsonSource.data(using: .utf8)!
        return data
    }
}

