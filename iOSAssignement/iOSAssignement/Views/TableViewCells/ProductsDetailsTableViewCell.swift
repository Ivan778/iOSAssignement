//
//  ProductsDetailsTableViewCell.swift
//  iOSAssignement
//
//  Created by Иван on 10/13/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import UIKit

class ProductsDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Accessors
    func set(value: String, for key: String) {
        self.keyLabel.text = key
        self.valueLabel.text = value
    }
    
    // MARK: Other
    class func reuseId() -> String {
        return "ProductsDetailsTableViewCell"
    }
}
