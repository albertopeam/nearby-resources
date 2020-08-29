//
//  ResourcesViewController.swift
//  NearbyResources
//
//  Created by Alberto Penas Amor on 25/08/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit
import GoogleMaps
import Combine

final class NearbyResourcesViewController: UIViewController {

    let nearbyView: NearbyResourcesView
    private let viewModel: NearbyViewModel
    private var subscriptions: Set<AnyCancellable> = .init()
    private var icons: [CGFloat: UIImage] = [:]

    init(viewModel: NearbyViewModel, camera: GMSCameraPosition) {
        self.viewModel = viewModel
        nearbyView = .init(camera)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension NearbyResourcesViewController {
    func setup() {
        nearbyView.mapView.delegate = self
        view.addSubview(nearbyView)
        NSLayoutConstraint.activate([
            nearbyView.topAnchor.constraint(equalTo: view.topAnchor),
            nearbyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nearbyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nearbyView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    func getResources() {
        subscriptions.removeAll()
        viewModel.resources(for: latLngBounds())
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.nearbyView.activityIndicator.startAnimating() })
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.nearbyView.activityIndicator.stopAnimating()
                if case let Subscribers.Completion.failure(error) = completion {
                    self.nearbyView.snackBarView.show(message: error.message)
                }
            }, receiveValue: { [weak self] resources in
                guard let self = self else { return }
                self.nearbyView.activityIndicator.stopAnimating()
                self.nearbyView.mapView.clear()
                resources.forEach({
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: $0.latLng.latitude, longitude: $0.latLng.longitude)
                    marker.title = $0.name
                    marker.map = self.nearbyView.mapView
                    if let icon = self.icons[CGFloat($0.hue)] {
                        marker.icon = icon
                    } else {
                        let icon = GMSMarker.markerImage(with: UIColor(hue: CGFloat($0.hue), saturation: 1, brightness: 1, alpha: 1))
                        self.icons[CGFloat($0.hue)] = icon
                        marker.icon = icon
                    }
                })
            })
            .store(in: &subscriptions)
    }

    private func latLngBounds() -> LatLngBounds {
        let region = nearbyView.mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        return LatLngBounds(northEast: .init(latitude: bounds.northEast.latitude, longitude: bounds.northEast.longitude), southWest: .init(latitude: bounds.southWest.latitude, longitude: bounds.southWest.longitude))
    }
}

extension NearbyResourcesViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getResources()
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        nearbyView.mapView.selectedMarker = marker;
        return true
    }
}
