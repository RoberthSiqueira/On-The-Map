import UIKit

protocol LoginViewDelegate: AnyObject {
    func didtapLogin()
    func didtapSigUp()
}

final class LoginView: UIView {

    // MARK: - Properties}

    weak var delegate: LoginViewDelegate?

    // MARK: - API

    var username: String {
        return emailTextField.text ?? ""
    }

    var password: String {
        return passwordTextField.text ?? ""
    }

    func setupView() {
        backgroundColor = .white
        addViewHierarchy()
    }

    func loginErrorState(with message: String) {
        feedbackLabel.text = message
        feedbackLabel.isHidden = false
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        loginButton.isEnabled = true
        signupButton.isEnabled = true
    }

    // MARK: - UI

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo-u")
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "E-mail"
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 2/255, green: 179/255, blue: 228/255, alpha: 1)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private lazy var feedbackLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .red
        label.isHidden = true
        return label
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(frame: .zero)
        let titleColor = UIColor(red: 2/255, green: 179/255, blue: 228/255, alpha: 1)
        button.backgroundColor = .white
        button.setTitleColor(titleColor, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        return button
    }()

    // MARK: View

    private func addViewHierarchy() {
        addSubview(imageView)
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(emailTextField)
        contentStackView.addArrangedSubview(passwordTextField)
        contentStackView.addArrangedSubview(loginButton)
        contentStackView.addArrangedSubview(feedbackLabel)
        contentStackView.addArrangedSubview(signupButton)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Methods

    private func logginState() {
        feedbackLabel.isHidden = true
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
        signupButton.isEnabled = false
    }

    // MARK: - UIActions

    @objc private func loginAction(_ sender: UIButton) {
        logginState()
        delegate?.didtapLogin()
    }

    @objc private func signupAction(_ sender: UIButton) {
        delegate?.didtapSigUp()
    }
}