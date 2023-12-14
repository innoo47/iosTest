//
//  MapViewController.swift
//  iosTest
//
//  Created by 박인호 on 12/12/23.
//

import UIKit
import NMapsMap // 네이버 지도
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locationOverlay: NMFLocationOverlay?
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView() // 지도 객체 생성
        mapView.allowsZooming = true // 줌 가능
        mapView.logoInteractionEnabled = false // 로고 터치 불가능
        mapView.allowsScrolling = true // 스크롤 가능
        self.locationOverlay = mapView.locationOverlay // overlay 객체 생성
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setLocationData()
        self.setUI()
        
//        naverMapView.touchDelegate = self
        
    }
    
    
    // UI 설정
    func setUI() {
        
        // 슈퍼뷰에 지도 뷰를 서브뷰로 넣어줌
        view.addSubview(naverMapView)

        // constraints 사용하기 위함
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
            
        // constraints 세팅
        naverMapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        naverMapView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        naverMapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        naverMapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
    }
    
    // 혅재 위치
    func setLocationData() {
        
        // locationManager 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치 업데이트의 정확도 설정 (최고 정확도)
        locationManager.requestWhenInUseAuthorization() // 위치 서비스를 사용하는 동안 앱의 위치 접근 권한을 요청
        locationManager.startUpdatingLocation() // 위치 업데이트 시작

        // 위도, 경도 가져오기
        let latitude = locationManager.location?.coordinate.latitude ?? 0
        let longitude = locationManager.location?.coordinate.longitude ?? 0
        print("latitude : \(latitude), longitude : \(longitude)")
        
        // 네이버지도를 내위치 주변으로 보여지게끔 설정
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 7)
        naverMapView.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn
        
        // 오버레이를 내 위치의 위도,경도로 설정
        guard let locationOverlay = locationOverlay else { return }
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude) // 오버레이 위치
//        locationOverlay.icon = NMFOverlayImage(name: "marker_icon") // 오버레이 아이콘 이미지
        
    }

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng.lat), \(latlng.lng)")
        // 탭된 위치에 대한 처리 추가
    }

    

   

}
