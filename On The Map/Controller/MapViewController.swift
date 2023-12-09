import UIKit

class MapViewController: UIViewController {

    // MARK: - Properties

    let mapView = MapView(frame: .zero)

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        mapView.delegate = self
        view = mapView
    }

    // MARK: - Methods

    private func setupNavigation() {
        navigationItem.title = "On The Map"
        navigationItem.setLeftBarButton(mapView.logoutButton, animated: true)
    }

    private func requestLogout() {
        Client.deleteSession(completion: handleRequestLogout(success:error:))
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
