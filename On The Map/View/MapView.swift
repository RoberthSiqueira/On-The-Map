import UIKit

protocol MapViewDelegate: AnyObject {
    func didtapLogout()
}

final class MapView: UIView {

    // MARK: - Properties

    weak var delegate: MapViewDelegate?

    // MARK: - UI

    lazy var logoutButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        barButtonItem.title = "Logout"
        return barButtonItem
    }()

    // MARK: - UIActions

    @objc private func logoutAction(_ sender: UIBarButtonItem) {
        delegate?.didtapLogout()
    }
}
