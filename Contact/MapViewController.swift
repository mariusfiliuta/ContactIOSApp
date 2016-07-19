//
//  MapViewController.swift
//  Contact
//
//  Created by intern on 18/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius * 2.0,regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    var contact: Contact!
    
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
        let location = sender.locationInView(mapView)
        let coordinates = mapView.convertPoint(location, toCoordinateFromView: mapView)
        
        if contact.location == nil{
            contact.location = MKPointAnnotation()
            contact.location!.coordinate = coordinates
            mapView.addAnnotation(contact.location!)
        }else{
            contact.location!.coordinate = coordinates
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === saveButton{
            
        }
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPointAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        }
        return nil
    }
}
