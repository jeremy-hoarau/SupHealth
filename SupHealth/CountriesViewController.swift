//
//  SecondViewController.swift
//  SupHealth
//
//  Created by Student Supinfo on 06/04/2021.
//  Copyright © 2021 supinfo student. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favOnly: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    var countryList : [String] = []
    let defaults = UserDefaults.standard
    var filterFavOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        favOnly.addTarget(self, action: #selector(toggleFavoritesFilter), for: UIControl.Event.valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CountryRow", bundle: nil), forCellReuseIdentifier: "CountryRow")
    }

    func getData() {
        let url = URL(string: "https://api.covid19api.com/summary")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String : Any] {
                self.countryList = self.convertResponseToArray(response: responseJSON)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func convertResponseToArray(response : [String : Any]) -> [String]{
        var countryName = ""
        var array = [String]()
        let countries = response["Countries"] as! [[String : Any]]
        for country in countries {
            countryName = country["Country"] as! String
            if(filterFavOnly){
                if(!defaults.bool(forKey: countryName)){
                    continue
                }
            }
            array.append(countryName)
        }
        return array
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "CountryRow", for: indexPath) as! CountryRow
        if(countryList.count > 0) {
            row.setData(country: countryList[indexPath.row])
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailSegue") {
            let detailController = segue.destination as! DetailViewController
            detailController.country = countryList[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            detailController.updateCountriesList = getData
        }
    }
        
    @objc func toggleFavoritesFilter(){
        filterFavOnly = favOnly.isOn
        getData()
    }
}

