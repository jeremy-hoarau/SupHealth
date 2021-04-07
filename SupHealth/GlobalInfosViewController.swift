//
//  FirstViewController.swift
//  SupHealth
//
//  Created by Student Supinfo on 06/04/2021.
//  Copyright © 2021 supinfo student. All rights reserved.
//

import UIKit

class GlobalInfosViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var globalInfos : [String : Any] = [:]
    let titles = [["NewConfirmed", "New Confirmed"], ["TotalConfirmed", "Total Confirmed"], ["NewDeaths", "New Deaths"], ["TotalDeaths", "Total Deaths"], ["NewRecovered", "New Recovered"], ["TotalRecovered", "Total Recovered"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
    }
    
    
    private func getData(){
        
        let url = URL(string: "https://api.covid19api.com/summary")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.globalInfos = responseJSON["Global"] as! [String : Any]
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }

        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if(globalInfos.count > 0) {
            cell.setData(title: titles[indexPath.row][1], value: (globalInfos[titles[indexPath.row][0]] as! NSNumber).stringValue)
        }
        
        return cell
    }
}
