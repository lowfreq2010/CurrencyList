//
//  JSONFetcher.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 30.01.2021.
//

import Foundation

protocol NetworkServiceDescription {
    var api: String { get set }
    var endpoint:String { get set}
    var baseURL:String { get}
    var serviceKey: String {get}
    var requestParams: [String:String] {get}
    
}

extension NetworkServiceDescription {
    
    var requestURL: String {
        get {
            return self.constructRequest()
        }
    }
    private func constructRequest() -> String {
        var requestedString = self.baseURL+self.api+endpoint
        var count = 0
        let paramCount = requestParams.count
        for (key, value)  in requestParams {
            switch count {
            case 0:
                requestedString += "?"
            default:
                if count < paramCount {
                    requestedString += "&"
                }
            }
            requestedString = requestedString + key + "=" + value
            count += 1
        }
        return requestedString
    }
}

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
    func fetch(_ completion: @escaping (Data) -> ()) -> Void
}

class Fetcher: Fetchable {
    var jsonSource:String
    let service: NetworkServiceDescription
    
    func fetch(_ completion: @escaping (Data) -> ()) -> Void {
    }
    
    init(with service:NetworkServiceDescription) {
        self.service = service
        self.jsonSource = self.service.requestURL
    }
}

// Fetch via URLSession class
class JSONOnlineFetcher: Fetcher {
    
    init() {
        let params = ["app_id" : "3e58b5f8575742b7817e51d5e1196c0b"]
        super.init(with:OpenExchangeRate(with: params))
    }
    
    override func fetch(_ completion: @escaping (Data) -> ()) -> Void  {
        guard let url = URL(string: self.jsonSource) else {return}
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
class JSONOfflineFetcher: Fetchable {
    
    let jsonSource = """
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
        let data = self.jsonSource.data(using: .utf8)!
        completion(data)
    }
}

