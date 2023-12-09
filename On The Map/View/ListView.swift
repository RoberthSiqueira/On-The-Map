import UIKit

final class ListView: UIView {

    // MARK: - Properties

    weak var delegate: LogoutProtocol?

    private var studentLocations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - UI

    lazy var logoutButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        barButtonItem.title = "Logout"
        return barButtonItem
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

    // MARK: View

    private func addViewHierarchy() {
        addSubview(tableView)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

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
}

extension ListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let studentLocation = studentLocations[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        content.secondaryText = "\(studentLocation.mediaURL)"
        content.image = UIImage(named: "icon_pin")

        cell.contentConfiguration = content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaURL = studentLocations[indexPath.row].mediaURL

        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        
        guard let url = URL(string: mediaURL) else { return }
        UIApplication.shared.open(url)

    }
}
