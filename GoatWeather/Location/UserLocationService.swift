//
//  UserLocationService.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import CoreLocation
import UIKit

protocol UserLocationServiceListener: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
}

protocol UserLocationServicing: AnyObject {
    
    var listener: UserLocationServiceListener? { get }
    
    func requestLocationPermissions()
    func getCurrentLocationPermissions() -> CLAuthorizationStatus
    func getCurrentLocation() -> CLLocation?
}

class UserLocationService: NSObject, UserLocationServicing {
    var listener: UserLocationServiceListener?
    
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocationPermissions() -> CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        locationManager.location
    }
    
    func fetchCurrentCity(completion: @escaping (_ cityAndState: String?) -> ()) {
        guard let location = getCurrentLocation() else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let city = placemarks?.first?.locality,
                  let state = placemarks?.first?.administrativeArea else {
                return
            }
            
            let cityAndState = "\(city), \(state)"
            completion(cityAndState)
        }
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                manager.startUpdatingLocation()
            }
        case .denied, .restricted, .notDetermined:
            DispatchQueue.main.async {
                manager.stopUpdatingLocation()
            }
            break
        @unknown default:
            assert(true, "Unknown location authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            listener?.didUpdateLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: @aldrich handle location failure
    }
}
