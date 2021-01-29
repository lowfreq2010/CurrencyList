//
//  currencyListTableViewController.swift
//  currencyList
//
//  Created by VNS Work on 21.01.2021.
//

import UIKit

class CurrencyListTableViewController: UITableViewController {
    
    var currencyListViewModel  : CurrencyListViewModel? {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register custom cells with tableview
        let nibCell :UINib = UINib(nibName: "CurrencyListTableViewCell", bundle: nil)
        self.tableview.register(nibCell, forCellReuseIdentifier: "currencyCell")
        //set viewModel
        self.currencyListViewModel = CurrencyListViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.estimatedRowHeight = 300
        self.tableview.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Support functions
    @objc func buyProduct(with sender:UIButton) {
        self.currencyListViewModel?.selectedRow = sender.tag
        self.currencyListViewModel?.buyProduct()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.currencyListViewModel?.numberOfSections())!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.currencyListViewModel?.numberOfRows())!
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyListTableViewCell else {return UITableViewCell()}
        cell.currencyLabel.text = "USD - \(indexPath.row)"
        cell.selectCurrency .addTarget(self, action: #selector(buyProduct(with:)), for: .touchUpInside)
        cell.selectCurrency.tag = indexPath.row

//        cell.productBuy .addTarget(self, action: #selector(buyProduct(with:)), for: .touchUpInside)
//        cell.productBuy.tag = indexPath.row
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
