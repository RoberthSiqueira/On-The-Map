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

    private func saveNewLocation(annotation: MKAnnotation, mediaURL: String) {
        informationPostingView.requestingData()
        Client.getUser { [weak self] user, error in
            self?.handleGetUser(annotation: annotation, mediaURL: mediaURL, user: user, error: error)
        }
    }

    private func handleGetUser(annotation: MKAnnotation, mediaURL: String, user: User?, error: Error?) {
        if let user = user, error == nil {
            let locality: String = (annotation.title ?? "") ?? ""
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude

            let userModelView = UserModelView(firstName: user.firstName,
                                              lastName: user.lastName,
                                              locality: locality,
                                              mediaURL: mediaURL,
                                              latitude: latitude,
                                              longitude: longitude)
            Client.postStudentLocation(user: userModelView, completion: handlePostStudentLocation(success:error:))
        } else {
            let alert = UIAlertController(title: "Locations unavailable", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    private func handlePostStudentLocation(success: Bool, error: Error?) {
        if success {
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Error to finish", message: error?.localizedDescription, preferredStyle: .alert)
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

    func didtapFinish(annotation: MKAnnotation, mediaURL: String) {
        saveNewLocation(annotation: annotation, mediaURL: mediaURL)
    }
}
