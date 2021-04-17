//
//  DetailViewController.swift
//  SupHealth
//
//  Created by Student Supinfo on 07/04/2021.
//  Copyright © 2021 supinfo student. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var pageTitle: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    var country : String = ""
    var countryInfos : [String : Any] = [:]
    let titles = [["NewConfirmed", "New Confirmed"], ["TotalConfirmed", "Total Confirmed"], ["NewDeaths", "New Deaths"], ["TotalDeaths", "Total Deaths"], ["NewRecovered", "New Recovered"], ["TotalRecovered", "Total Recovered"]]
    var favorite = false
    let defaults = UserDefaults.standard
    var updateCountriesList : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAndUpdateFavoriteState()
            
        pageTitle.title = country
        starButton.target = self
        starButton.action = #selector(toggleFavorite(sender:))

        getData()
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateCountriesList!()
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
                let countriesList = (responseJSON["Countries"] as! [[String : Any]]).first(where: {($0["Country"] as! String) == self.country})
                if(countriesList != nil) {
                    self.countryInfos = countriesList!
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
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
        if(countryInfos.count > 0) {
            cell.setData(title: titles[indexPath.row][1], value: (countryInfos[titles[indexPath.row][0]] as! NSNumber).stringValue)
        }
        
        return cell
    }
    
    func getAndUpdateFavoriteState(){
        favorite = defaults.bool(forKey: country)
        if(favorite){
            starButton.image = UIImage(systemName: "star.fill")
        }
    }
    
    func saveFavoriteState(value: Bool){
        defaults.set(value, forKey: country)
    }
    
    @objc func toggleFavorite(sender: UIBarButtonItem){
        if(!favorite){
            sender.image = UIImage(systemName: "star.fill")
        } else{
            sender.image = UIImage(systemName: "star")
        }
        favorite = !favorite
        saveFavoriteState(value: favorite)
    }
}
