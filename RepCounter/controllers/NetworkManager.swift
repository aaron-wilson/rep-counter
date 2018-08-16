//
//  NetworkManager.swift
//  RepCounter
//

import Foundation

struct Constants {
    static let yelpAPIKey = "5Yd5aeDG9BzXExdIlFkmskKjuwNXAtrAsxB4LKRMbOcgSfUf2Ii4Lgcw2ojrHbT8UUsUNjFYtESsBfGEwVkN06-Xg3L3gQ1MMX1jrHogz8FPV6U42dqHdhl6RSi_WXYx"
    static let yelpAPIBaseUrl = "https://api.yelp.com/v3/businesses/search"
}

protocol GymFinderDelegate {
    func gymsFound(_ gyms: [Gym])
    func gymsNotFound()
}

class NetworkManager {
    
    var delegate: GymFinderDelegate?
    
    func fetchNearbyGyms(latitude: Double, longitude: Double) {
        var urlComponents = URLComponents(string: Constants.yelpAPIBaseUrl)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "categories", value: "gyms")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(Constants.yelpAPIKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // guard for non-nil HTTPURLResponse with code 200
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response nil or not 200")
                self.delegate?.gymsNotFound()
                return
            }
            
            // guard to ensure data is non-nil
            guard let data = data else {
                print("data is nil")
                self.delegate?.gymsNotFound()
                return
            }
            
            
            let decoder = JSONDecoder()
            do {
                let yelpResponse = try decoder.decode(YelpResponse.self, from: data)
                let businesses = yelpResponse.businesses
                var gyms = [Gym]()
                
                for business in businesses {
                    let address = business.location.displayAddress.joined(separator: ",")

                    let gym = Gym(name: business.name, address: address, logoUrlString: business.imageUrl.absoluteString, latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                    
                    gyms.append(gym)
                }
                
                self.delegate?.gymsFound(gyms)                
            } catch let error {
                print(error) //fail
                self.delegate?.gymsNotFound()
            }
        }
        
        task.resume() 
    }

}
