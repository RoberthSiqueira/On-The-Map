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
            print(studentLocations)
        } else {
            print(error)
        }
    }

    private func handleRequestLogout(success: Bool, error: Error?) {
        if success && error == nil {
            navigationController?.parent?.navigationController?.popViewController(animated: true)
        }
    }
}

extension MapViewController: MapViewDelegate {
    func didtapLogout() {
        requestLogout()
    }
}

extension MapViewController: MKMapViewDelegate {

}
