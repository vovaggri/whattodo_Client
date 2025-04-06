import UIKit

final class ForgotScreenViewController: UIViewController {

    // VIP references
    var interactor: ForgotScreenBusinessLogic?
    
    // MARK: - UI Elements
    
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
        label.text = "Forgot Password"
        label.font = UIFont(name: "AoboshiOne-Regular", size: 36) ?? UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // “Getting Started” label placed near the middle of the screen
   
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont(name: "AoboshiOne-Regular", size: 16)
        tf.borderStyle = .none
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = UIColor(red: 208/255, green: 232/255, blue: 200/255, alpha: 1.0)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setupActions()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Trigger fetching data (this will update the email placeholder via the presenter)
        interactor?.fetchForgotData(request: ForgotScreen.Fetch.Request())
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
       
        view.addSubview(emailTextField)
        view.addSubview(continueButton)
    }
    
    private func setupConstraints() {
        [backButton, titleLabel, emailTextField, continueButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            // Back button at top left
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             backButton.widthAnchor.constraint(equalToConstant: 73),
             backButton.heightAnchor.constraint(equalToConstant: 73),
             
             // Title label constraints: position it below the back button
             titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -28),

            titleLabel.heightAnchor.constraint(equalToConstant: 52),
            
            // "Getting Started" label near the middle of the screen (adjust vertical offset as needed)
          
            
            
            // Email text field placed below the "Getting Started" label
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 215),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            // Continue button below the email text field
            continueButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 245),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),            continueButton.heightAnchor.constraint(equalToConstant: 48),
            continueButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
           // continueButton.widthAnchor.constraint(equalToConstant: 340)
        ])
    }
    
    private func setupActions() {
        //backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        
        continueButton.addTarget(self, action: #selector(presentforgotpassscreen), for: .touchUpInside)
    }
    
    // MARK: - Actions
//    @objc private func ContinueButtonTapped() {
//        let changeVC = ChangePasswordAssembly.assemble()
//        navigationController?.pushViewController(changeVC, animated: true)
//    }
    @objc private func presentforgotpassscreen() {
        
        handleContinueTapped()
    }
    
    @objc private func handleContinueTapped() {
        let changeVC = PinCodeAssembly.assemble()
        navigationController?.pushViewController(changeVC, animated: true)
    }
    
    
    
    // Method that will be called by the presenter to update the email placeholder
    func updateEmailPlaceholder(with placeholder: String) {
        emailTextField.placeholder = placeholder
    }
}
