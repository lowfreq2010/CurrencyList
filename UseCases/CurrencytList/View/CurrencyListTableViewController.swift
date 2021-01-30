//
//  currencyListTableViewController.swift
//  currencyList
//
//  Created by VNS Work on 29.01.2021.
//

import UIKit

class CurrencyListTableViewController: UITableViewController {
    
    var currencyListViewModel  : CurrencyListViewModel? {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    var callback: () ->() = {}
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register custom cells with tableview
        let nibCell :UINib = UINib(nibName: "CurrencyListTableViewCell", bundle: nil)
        self.tableview.register(nibCell, forCellReuseIdentifier: "currencyCell")
        //set viewModel
        self.currencyListViewModel = CurrencyListViewModel()
        
        self.callback = { [unowned self] in
            self.tableview.reloadData()
        }
        self.currencyListViewModel?.getData(with: self.callback)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Support functions
    @objc func makeStarred(with sender:UIButton) {
        self.currencyListViewModel?.selectedRow = sender.tag
        self.currencyListViewModel?.processStar()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.currencyListViewModel?.numberOfSections())!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.currencyListViewModel?.numberOfRows(for: section))!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section \(indexPath.section) Row \(indexPath.row)")
    }
    
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = self.currencyListViewModel?.getTitle(for: section) else {return String()}
        return title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyListTableViewCell else {return UITableViewCell()}
        let section = indexPath.section
        let row  = indexPath.row
        guard let string1 = self.currencyListViewModel?.getCurrency(for: row) else {return UITableViewCell()}
        guard let string2 = self.currencyListViewModel?.getRate(for: row) else { return UITableViewCell()}
        
        cell.currencyLabel.text = string1 + " - \(string2)"
        cell.selectCurrency .addTarget(self, action: #selector(makeStarred(with:)), for: .touchUpInside)
        cell.selectCurrency.tag = row
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
