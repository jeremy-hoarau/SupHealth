//
//  SecondViewController.swift
//  SupHealth
//
//  Created by Student Supinfo on 06/04/2021.
//  Copyright © 2021 supinfo student. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var countryList : [[String : String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetData()
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CountryRow", bundle: nil), forCellReuseIdentifier: "CountryRow")
    }

    func GetData() {
        let url = URL(string: "https://api.covid19api.com/countries")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [[String : String]] {
                self.countryList = responseJSON
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
}

extension SecondViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "CountryRow", for: indexPath) as! CountryRow
        if(countryList.count > 0) {
            row.setData(country: countryList[indexPath.row]["Country"]!)
        }
        return row
    }
}

