//
//  UserLocationService.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import CoreLocation
import UIKit

protocol UserLocationServiceListener: AnyObject {
    func didChangeLocationPermissions(to permission: CLAuthorizationStatus, currentLocation: CLLocation?)
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
        locationManager.startUpdatingLocation()
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
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            locationManager.stopUpdatingLocation()
        @unknown default:
            assert(true, "Unknown location authorization status")
        }
        listener?.didChangeLocationPermissions(to: manager.authorizationStatus, currentLocation: manager.location)
    }
}
