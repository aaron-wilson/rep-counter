//
//  LocationFinder.swift
//  RepCounter
//

import Foundation
import CoreLocation

protocol LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double)
    func locationNotFound()
}

class LocationFinder: NSObject {
    
    var delegate: LocationFinderDelegate?
    var locationManager: CLLocationManager?
    
    func findLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }

}

extension LocationFinder: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { 
        manager.stopUpdatingLocation()
        let location = locations.last!
        
        delegate?.locationFound(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                delegate?.locationNotFound()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
        delegate?.locationNotFound()
    }
}
