//
//  ViewController.swift
//  Camil_Zaim_multec_Werkstuk2
//
//  Created by Bilal Bounour.
//  Copyright © 2018 Bilal Bounour. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct Villo:Decodable {
    let number: Int
    let name: String
    let position: Locatie?
}

struct Locatie:Decodable {
    let lat: Double
    let lng: Double
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var lblnaam: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    
    
    @IBAction func btnFrancais(_ sender: UIButton) {
        let namen = Bundle.main.path(forResource: "fr", ofType: "lproj")
        let FR = Bundle.init(path: namen!)! as Bundle
        lblnaam.text = FR.localizedString(forKey: "naam", value: nil, table: nil)
    }
    
    @IBAction func btnNederlands(_ sender: UIButton) {
        let namen = Bundle.main.path(forResource: "nl", ofType: "lproj")
        let NL = Bundle.init(path: namen!)! as Bundle
        lblnaam.text = NL.localizedString(forKey: "naam", value: nil, table: nil)
    }
    
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let url = "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            
            do{
                let Villobxl = try JSONDecoder().decode([Villo].self, from: data!)
                
                for villo in Villobxl {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: (villo.position?.lat)!, longitude: (villo.position?.lng)!)
                    annotation.title = villo.name
                    annotation.subtitle = villo.name
                    
                    self.mapView.addAnnotation(annotation)
                }
            } catch{
                print("Error")
            }
            }.resume()
        
        refreshDate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    
    
    func refreshDate() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        lblTime.text = "Laatste refresh :\(hour):\(minutes)"
    }
}
