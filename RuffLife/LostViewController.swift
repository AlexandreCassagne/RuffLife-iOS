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

class LostViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default ()
    var mapView: MKMapView!
//    let annotation = MKPointAnnotation()
    var locationManager = CLLocationManager()
	
	@objc func call(sender: Any) {
		if let url = NSURL(string: "tel://\(5555555555)"), UIApplication.shared.canOpenURL(url as URL) {
			UIApplication.shared.openURL(url as URL)
		}

	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			if annotation is MKUserLocation {
				//return nil so map view draws "blue dot" for standard user location
				return nil
			}
			
			let reuseId = "pin"
			
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
			if pinView == nil {
				pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
				pinView!.canShowCallout = true
				pinView!.animatesDrop = true
				pinView!.pinColor = .purple
				let btn = UIButton(type: .detailDisclosure)
				btn.addTarget(self, action: #selector(call), for: .touchDown)
				pinView?.rightCalloutAccessoryView = btn
			}
			else {
				pinView!.annotation = annotation
			}
			
			return pinView

	}
	
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
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as! CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.setRegion(region, animated: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        //Zoom to user location
        var noLocation = CLLocationCoordinate2D()
        noLocation.latitude = 42.380999
        noLocation.longitude = -71.124998
        var viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 200, 200)
        mapView.setRegion(viewRegion, animated: true)
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }

       // Querying dynambodb
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        dynamoDBObjectMapper.scan(RuffLife.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let resultModel = task.result{
                // Do something with task.result.
                for result in resultModel.items {
                    let convertResult = result as! RuffLife
                    let newAnnotation = MKPointAnnotation()
                    newAnnotation.title = convertResult.Breed
					newAnnotation.subtitle = "Call \(convertResult.PhoneNumber!)"
                    newAnnotation.coordinate = CLLocationCoordinate2D(latitude: convertResult.lat! as! Double, longitude: convertResult.lon! as! Double)
                    self.mapView.addAnnotation(newAnnotation)
                }
                
            }
            return nil
        })
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
}


