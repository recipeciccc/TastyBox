//
//  StoresMapViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-01-23.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Crashlytics

class StoresMapViewController: UIViewController{
    var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    let apiKey = KeyManager().getValue(key:"apiKey") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
       

        if CLLocationManager.locationServicesEnabled() {
          switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
              print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
              print("Access")
          default:
            break
          }
        } else {
          print("Location services are not enabled")
        }
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
          switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
              print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
              print("Access")
            
          default:
            break
          }
        } else {
          print("Location services are not enabled")
        }
    }
    
    func getSupermarketImformation()  {
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&radius=4500&type=supermarket&key=\(apiKey!)")!
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
            
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let root = try decoder.decode(Root.self, from: data!)
//                print(root)
                self.createMarkers(root: root)
               
            } catch {
                print(error)
            }
        }
        
        
        
        task.resume()
        
        
    }

    private func createMarkers(root: Root) {
        
        var markers: [GMSMarker] = []
        let places:[SearchResult] = root.results
        
        for place in places {
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.geometry.location.lat , longitude: place.geometry.location.lng)
            marker.title = "\(place.name)"
            marker.snippet = "\(place.vicinity)"
            markers.append(marker)
            marker.map = mapView!
        }
        
    }
    
    
    func createMap() {
        
        
        locationManager.startUpdatingLocation()
      
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude, zoom: 15);
        
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)           
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        self.view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        getSupermarketImformation()

        locationManager.stopUpdatingLocation()
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

extension StoresMapViewController: GMSMapViewDelegate {
     func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            
            let word = marker.snippet!.split(separator: ",")
            var result = ""
            
            for value in word {
                for char in value {
                    var temp = String(char)
                    if char == " " {
                        temp = ",+"
                    }
                    result += temp
                }
            }
             
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                
                let urlHasAddressAndName:String? =         "comgooglemaps://?q=\(result),+\(marker.title!)&center=\(marker.position.latitude),\(marker.position.longitude)&zoom=14&views=traffic"
                
                let  urlHasAddress:String? =         "comgooglemaps://?q=\(result)&center=\(marker.position.latitude),\(marker.position.longitude)&zoom=14&views=traffic"
                
                let url = URL(string: urlHasAddressAndName!) ?? URL(string: urlHasAddress!)
                
                UIApplication.shared.openURL(url!)
                
             } else {
               print("Can't use comgooglemaps://");
             }
        }
}

extension StoresMapViewController: CLLocationManagerDelegate {
    
    // this is called as soon as changing status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            createMap()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)        
        locationManager.stopUpdatingLocation()
        
    }
    

}
