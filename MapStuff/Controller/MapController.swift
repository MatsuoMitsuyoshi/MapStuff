//
//  MapController.swift
//  MapStuff
//
//  Created by mitsuyoshi matsuo on 2019/04/14.
//  Copyright © 2019 mitsuyoshi matsuo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController {
    
    // MARK: - Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var searchInputView: SearchInputView!

    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        enableLocationServices()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnUserLocation(shouldLoadAnnotations: true)
    }

    // MARK: - Selectors
    
    @objc func handleCenterLocation() {
        centerMapOnUserLocation(shouldLoadAnnotations: false)
    }

    
    // MARK: - Hepler Functions
    // viewの構成要素
    func configureViewComponents() {
        view.backgroundColor = .white
        configureMapView()
    
        // サーチバー
        searchInputView = SearchInputView()
        searchInputView.delegate = self
        searchInputView.mapController = self
        
        view.addSubview(searchInputView)
        searchInputView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(view.frame.height - 88), paddingRight: 0, width: 0, height: view.frame.height)
        
        // センターマップボタン
        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: nil, left: nil, bottom: searchInputView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 50, height: 50)
    }
    
    // MapViewの設定
    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view: view)
    }
}

// MARK: - SearchCellDelegate

extension MapController: SearchCellDelegate {
    
    func getDirections(forMapItem mapItem: MKMapItem) {
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func distanceFromUser(location: CLLocation) -> CLLocationDistance? {
        guard let userLocation = locationManager.location else { return nil }
        return userLocation.distance(from: location)
    }
}

// MARK: - SearchInputViewDelegate

extension MapController: SearchInputViewDelegate {
    
    func handleSearch(withSearchText searchText: String) {
        
        removeAnnotations()
        loadAnnotations(withSearchQuery: searchText)
    }
    
    func animateCenterMapButton(expansionState: SearchInputView.ExpansionState, hideButton: Bool) {
        
        switch expansionState {
        case .NotExpanded:
            UIView.animate(withDuration: 0.25) {
                self.centerMapButton.frame.origin.y -= 250
            }

            if hideButton {
                self.centerMapButton.alpha = 0

            } else {
                self.centerMapButton.alpha = 1
            }

        case .PartiallyExpanded:
            if hideButton {
                self.centerMapButton.alpha = 0
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.centerMapButton.frame.origin.y += 250
                }
            }
 
        case .FullyExpanded:
            UIView.animate(withDuration: 0.25) {
                self.centerMapButton.alpha = 1
            }
        }
    }
}


// MARK: - MapKit helper Functions

extension MapController {
    
    func centerMapOnUserLocation(shouldLoadAnnotations: Bool) {
        
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        if shouldLoadAnnotations {
            loadAnnotations(withSearchQuery: "Coffee Shops")
        }
    }
    
    func searchBy(naturalLaunguageQuery: String, region: MKCoordinateRegion, coordinates: CLLocationCoordinate2D, completion: @escaping (_ response: MKLocalSearch.Response?, _ error: NSError?) -> ()) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = naturalLaunguageQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                completion(nil, error! as NSError)
                return
            }
            
            completion(response, nil)
            
        }
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func loadAnnotations(withSearchQuery query: String) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        searchBy(naturalLaunguageQuery: query, region: region, coordinates: coordinate) { (response, error) in
            
            response?.mapItems.forEach({ (mapItem) in
                
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            })
            
            self.searchInputView.searchResults = response?.mapItems
        }
    }
    
    
}

// MARK: - CLLocationManagerDelegate

extension MapController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 位置情報の認証チェック
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location auth status is NOT DETERMINED") // 許可、不許可を選択していない
            // UI更新処理（許可・不許可の選択なくとも非同期でUI更新）
            DispatchQueue.main.async {
                
                let controller = LocationRequestController()
                controller.locationManager = self.locationManager
                self.present(controller, animated: true, completion: nil)
            }
            
        case .restricted:
            print("Location auth status is RESTRICTED") // 機能制限している
        case .denied:
            print("Location auth status is DENIED") // 許可していない
        case .authorizedAlways:
            print("Location auth status is AUTHORIZED ALWAYS") // 常に許可
        case .authorizedWhenInUse:
            print("Location auth status is AUTHORIZED WHEN IN USE") // アプリの使用中のみ許可
        }
    }
}
