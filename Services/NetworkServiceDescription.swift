//
//  NetworkServiceDescription.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 09.02.2021.
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
