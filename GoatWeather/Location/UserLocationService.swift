//
//  UserLocationService.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import CoreLocation
import UIKit

protocol UserLocationServiceListener: AnyObject {
    func didChangeLocationPermissions(to permission: CLAuthorizationStatus)
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
    
}

extension UserLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        listener?.didChangeLocationPermissions(to: manager.authorizationStatus)
    }
}
