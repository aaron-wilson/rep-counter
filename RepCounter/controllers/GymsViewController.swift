//
//  GymsViewController.swift
//  RepCounter
//

import UIKit

class GymsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let networkManager = NetworkManager()
    let locationFinder = LocationFinder()
    
    var gyms = [Gym]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.delegate = self
        locationFinder.delegate = self
        
        locationFinder.findLocation()
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gymDetailSegue" {
            let destinationVC = segue.destination as! GymViewController
            destinationVC.gym = gyms[tableView.indexPathForSelectedRow!.row]
        }
    }

}

extension GymsViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        networkManager.fetchNearbyGyms(latitude: latitude, longitude: longitude)
    }
    
    func locationNotFound() {
        print("location not found")
    }
}

extension GymsViewController: GymFinderDelegate {
    func gymsFound(_ gyms: [Gym]) {
        self.gyms = gyms
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func gymsNotFound() {
        print("NO GYMS FOUND OR ERROR")
    }
}

extension GymsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gymDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymCell", for: indexPath) as! GymTableViewCell
        
        let gym = gyms[indexPath.row]
        cell.gymNameLabel.text = gym.name
        cell.gymAddressLabel.text = gym.address
        cell.gymImageView.downloadFrom(urlString: gym.logoUrlString)
        
        return cell
    }
}
