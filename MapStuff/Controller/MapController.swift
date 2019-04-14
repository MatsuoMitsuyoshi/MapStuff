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


    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnUserLocation()
    }

    // MARK: - Hepler Functions
    // viewの構成要素
    func configureViewComponents() {
        view.backgroundColor = .white
        
        configureMapView()
        enableLocationServices()
        
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

// MARK: - MapKit helper Functions

extension MapController {
    
    func centerMapOnUserLocation() {
        
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
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
