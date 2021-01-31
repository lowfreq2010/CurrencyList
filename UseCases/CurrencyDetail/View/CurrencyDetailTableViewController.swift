//
//  CurrencyDetailTableViewController.swift
//  CurrencyListFetcher
//
//  Created by VNS Work on 31.01.2021.
//

import UIKit

class CurrencyDetailTableViewController: UITableViewController {

    var currencyDetailViewModel  : CurrencyDetailViewModel = CurrencyDetailViewModel()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // register custom cells with tableview
        let nibCell :UINib = UINib(nibName: "CurrencyDetailTableViewCell", bundle: nil)
        self.tableview.register(nibCell, forCellReuseIdentifier: "detailCell")
        self.currencyDetailViewModel = CurrencyDetailViewModel()
        self.tableview.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.currencyDetailViewModel.numberOfSections())
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.currencyDetailViewModel.numberOfRows(for: section))
    }
    
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = self.currencyDetailViewModel.getTitle(for: section) else {return String()}
        return title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? CurrencyDetailTableViewCell else {return UITableViewCell()}
        let row  = indexPath.row
        let currencyCode = self.currencyDetailViewModel.getCurrency(for: row)
        let exchangeRate = String(self.currencyDetailViewModel.calculateRate(for: currencyCode))
        cell.currencyName.text = currencyCode + " - " + exchangeRate
        
        return cell
    }
}
