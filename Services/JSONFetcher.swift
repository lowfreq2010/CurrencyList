//
//  JSONFetcher.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 30.01.2021.
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

protocol Fetchable: class {
    var sourceURL: String { get set }
    func fetch(_ completion: @escaping (Data) -> ()) -> Void
}

class Fetcher: Fetchable {
    var sourceURL:String = ""
    let service: NetworkServiceDescription
    
    func fetch(_ completion: @escaping (Data) -> ()) -> Void {
    }
    
    init(with service:NetworkServiceDescription) {
        self.service = service
        self.sourceURL = self.service.requestURL
    }
}

// Fetch via URLSession class
class JSONOnlineFetcher: Fetcher {
    
    init() {
        let params = ["app_id" : "3e58b5f8575742b7817e51d5e1196c0b"]
        super.init(with:OpenExchangeRate(with: params))
    }
    
    override func fetch(_ completion: @escaping (Data) -> ()) -> Void  {
        guard let url = URL(string: self.sourceURL) else {return}
        // let use URLSession for async JSON request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // pass the data to completion block
                completion(data)
            }
        }.resume()
    }
}

// offline mock for developemnt/testing purpose
// just inject it into jsonFetcher property of CurrencyModel
class JSONOfflineFetcher: Fetchable {
    
    var sourceURL: String = """
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
    
    func fetch(_ completion: @escaping (Data)->()) -> () {
        completion(self.sourceURL.data(using: .utf8)!)
    }
}

