import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties

    let mapView = MapView(frame: .zero)

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()

        mapView.setupView()
        mapView.delegate = self
        view = mapView

        requestStudentLocations()
    }

    // MARK: - Methods

    private func setupNavigation() {
        navigationItem.title = "On The Map"
        navigationItem.setLeftBarButton(mapView.logoutButton, animated: true)
    }

    private func requestStudentLocations() {
        Client.getStudentLocation(completion: handleRequestStudentLocations(studentLocations:error:))
    }

    private func requestLogout() {
        Client.deleteSession(completion: handleRequestLogout(success:error:))
    }

    private func handleRequestStudentLocations(studentLocations: [StudentLocation], error: Error?) {
        if !studentLocations.isEmpty && error == nil {
            createAnnotations(by: studentLocations)
        } else {
            print(error)
        }
    }

    private func handleRequestLogout(success: Bool, error: Error?) {
        if success && error == nil {
            navigationController?.parent?.navigationController?.popViewController(animated: true)
        }
    }

    private func createAnnotations(by studentLocations: [StudentLocation]) {
        var annotations: [MKAnnotation] = []

        for location in studentLocations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL

            annotations.append(annotation)
        }
        mapView.setupAnnotations(annotations: annotations)
    }
}

extension MapViewController: MapViewDelegate {
    func didtapLogout() {
        requestLogout()
    }
}
