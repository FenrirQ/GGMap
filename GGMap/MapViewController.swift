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
    }

//    func listLikelyPlaces() {
//        //Clean up from previous sessions
//        likelyPlaces.removeAll()
//
//        placesClient.currentPlace(callback: {(placeLikelihoods, error) in
//            if let error = error {
//                //TODO: Handle the error
//                print("Current Place error: \(error.localizedDescription)")
//                return
//            }
//
//            //Get likely places and add to the list
//            if let likelihoodList = placeLikelihoods {
//                for likelihood in likelihoodList.likelihoods {
//                    let place = likelihood.place
//                    self.likelyPlaces.append(place)
//                }
//            }
//        })
//    }

//    @IBAction func goToPlaces(_ sender: UIButton) {
//        performSegue(withIdentifier: "segueToSelect", sender: sender)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToSelect" {
//            if let nextViewController = segue.destination as? PlacesViewController {
//                nextViewController.likelyPlaces = likelyPlaces
//            }
//        }
//    }
    
    //Update the map once the user has made their selection
//    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
//        //Clear the map
//        mapView.clear()
//
//        //Add a marker to the map
//        if let selectedPlace = selectedPlace {
//            let marker = GMSMarker(position: selectedPlace.coordinate)
//            marker.title = selectedPlace.name
//            marker.snippet = selectedPlace.formattedAddress
//            marker.map = mapView
//        }
//        listLikelyPlaces()
//    }
//

}

extension MapViewController: CLLocationManagerDelegate {
    // Handle incoming location events
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
//        listLikelyPlaces()
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
        let marker = GMSMarker(position: coordinate)
        marker.title = "abc"
        marker.snippet = "ABC"
        marker.map = mapView
    }
}
