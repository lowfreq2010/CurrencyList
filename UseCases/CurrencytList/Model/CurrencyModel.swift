//
//  currencyListModel.swift
//  currencyList
//
//  Created by VNS Work on 21.01.2021.
//

import Foundation

struct Currency {
    let code: String
    let rate: Float
}

struct CurrencyResponse: Decodable {
    let disclaimer:String
    let license:String
    let timestamp: Double
    let base: String
    let rates: [String:Float]
}
