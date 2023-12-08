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
    }

    func didtapSigUp() {
    }
}
