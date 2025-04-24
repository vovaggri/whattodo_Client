import UIKit

final class SettingsVC: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        static let margin: CGFloat = 16
    }
    
    var interactor: SettingsBusinessLogic?
    private var user: MainModels.Fetch.UserResponse?
    
    private let settingsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.text = "Settings"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 28)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        // use xmark, scaled up
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let xImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xImage, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.33)
        return button
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addTargets()
        navigationItem.titleView = settingsTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        interactor?.fetchUserInfo()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayUser(_ userInfo: MainModels.Fetch.UserResponse) {
        user = userInfo
        guard let user = user else {
            return
        }
        fullNameLabel.text = user.firstName + " " + user.secondName
    }
    
    private func setupUI() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fullNameLabel)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.pinCenterX(to: view)
        fullNameLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.pinCenterX(to: view)
        editProfileButton.pinTop(to: fullNameLabel.topAnchor, 80)
        editProfileButton.pinLeft(to: view, Constants.margin)
        editProfileButton.pinRight(to: view, Constants.margin)
        editProfileButton.setHeight(50)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.pinCenterX(to: view)
        forgotPasswordButton.pinTop(to: editProfileButton.topAnchor, 80)
        forgotPasswordButton.pinLeft(to: view, Constants.margin)
        forgotPasswordButton.pinRight(to: view, Constants.margin)
        forgotPasswordButton.setHeight(50)
        
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.pinCenterX(to: view)
        logOutButton.pinTop(to: forgotPasswordButton.topAnchor, 80)
        logOutButton.pinLeft(to: view, Constants.margin)
        logOutButton.pinRight(to: view, Constants.margin)
        logOutButton.setHeight(50)
    }
    
    private func addTargets() {
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    private func logOutAlert() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure that you want to log out from your account?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Log out", style: .destructive) { [weak self] _ in
            self?.interactor?.logOut()
        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func closeButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editProfileTapped() {
        
    }
    
    @objc private func forgotPasswordTapped() {
        
    }
    
    @objc private func logOutTapped() {
        logOutAlert()
    }
}
