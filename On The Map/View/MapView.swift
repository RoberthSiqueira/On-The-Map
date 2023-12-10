import UIKit
import MapKit

final class MapView: UIView {

    // MARK: - Properties

    weak var delegate: BarItemsActionsProtocol?

    // MARK: - UI

    lazy var logoutButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutAction))
        barButtonItem.title = "LOGOUT"
        return barButtonItem
    }()

    lazy var plusButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(informationPostingAction))
        return barButtonItem
    }()

    lazy var refreshButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadLocationsAction))
        return barButtonItem
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
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
        mapView.delegate = self
        mapView.isHidden = true
        return mapView
    }()

    // MARK: - API

    func setupView() {
        backgroundColor = .white
        addViewHierarchy()
    }

    func setupAnnotations(annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }

    func requestingData() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        mapView.isHidden = true
    }

    func dataRequested() {
        loadingIndicator.stopAnimating()
        mapView.isHidden = false
    }

    // MARK: View

    private func addViewHierarchy() {
        addSubview(loadingIndicator)
        addSubview(mapView)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])

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

    @objc private func reloadLocationsAction(_ sender: UIBarButtonItem) {
        delegate?.didtapReloadLocations()
    }

    @objc private func informationPostingAction(sender: UIBarButtonItem) {
        delegate?.didtapInformationPosting()
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.markerTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let mediaURL = view.annotation?.subtitle {
                guard let url = URL(string: mediaURL ?? "") else { return }
                app.open(url)
            }
        }
    }
}
