//
//  MapViewController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var inviteDrawerContainerView: UIView!
    @IBOutlet weak var closeDrawerButton: UIButton!
    
    //MARK: - Properties
    weak var inviteVC: InviteDrawerViewController?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    var directionsArray:[MKDirections] = []
    var businessSearchResult: [Business] = []
    var drawerIsHidden: Bool = true
    var searchController: UISearchController?
    
    //TODO: - Fix this? Maybe delete
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        inviteDrawerContainerView.isHidden = true
        mapView.register(MKPointAnnotation.self, forAnnotationViewWithReuseIdentifier: "pinView")
        closeDrawerButton.isEnabled = false
        setUpSearchController()
//        InviteController.shared.fetchInvite { (success) in
//            if success {
//                DispatchQueue.main.async {
//                    self.reloadInputViews()
//                }
//            }
//        }
    }
    
    func setUpSearchController() {
        searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController?.searchBar.delegate = self
    }
    
    func setupLocationmanager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func showDrawer() {
        closeDrawerButton.isEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            if self.drawerIsHidden {
                self.inviteDrawerContainerView.isHidden = false
                self.drawerIsHidden = false
            } else {
                self.inviteDrawerContainerView.isHidden = false
                self.drawerIsHidden = false
            }
        }) { (success) in
            if success {
                print("Successfully animated drawer view")
            } else {
                print("Drawer is jammed")
            }
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationmanager()
            checkLocationAuthorization()
        } else {
            let alertController = UIAlertController(title: "Location Services", message: "TFTI needs will not work without your access to your location. Please go to Settings -> Privacy -> Location Services and select 'While Using'.", preferredStyle: .alert)
            self.present(alertController, animated: true)
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.delegate = self
            startTrackingUserLocation()
            break
        case .denied:
            let alertController = UIAlertController(title: "Location Services", message: "TFTI needs will not work without your access to your location. Please go to Settings -> Privacy -> Location Services and select 'While Using'.", preferredStyle: .alert)
            self.present(alertController, animated: true)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let alertController = UIAlertController(title: "Location Services", message: "Disable Restrictions to use TFTI", preferredStyle: .alert)
            self.present(alertController, animated: true)
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
    func getCenterLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getTopResultLocation(business: Business) {
        let coordinate = CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D, destination: MKPlacemark) -> MKDirections.Request {
        let startingLocation = MKPlacemark(coordinate: coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        
        
        return request
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.remove(at: 0)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.inviteDrawerContainerView.isHidden = true
        
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        BusinessController.fetchBusiness(term: searchText, location: nil, latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude) { (results) in
            DispatchQueue.main.async {
                self.fetchBusinessAnnotation(businesses: results)
            }
        }
    }
    
    //MARK: - annotation functions
    
    func fetchBusinessAnnotation(businesses: [Business]) {
        
        var annotations : [BusinessAnnotation] = []
        for business in businesses {
            let annotation = BusinessAnnotation(business: business)
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        getTopResultLocation(business: businesses[0])
        searchController?.isActive = false
    }
    
    func fetchInviteAnnotation(invites: [Invite]) {
        mapView.removeAnnotations(mapView.annotations)
        var annotations : [InviteAnnotation] = []
        for invite in invites {
            let annotation = InviteAnnotation(invite: invite)
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
//        searchController?.isActive = false
    }
    
    //MARK: - Map Drawer Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInviteDrawerVC" {
            let inviteDrawer = segue.destination as? InviteDrawerViewController
            inviteDrawer?.delegate = self
            
            self.inviteVC = inviteDrawer
        }
    }
    
    //MARK: - Actions
    
    @IBAction func findMyLocationButtonTapped(_ sender: Any) {
        startTrackingUserLocation()
    }
    
    
    @IBAction func drawerCloseButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.drawerIsHidden {
                self.inviteDrawerContainerView.isHidden = false
                self.drawerIsHidden = false
            } else {
                self.inviteDrawerContainerView.isHidden = true
                self.drawerIsHidden = true
            }
        }) { (success) in
            if success {
                print("Successfully animated drawer view")
            } else {
                print("Drawer is jammed")
            }
        }
    }
    
} // End Of Class

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       // guard let annotation = annotation as? BusinessAnnotation else { return nil }
        
        var view: MKPinAnnotationView
        if let businessAnnotation = annotation as? BusinessAnnotation {
            let identifier = "marker"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = businessAnnotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: businessAnnotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                        size: CGSize(width: 30, height: 30)))
                mapsButton.setBackgroundImage(UIImage(named: "mapsIcon"), for: UIControl.State())
                view.rightCalloutAccessoryView = mapsButton
            }
            return view
        } else if let inviteAnnotation = annotation as? InviteAnnotation {
            let identifier = "marker"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = inviteAnnotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: inviteAnnotation, reuseIdentifier: identifier)
                view.pinTintColor = .purple
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                        size: CGSize(width: 30, height: 30)))
                mapsButton.setBackgroundImage(UIImage(named: "mapsIcon"), for: UIControl.State())
                view.rightCalloutAccessoryView = mapsButton
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! BusinessAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? BusinessAnnotation,
            let inviteVC = self.inviteVC
            else { return }
        
        inviteVC.updateViewsWith(business: annotation.business)
        self.business = annotation.business
        
        showDrawer()
    }
}

extension MapViewController: InviteViewControllerDelegate {
    
    
    func createEventButtonTapped() {
        guard let business = business else {return}
        let location = CLLocation(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
        InviteController.shared.createInviteWith(venue: business.name, location:location) { (success) in
            DispatchQueue.main.async {
                self.fetchInviteAnnotation(invites: InviteController.shared.currentInvites)
            }
        }
    }
    
    func viewContactsButtonTapped() {
        //
    }
    
    func timeSelectorTapped() {
        //
    }
}
