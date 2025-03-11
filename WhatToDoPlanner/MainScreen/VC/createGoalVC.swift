import UIKit

class CreateGoalViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New Goal"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let goalNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter goal name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let goalDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Goal", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(goalNameTextField)
        view.addSubview(goalDescriptionTextView)
        view.addSubview(saveButton)
        
        // Disable autoresizing mask constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        goalNameTextField.translatesAutoresizingMaskIntoConstraints = false
        goalDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Goal Name Text Field Constraints
            goalNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            goalNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goalNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goalNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Goal Description Text View Constraints
            goalDescriptionTextView.topAnchor.constraint(equalTo: goalNameTextField.bottomAnchor, constant: 20),
            goalDescriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goalDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goalDescriptionTextView.heightAnchor.constraint(equalToConstant: 150),
            
            // Save Button Constraints
            saveButton.topAnchor.constraint(equalTo: goalDescriptionTextView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        // Handle saving of the new goal.
        // For example, validate input and then notify your interactor or dismiss the view.
        print("Save Goal button tapped")
        
        // Example validation
        guard let goalName = goalNameTextField.text, !goalName.isEmpty else {
            // Show an alert or error
            print("Goal name is required.")
            return
        }
        
        // At this point, you would pass the data to your business logic to create a new goal.
        dismiss(animated: true)
    }
}
