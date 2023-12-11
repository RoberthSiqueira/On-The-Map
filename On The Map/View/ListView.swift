import UIKit

final class ListView: UIView {

    // MARK: - Properties

    weak var delegate: BarItemsActionsProtocol?

    private var studentLocations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - UI

    lazy var logoutButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutAction))
        barButtonItem.title = "LOGOUT"
        return barButtonItem
    }()

    lazy var plusButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(informationPostingAction))
        return barButtonItem
    }()

    lazy var refreshButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadLocationsAction))
        return barButtonItem
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()

    // MARK: - API

    func setupView() {
        backgroundColor = .white
        addViewHierarchy()
    }

    func updateLocations(with studentLocations: [StudentLocation]) {
        self.studentLocations = studentLocations
    }

    func requestingData() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        tableView.isHidden = true
    }

    func dataRequested() {
        loadingIndicator.stopAnimating()
        tableView.isHidden = false
    }

    // MARK: View

    private func addViewHierarchy() {
        addSubview(loadingIndicator)
        addSubview(tableView)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    // MARK: - UIActions

    @objc private func logoutAction(_ sender: UIBarButtonItem) {
        delegate?.didtapLogout()
    }

    @objc private func reloadLocationsAction(_ sender: UIBarButtonItem) {
        delegate?.didtapReloadLocations()
    }

    @objc private func informationPostingAction(sender: UIBarButtonItem) {
        delegate?.didtapInformationPosting()
    }
}

extension ListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let studentLocation = studentLocations[indexPath.row]
        let firstName: String = studentLocation.firstName ?? ""
        let lastName: String = studentLocation.lastName ?? ""

        var content = cell.defaultContentConfiguration()
        content.text = "\(firstName) \(lastName)"
        content.secondaryText = studentLocation.mediaURL
        content.image = UIImage(named: "icon_pin")

        cell.contentConfiguration = content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = studentLocations[indexPath.row].mediaURL {

            tableView.cellForRow(at: indexPath)?.selectionStyle = .none

            guard let url = URL(string: mediaURL) else { return }
            UIApplication.shared.open(url)
        }
    }
}
