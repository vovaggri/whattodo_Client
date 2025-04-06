import UIKit

final class ChangePasswordViewController: UIViewController {
    var interactor: ChangePasswordBusinessLogic?

    private let backButton: UIButton = {
        let backButton = UIButton(type: .system)

        // Use SF Symbol arrow
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backButton.setImage(image, for: .normal)

        backButton.tintColor = .black
        backButton.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        backButton.layer.cornerRadius = 35
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.05
        backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        backButton.layer.shadowRadius = 2
        backButton.clipsToBounds = false
        return backButton
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Password"
        label.font = UIFont(name: "AoboshiOne-Regular", size: 34)
        label.textColor = .black
        return label
    }()

    private let codeField = ChangePasswordTextField(placeholder: "Enter code from mail")
    private let newPasswordField = ChangePasswordTextField(placeholder: "New password")

    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue to app", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 17)
        btn.backgroundColor = UIColor(red: 208/255, green: 232/255, blue: 200/255, alpha: 1.0)
        btn.layer.cornerRadius = 14
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
    }

    private func setupLayout() {
        [backButton, titleLabel, codeField, newPasswordField, continueButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             backButton.widthAnchor.constraint(equalToConstant: 73),
             backButton.heightAnchor.constraint(equalToConstant: 73),

            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),

            codeField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 180),
            codeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            codeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            codeField.heightAnchor.constraint(equalToConstant: 58),

            newPasswordField.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 30),
            newPasswordField.leadingAnchor.constraint(equalTo: codeField.leadingAnchor),
            newPasswordField.trailingAnchor.constraint(equalTo: codeField.trailingAnchor),
            newPasswordField.heightAnchor.constraint(equalToConstant: 58),

            continueButton.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 200),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleContinue() {
        let code = codeField.text ?? ""
        let newPassword = newPasswordField.text ?? ""
        interactor?.submitChange(request: ChangePasswordModels.Request(code: code, newPassword: newPassword))
    }

    func navigateToApp() {
        print("🔐 Successfully changed password! Redirecting to app...")
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private class ChangePasswordTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.font = UIFont(name: "AoboshiOne-Regular", size: 16)
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 1
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        self.leftView = padding
        self.leftViewMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
