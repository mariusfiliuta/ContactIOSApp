//
//  MapViewController.swift
//  Contact
//
//  Created by intern on 18/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
        let initialLocation:CLLocation
        // Set pin if any location on contact
        if contact.location != nil {
            mapView.addAnnotation(contact.location!)
            initialLocation = CLLocation(latitude: contact.location!.coordinate.latitude, longitude: contact.location!.coordinate.longitude)
        }else{
            initialLocation =  CLLocation(latitude: 44.426164962, longitude: 26.102332924)
        }
        
        // set initial location in Bucharest
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // User Location Update, if any.
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
        // Save button can't be pushed if nothing changed
        saveButton.enabled = false
        
        // Search Controller
        searchBar.delegate = self
        self.definesPresentationContext = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    // Contact
    var contact: Contact!
    // Location Info
    var locationManager:CLLocationManager!
    var userAnnotation:MKPointAnnotation?
    var contactAnnotation:MKPointAnnotation?
    var userContactRoute: MKRoute!
    var userLocation: MKPlacemark!
    var contactLocation: MKPlacemark!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    // MARK: Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode{
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController!.popViewControllerAnimated(true)
        }
    }
    @IBAction func longTapOnMapView(sender: UILongPressGestureRecognizer) {
        // Disable save button while long tapping
        saveButton.enabled = false
        
        
        let location = sender.locationInView(mapView)
        let coordinates = mapView.convertPoint(location, toCoordinateFromView: mapView)
        
        updateContactLocation(coordinates)
        
        
        if sender.state == UIGestureRecognizerState.Ended{
            if userContactRoute != nil{
                mapView.removeOverlay(userContactRoute.polyline)
            }
            if userAnnotation != nil{
                getDirections()
            }
            saveButton.enabled = true
        }
    }
    
    
    func updateContactLocation(coordinates: CLLocationCoordinate2D){
        if contactAnnotation == nil{
            contactAnnotation = MKPointAnnotation()
            contactAnnotation!.coordinate = coordinates
            contactAnnotation!.title = "Contact Location"
            mapView.addAnnotation(contactAnnotation!)
            
        }else{
            contactAnnotation!.coordinate = coordinates
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === saveButton{
            contact.location = contactAnnotation
        }
    }

    // MARK: Map Kit & Core Manager Delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: userContactRoute.polyline)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPointAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        }
        return nil
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        if userAnnotation != nil{
            userAnnotation!.coordinate = center
        }else{
            
            // Set the Annotation for user location
            userAnnotation = MKPointAnnotation()
            userAnnotation!.coordinate = center
            userAnnotation!.title = "Your location"
            mapView.showsUserLocation = true
            mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
            
            // Set region to view on user location
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(userAnnotation!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            if contactAnnotation != nil {
                getDirections()
            }
        }
        if contactAnnotation != nil && locations.count>1 && location!.distanceFromLocation(locations[locations.count-2]) > 200 {
            getDirections()
        }

    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Nothings happen
    }
    // MARK: Route
    func getDirections() {
        
        if userContactRoute != nil{
            mapView.removeOverlay(userContactRoute.polyline)
        }
        let directionsRequest = MKDirectionsRequest()
        self.userLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(userAnnotation!.coordinate.latitude, userAnnotation!.coordinate.longitude), addressDictionary: nil)
        self.contactLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(contactAnnotation!.coordinate.latitude, contactAnnotation!.coordinate.longitude), addressDictionary: nil)
        directionsRequest.source = MKMapItem(placemark: userLocation)
        directionsRequest.destination = MKMapItem(placemark: contactLocation)
        
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculateDirectionsWithCompletionHandler({
            response, error in
            
            if error == nil {
                self.userContactRoute = response!.routes[0] as MKRoute
                self.mapView.addOverlay(self.userContactRoute.polyline)
                self.mapView.setVisibleMapRect(self.userContactRoute.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50.0,left: 50.0,bottom: 50.0,right: 50.0), animated: true)
            }
            
        })
    }
    
    
    // Search Controller & Search Bar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            self.updateContactLocation(coordinates)
            if self.userContactRoute != nil{
                self.mapView.removeOverlay(self.userContactRoute.polyline)
            }
            if self.userAnnotation != nil{
                self.getDirections()
            }
            self.saveButton.enabled = true
        
        }
    }
    

}
