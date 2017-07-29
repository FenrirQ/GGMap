//
//  ViewController.swift
//  GGMap
//
//  Created by Quang Ly Hoang on 7/22/17.
//  Copyright © 2017 FenrirQ. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15
    
    // An array to hold the list of likely places
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 21.0337884, longitude: 105.7677234)
    
    var marker = GMSMarker()
    
    var startLocation = CLLocationCoordinate2D()
    var endLocation = CLLocationCoordinate2D()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        //Add a map
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        //Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        
        mapView.delegate = self
        createNotificationObserver()
    }
    
    func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(drawRoute), name: notificationJSON, object: nil)
    }

    @objc func drawRoute() {
        guard let points = DataServices.shared.polyLines?.routes[0].overview_polyline.points else {return}
        guard let path = GMSPath(fromEncodedPath: points) else {return}
        DispatchQueue.main.async {
            self.mapView.clear()
            self.setupMarker(coordinate: DataServices.shared.positionOfMarker!)
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = UIColor.blue
            polyline.strokeWidth = 2
            polyline.map = self.mapView
        }
        
    }
    


}

extension MapViewController: CLLocationManagerDelegate {
    // Handle incoming location events
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        startLocation = location.coordinate
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    //Handle authorization for the location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("User denied access to location")
            //Display the map using the default location
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined")
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
        }
    }
    
    //Handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        setupMarker(coordinate: coordinate)
        endLocation = coordinate

        DataServices.shared.drawPath(start: startLocation, end: endLocation)
    }
    
    func setupMarker(coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        marker.title = "ABC"
        marker.snippet = "abc"
        marker.opacity = 0.5
        marker.map = mapView
    }
}

