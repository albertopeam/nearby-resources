//
//  ResourcesView.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit
import GoogleMaps

final class NearbyResourcesView: UIView {

    let mapView: GMSMapView
    let activityIndicator: UIActivityIndicatorView
    let snackBarView: SnackBarView

    init(_ camera: GMSCameraPosition) {
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        activityIndicator = .init(style: .large)
        snackBarView = .init()
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NearbyResourcesView {
    enum ViewTraits {
        static var indicator: UIEdgeInsets = .init(top: 16, left: 0, bottom: 0, right: -16)
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        snackBarView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.settings.indoorPicker = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black

        addSubview(mapView)
        addSubview(snackBarView)
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),

            activityIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ViewTraits.indicator.top),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ViewTraits.indicator.right),

            snackBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            snackBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            snackBarView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
