//
//  ProductFetchTableViewCell.swift
//  currencyList
//
//  Created by VNS Work on 21.01.2021.
//

import UIKit


class CurrencyListTableViewCell: UITableViewCell {
    
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var selectCurrency: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
