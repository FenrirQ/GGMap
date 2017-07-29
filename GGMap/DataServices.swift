//
//  DataServices.swift
//  GGMap
//
//  Created by Quang Ly Hoang on 7/25/17.
//  Copyright © 2017 FenrirQ. All rights reserved.
//

import Foundation
import CoreLocation

let notificationJSON = Notification.Name.init("JSON")
class DataServices {
    static var shared: DataServices = DataServices()
    
    //get polylines from JSON
    private var _polyLines: Polylines?
    
    var polyLines: Polylines? {
        get {
            if _polyLines == nil {
                print("No data")
            }
            return _polyLines
        }
        set {
            _polyLines = newValue
        }
    }
    
    //get position of marker from tap on map
    private var _positionOfMarker: CLLocationCoordinate2D?
    
    var positionOfMarker: CLLocationCoordinate2D? {
        get {
            if _positionOfMarker == nil {
                print("error")
            }
            return _positionOfMarker
        }
        set {
            _positionOfMarker = newValue
        }
    }
    
    func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        _positionOfMarker = end
        
        let origin = "\(start.latitude),\(start.longitude)"
        let destination = "\(end.latitude),\(end.longitude)"
        
        let urlRequest = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)"
        guard let url = URL(string: urlRequest) else {return}
        DispatchQueue.main.async {
            self.requestAPI(url: url)
        }
    }
    
    func requestAPI(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else {return}
            do {
                self._polyLines = try JSONDecoder().decode(Polylines.self, from: data)
                NotificationCenter.default.post(name: notificationJSON, object: nil)
            } catch let error {
                print("\(error)")
            }
        }).resume()
    }
    
    
    
}
