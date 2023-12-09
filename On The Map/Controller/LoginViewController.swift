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

    private func requestLogin() {
        if loginView.username.isEmpty || loginView.password.isEmpty {
            loginView.loginErrorState(with: "Must specify an email and password")
        } else {
            Client.postSession(username: loginView.username, password: loginView.password, completion: handleRequestLogin(success:error:))
        }
        loginView.isLoggingState(false)
    }

    private func handleRequestLogin(success: Bool, error: Error?) {
        if success && error == nil {
            let tabBarController = TabBarController()
            navigationController?.pushViewController(tabBarController, animated: true)
        } else {
            loginView.loginErrorState(with: error?.localizedDescription ?? "")
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    func didtapLogin() {
        requestLogin()
    }

    func didtapSigUp() {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        UIApplication.shared.open(url)
    }
}
