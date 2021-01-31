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
        self.currencyListViewModel = CurrencyListViewModel(with: JSONOnlineFetcher()) //you can pass JSONOfflineFetcher() for development purposes
        
        self.callback = { [unowned self] in
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
        self.currencyListViewModel?.callback = self.callback
        self.currencyListViewModel?.getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.rowHeight = UITableView.automaticDimension
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
        performSegue(withIdentifier: "toCurrencyDetail", sender: indexPath)
    }
    
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = self.currencyListViewModel?.getTitle(for: section) else {return String()}
        return title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyListTableViewCell else {return UITableViewCell()}
        let section = indexPath.section
        let row  = indexPath.row
        var string1,string2 :String , buttonColor: UIColor = .black
        
        switch section {
        case 0:
            string1 = self.currencyListViewModel?.getSelectedCurrency(for: row) ?? ""
            string2 = String(self.currencyListViewModel?.getSelectedCurrencyRate(for: row) ?? 0)
            buttonColor = .red
        case 1:
            string1 = self.currencyListViewModel?.getCurrency(for: row) ?? ""
            string2 = String(self.currencyListViewModel?.getRate(for: row) ?? 0)

        default:
            return UITableViewCell()
        }

        
        // setup closure to be called on Star button tap
        cell.selectCurrencyButtonAction = { [unowned self] in
             print("Star button has been clicked")
            self.currencyListViewModel?.processStar(on: indexPath)
        }
        
        cell.currencyLabel.text = string1 + " - \(string2)"
        cell.selectCurrency.setTitleColor(buttonColor, for: .normal)
        
        return cell
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toCurrencyDetail" {
            let vc = segue.destination as! CurrencyDetailTableViewController
            // calculate name of selected currency and list of currencies to be displayed
            var section = 0
            var row = 0
            var currencySelected = ""
            var other:[String] = []
            
            if (sender is IndexPath) {
                let sentobject = sender as? IndexPath
                section = sentobject?.section ?? 0
                row = sentobject?.row ?? 0
                switch section {
                case 0:
                    currencySelected = self.currencyListViewModel!.getSelectedCurrency(for: row)
                    other = self.currencyListViewModel!.currentList
                case 1:
                    currencySelected = self.currencyListViewModel!.getCurrency(for: row)
                    other = self.currencyListViewModel!.selectedList
                default:
                    break
                }
            }
            
            // pass all data to new VC
            vc.currencyDetailViewModel.currencyName = currencySelected  // code of currency shown on detail
            let rates = self.currencyListViewModel!.originalRates
            vc.currencyDetailViewModel.rates =  rates
            vc.currencyDetailViewModel.otherCurrencies = other
        }
    }
}
