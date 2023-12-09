import UIKit

class MapViewController: UIViewController {

    let mapView = MapView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        view = mapView
    }

    private func setupNavigation() {
        navigationItem.title = "On The Map"
        navigationItem.setLeftBarButton(mapView.logoutButton, animated: true)
    }
}

extension MapViewController: MapViewDelegate {
    func didtapLogout() {
        print("Logout Please")
    }
}
