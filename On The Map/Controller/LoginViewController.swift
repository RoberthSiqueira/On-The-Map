import UIKit

class LoginViewController: UIViewController {

    // MARK: - PROPERTIES

    let loginView = LoginView(frame: .zero)

    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.setupView()
        loginView.delegate = self
        view = loginView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func requestLogin(with username: String, and password: String) {
        Client.postSession(username: username, password: password, completion: handleRequestLogin(success:error:))
    }

    private func handleRequestLogin(success: Bool, error: Error?) {
        if success && error == nil {
            let tabBarController = TabBarController()
            navigationController?.pushViewController(tabBarController, animated: true)
        } else {
            let error = error?.localizedDescription ?? ""
            loginView.loginErrorState(shouldShow: true, message: error)
        }
        loginView.isLogging(false)
    }
}

extension LoginViewController: LoginViewDelegate {
    func didtapLogin(username: String, password: String) {
        requestLogin(with: username, and: password)
    }

    func didtapSigUp() {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        UIApplication.shared.open(url)
    }
}
