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

        mapView.requestingData()
        requestStudentLocations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Methods

    private func setupNavigation() {
        navigationItem.title = "On The Map"
        navigationItem.setLeftBarButton(mapView.logoutButton, animated: true)
        navigationItem.setRightBarButtonItems([mapView.plusButton, mapView.refreshButton], animated: true)
    }

    private func requestStudentLocations() {
        mapView.requestingData()
        Client.getStudentLocation(completion: handleRequestStudentLocations(studentLocations:error:))
    }

    private func requestLogout() {
        mapView.requestingData()
        Client.deleteSession(completion: handleRequestLogout(success:error:))
    }

    private func handleRequestStudentLocations(studentLocations: [StudentLocation], error: Error?) {
        if !studentLocations.isEmpty && error == nil {
            createAnnotations(by: studentLocations)
        } else {
            let alert = UIAlertController(title: "Locations unavailable", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        mapView.dataRequested()
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

extension MapViewController: BarItemsActionsProtocol {
    func didtapLogout() {
        requestLogout()
    }

    func didtapReloadLocations() {
        requestStudentLocations()
    }

    func didtapInformationPosting() {
        let informationPostingVC = InformationPostingViewController()
        navigationController?.pushViewController(informationPostingVC, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

}
