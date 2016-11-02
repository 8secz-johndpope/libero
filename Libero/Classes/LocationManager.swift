//
//  LocationManager.swift
//  
//
//  Created by John Kotz on 10/26/16.
//
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    enum Method {
        case Single
        case Multi
    }
    
    class Distance {
        private var distanceInMeters: CLLocationDistance
        
        init(distance: CLLocationDistance) {
            self.distanceInMeters = distance
        }
        
        var meters: Double {
            set {self.distanceInMeters = newValue}
            get {return self.distanceInMeters}
        }
        var feet: Double {
            set {self.distanceInMeters = newValue / 3.28084}
            get {return self.distanceInMeters * 3.28084}
        }
        var miles: Double {
            set {self.distanceInMeters = newValue * 1609.34}
            get {return self.distanceInMeters / 1609.34}
        }
        var kilometers: Double {
            set {self.distanceInMeters = newValue * 1000.0}
            get {return distanceInMeters / 1000.0}
        }
        var yard: Double {
            set {distanceInMeters = newValue / 1.09361}
            get {return distanceInMeters * 1.09361}
        }
        var nauticalMile: Double {
            set {distanceInMeters = newValue * 1852}
            get {return distanceInMeters / 1852}
        }
    }
    
    var locationManager = CLLocationManager()
    var authStatus: CLAuthorizationStatus = .notDetermined
    var locationAquired: ((CLLocation) -> Void)?
    var method: Method = .Multi
    var answeredCallback: (() -> Void)?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    init(answeredCallback: @escaping ()->Void) {
        super.init()
        self.answeredCallback = answeredCallback
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.authStatus = status
        if let answeredCallback = answeredCallback {
            answeredCallback()
        }
        if locationAquired != nil {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func getOneLocation(callback: ((CLLocation) -> Void)?) {
        self.locationAquired = callback
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
        self.method = .Single
    }
    
    func getMultipleLocations(callback: ((CLLocation) -> Void)?) {
        self.locationAquired = callback
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
        self.method = .Multi
    }
    
    // Returns the distance in (meters, miles)
    func calculateDistance(start: CLLocation, end: CLLocation) -> Distance {
        let meters: CLLocationDistance = end.distance(from: start)
        
        return Distance(distance: meters)
    }
    
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location: CLLocation = locations.last, let locationAquired = locationAquired {
//            locationAquired(location)
//        }
//        if method == .Single {
//            self.cancelLocation()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Encountered an error when getting the location!")
        print(error)
    }
    
    func cancelLocation() {
        self.locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingLocation()
        locationAquired = nil
    }
}
