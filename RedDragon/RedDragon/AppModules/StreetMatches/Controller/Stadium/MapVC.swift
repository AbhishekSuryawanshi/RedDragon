//
//  MapVC.swift
//  RedDragon
//
//  Created by Remya on 12/1/23.
//

import UIKit
import MapKit

protocol SetLocationDelegate{
    func sendChosenLocation(address:String,lat:String,long:String)
}

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var delg:SetLocationDelegate?
    var delegate:SetLocationDelegate?
    var address = ""
    var lat = ""
    var long = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionSetLocation(_ sender: Any) {
        delg?.sendChosenLocation(address: address, lat: lat, long: long)
        navigationController?.popViewController(animated: true)
        
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }


  

}


extension MapVC: MKMapViewDelegate,CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       let coordinate = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        self.lat = "\(coordinate.latitude)"
        self.long = "\(coordinate.longitude)"
        getAddressFromLatLon(center: coordinate) { adr in
            self.address = adr
        }
    }
    
    func getAddressFromLatLon(center:CLLocationCoordinate2D,completion: @escaping (String)->()){
        
            let ceo: CLGeocoder = CLGeocoder()

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                       
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print(addressString)
                        completion(addressString)
                        
                  }
            })

        }
    
}
