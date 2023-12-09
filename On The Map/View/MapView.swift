import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
    func didtapLogout()
}

final class MapView: UIView {

    // MARK: - Properties

    weak var delegate: MapViewDelegate?

    // MARK: - UI

    lazy var logoutButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        barButtonItem.title = "Logout"
        return barButtonItem
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.isMultipleTouchEnabled = true
        mapView.showsCompass = true
        return mapView
    }()

    // MARK: - API

    func setupView() {
        backgroundColor = .white
        addViewHierarchy()
    }

    // MARK: View

    private func addViewHierarchy() {
        addSubview(mapView)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    // MARK: - UIActions

    @objc private func logoutAction(_ sender: UIBarButtonItem) {
        delegate?.didtapLogout()
    }
}
