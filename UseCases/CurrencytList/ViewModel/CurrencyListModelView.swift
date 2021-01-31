//
//  currencyListModelView.swift
//  currencyList
//
//  Created by VNS Work on 29.01.2021.
//

import Foundation
import UIKit

protocol CurrencyListViewModelProtocol {
    func processStar(on indexPath: IndexPath)
    func numberOfSections() -> Int
    func numberOfRows(for section:Int) -> Int
    func getTitle(for section:Int) -> String?
    
}

class CurrencyListViewModel: CurrencyListViewModelProtocol {
    
    private var rates: [String:Float] = [:] //contains all currency/exchange rate pairs
    
    private var selectedCurrencies: [String] = []
    private var currencies: [String] = []   // contains all currency codes to display
    private var originalList: [String] = [] // contains all currency codes that existed originally
    
    var originalRates: [String:Float] {
        get {
            return self.rates
        }
    }
    
//    var originalCurrencies: [String] {
//        get {
//            return self.originalList
//        }
//    }
    
    var currentList: [String] {
        get {
            return self.currencies
        }
    }
    
    var selectedList: [String] {
        get {
            return self.selectedCurrencies
        }
    }
    
    
    
    
    var callback: () -> () = {}
    
    var selectedRow: Int  = 0
    
    // MARK: Service class objects
    let jsonFetcher: Fetcher = JSONOfflineFetcher()
    let jsonProcessor: JSONProcessor = JSONProcessor()
    let nsudProcessor: CurrencyListNSUD = CurrencyListNSUD(with: "selectedCurrencies", value: [])
    
    // MARK: UITableview delegate/source
    func numberOfSections()->Int {
        // return self.selectedCurrencies.count == 0 ? 1 : 2
        return 2
    }
    
    func numberOfRows(for section:Int)->Int {
        var numOfRows: Int
        
        switch section {
        case 1:
            numOfRows = self.currencies.count
        default:
            numOfRows = self.selectedCurrencies.count
        }
        return numOfRows
    }
    
    func getTitle(for section:Int) -> String? {
        var title: String?
        
        switch section {
        case 1:
            title = NSLocalizedString("COMMONLIST", comment: "")
        default:
            title = NSLocalizedString("SELECTEDLIST", comment: "")
        }
        return title
    }
    
    // MARK: Convenience methods
    
    // fetch all currency data
    func getData() {
        
        let _: Void = self.jsonFetcher.fetch({[unowned self] jsonData in
            
            let currencyList: CurrencyResponse = self.jsonProcessor.decode(from: jsonData)
            self.rates = currencyList.rates
            let names =  self.rates.map {$0.key}
            self.originalList = names.sorted(by:<)
            // try to restore saved selected currencies
            let selCurr: [String]? = self.nsudProcessor.restore()
            self.selectedCurrencies = selCurr ?? []
            self.currencies = subtractSelected()
            // force view to do whatever it needs to do
            self.callback()
        })
    }
    
    // return currency code for given row
    func getCurrency(for row:Int) -> String {
        return self.currencies[row]
    }
    
    // return currency exchange rate for given row
    func getRate(for row:Int) -> Float {
        return self.rates["\(self.getCurrency(for: row))"]!
    }
    
    // return currency code for given row
    func getSelectedCurrency(for row:Int) -> String {
        return self.selectedCurrencies[row]
    }
    
    // return selected currency exchange rate for given row
    func getSelectedCurrencyRate(for row:Int) -> Float {
        return self.rates["\(self.getSelectedCurrency(for: row))"]!
    }
    
    
    func processStar(on indexPath: IndexPath) -> Void {
        print("Tapped on star in section: \(indexPath.section) row:\(indexPath.row)")
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0: // remove currency from selected list
            self.removeFromSelected(from: row)
        case 1: // move currency to selected list
            self.moveCurrencyToSelected(from: row)
        default:
            break
        }
        self.nsudProcessor.storedValue = self.selectedCurrencies
        self.nsudProcessor.save()
    }
    
    // MARK: processing append/remove to Selected list
    
    func moveCurrencyToSelected(from position: Int) -> Void {
        let currencyName: String = self.getCurrency(for: position)
        if self.selectedCurrencies.count==5 {
            let alertController = UIAlertController(title:"", message: NSLocalizedString("NOMORETHAN5", comment: ""), preferredStyle: .alert)
            let close = UIAlertAction(title: NSLocalizedString("CLOSE", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(close)
            UIApplication.shared.windows.last?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            self.selectedCurrencies.append(currencyName)
            self.currencies.remove(at: position)
            print("moving to Selected in row \(position) Currency is \(currencyName)")
            self.callback()
        }
    }
    
    func removeFromSelected(from position: Int) -> Void {

        self.selectedCurrencies.remove(at: position)
        self.currencies = subtractSelected()
        self.callback()
    }
    
    func subtractSelected() -> [String] {
        return self.originalList.filter { !self.selectedCurrencies.contains($0) } .sorted(by: <)
    }
    
}
