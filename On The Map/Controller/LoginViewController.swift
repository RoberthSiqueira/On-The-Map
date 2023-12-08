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
}

extension LoginViewController: LoginViewDelegate {
    func didtapLogin() {
        if loginView.username.isEmpty || loginView.password.isEmpty {
            loginView.loginErrorState(with: "Must specify an email and password")
        } else {
            Client.postSession(username: loginView.username, password: loginView.password) { [weak self] success, error in
                if success && error == nil {
                    print(success)
                } else {
                    self?.loginView.loginErrorState(with: error?.localizedDescription ?? "")
                }
            }
        }
    }

    func didtapSigUp() {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        UIApplication.shared.open(url)
    }
}
