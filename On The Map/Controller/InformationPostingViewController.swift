import MapKit
import UIKit

class InformationPostingViewController: UIViewController {

    // MARK: - Properties

    let informationPostingView = InformationPostingView(frame: .zero)

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()

        informationPostingView.setupView()
        informationPostingView.delegate = self
        view = informationPostingView
    }

    // MARK: - Methods

    private func setupNavigation() {
        navigationItem.title = "Add Location"
        navigationItem.setLeftBarButton(informationPostingView.cancelButton, animated: true)
    }

    private func requestLocation(_ location: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, _ in
            guard let response = response,
                  let mapItem = response.mapItems.first else {
                self?.informationPostingView.dataRequested(success: false)
                self?.informationPostingView.findingErrorState(shouldShow: true, message: "Please, check the text from Location")
                return
            }

            let locality = "\(mapItem.placemark.locality ?? ""), \(mapItem.placemark.administrativeArea ?? ""), \(mapItem.placemark.country ?? "")"

            self?.createAnnotation(coordinate: mapItem.placemark.coordinate, title: locality)
            
            self?.informationPostingView.dataRequested(success: true)
        }
    }

    private func createAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title

        informationPostingView.addAnnotation(annotation)
    }

    private func saveNewLocation() {
        informationPostingView.requestingData()
        Client.getUser(completion: handleGetUser(user:error:))
    }

    private func handleGetUser(user: User?, error: Error?) {
        if user?.location == nil && error == nil {
            // post
            print(user)
            print(error)
        } else if user?.location != nil && error == nil {
            // put
            print(user)
            print(error)
        } else {
            let alert = UIAlertController(title: "Locations unavailable", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension InformationPostingViewController: InformationPostingViewDelegate {
    func didtapCancel() {
        navigationController?.popViewController(animated: true)
    }

    func didtapFindLocation(location: String, mediaURL: String) {
        informationPostingView.requestingData()
        requestLocation(location)
    }

    func didtapFinish() {
        saveNewLocation()
    }
}
