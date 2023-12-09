import UIKit

class ListViewController: UIViewController {

    // MARK: - Properties

    let listView = ListView(frame: .zero)

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()

        listView.setupView()
        listView.delegate = self
        view = listView

        requestStudentLocations()
    }

    // MARK: - Methods

    private func setupNavigation() {
        navigationItem.title = "On The Map"
        navigationItem.setLeftBarButton(listView.logoutButton, animated: true)
    }

    private func requestStudentLocations() {
        Client.getStudentLocation(completion: handleRequestStudentLocations(studentLocations:error:))
    }

    private func requestLogout() {
        Client.deleteSession(completion: handleRequestLogout(success:error:))
    }

    private func handleRequestStudentLocations(studentLocations: [StudentLocation], error: Error?) {
        if !studentLocations.isEmpty && error == nil {
            populateTableView(with: studentLocations)
        } else {
            print(error)
        }
    }

    private func handleRequestLogout(success: Bool, error: Error?) {
        if success && error == nil {
            navigationController?.parent?.navigationController?.popViewController(animated: true)
        }
    }

    private func populateTableView(with studentLocations: [StudentLocation]) {
        listView.updateLocations(with: studentLocations)
    }
}

extension ListViewController: LogoutProtocol {
    func didtapLogout() {
        requestLogout()
    }
}
