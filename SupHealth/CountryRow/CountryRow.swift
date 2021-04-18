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
    @IBOutlet weak var starIcon: UIImageView!
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(country: String){
        self.country.text = country
        if(!defaults.bool(forKey: country)){
            starIcon.isHidden = true
        } else {
            starIcon.isHidden = false
        }
    }
}
