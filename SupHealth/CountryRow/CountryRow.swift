//
//  CountryRow.swift
//  SupHealth
//
//  Created by Student Supinfo on 07/04/2021.
//  Copyright © 2021 supinfo student. All rights reserved.
//

import UIKit

class CountryRow: UITableViewCell {

    @IBOutlet weak var country: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(country: String){
        self.country.text = country
    }
}
