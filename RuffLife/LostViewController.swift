//
//  LostViewController.swift
//  RuffLife
//
//  Created by Alexandre Cassagne on 21/10/2017.
//  Copyright © 2017 Cassagne. All rights reserved.
//

import UIKit
import MapKit
import AWSDynamoDB
import CoreLocation

class LostViewController: UIViewController, CLLocationManagerDelegate {
    var dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default ()
    var mapView: MKMapView!
    let annotation = MKPointAnnotation()
     let locationManager = CLLocationManager()
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set it as *the* view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self,
                                   action: #selector(MapViewController.mapTypeChanged(_:)),
                                   for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]){
        mapView.removeAnnotation(annotation)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
       // locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        //Querying dynambodb
//        dynamoDBObjectMapper.load(RuffLife.self, hashKey: 0, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//            } else if let resultModel = task.result as? RuffLife {
//                // Do something with task.result.
//                self.annotation.coordinate = CLLocationCoordinate2D(latitude: resultModel.lat! as! Double, longitude: resultModel.lon! as! Double)
//            }
//            return nil
//        })
        
    }

}
