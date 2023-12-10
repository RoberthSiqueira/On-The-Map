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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Methods

    private func setupNavigation() {
        navigationItem.title = "On The Map"
        navigationItem.setLeftBarButton(listView.logoutButton, animated: true)
        navigationItem.setRightBarButtonItems([listView.plusButton, listView.refreshButton], animated: true)
    }

    private func requestStudentLocations() {
        listView.requestingData()
        Client.getStudentLocation(completion: handleRequestStudentLocations(studentLocations:error:))
    }

    private func requestLogout() {
        listView.requestingData()
        Client.deleteSession(completion: handleRequestLogout(success:error:))
    }

    private func handleRequestStudentLocations(studentLocations: [StudentLocation], error: Error?) {
        if !studentLocations.isEmpty && error == nil {
            populateTableView(with: studentLocations)
        } else {
            let alert = UIAlertController(title: "Locations unavailable", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        listView.dataRequested()
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

extension ListViewController: BarItemsActionsProtocol {
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
