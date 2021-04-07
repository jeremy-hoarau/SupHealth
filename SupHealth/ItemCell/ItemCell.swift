//
//  ItemCell.swift
//  SupHealth
//
//  Created by Student Supinfo on 06/04/2021.
//  Copyright © 2021 supinfo student. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = ""
        self.value.text = ""
    }

    func setData(title: String, value: String){
        self.title.text = title
        self.value.text = value
    }
}
