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
    var currencies: [Currency] = []
    var selectedCurrencies: [Currency] = []
    var selectedRow : Int  = 0
    
    func buyProduct() {
        print("Tapped on button to Buy product in row:\(self.selectedRow)")
    }
    
    func numberOfSections()->Int {
        return 1
    }
    
    func numberOfRows()->Int {
        return 10
    }
    
    
}
