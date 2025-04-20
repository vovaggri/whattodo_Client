import UIKit

final class ChangeGoalViewController: UIViewController {
    
    var interactor: ChangeGoalBusinessLogic?
    
    private let fontName = "AoboshiOne-Regular"
    private let lightGrayColor = UIColor(red: 247/255, green: 249/255, blue: 249/255, alpha: 1)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let topBar = UIView()
    private let closeButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    private let textFieldStack = UIStackView()
    private let nameField = UITextField()
    private let dateField = UITextField()
    private let descriptionView = UITextView()
    private let startTimeField = UITextField()
    private let endTimeField = UITextField()
    private let colorField = UITextField()
    private let linkField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGrayColor
        
        setupTopBar()
        setupScrollView()
        setupFields()
        setupButton()
    }
    
    private func setupTopBar() {
        topBar.backgroundColor = lightGrayColor
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        topBar.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        titleLabel.text = "Edit Goal"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: fontName, size: 24)
        titleLabel.textColor = .black
        topBar.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = lightGrayColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 30
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupFields() {
        textFieldStack.axis = .vertical
        textFieldStack.spacing = 16
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldStack)
        
        NSLayoutConstraint.activate([
            textFieldStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textFieldStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        [nameField, dateField, descriptionView, startTimeField, endTimeField, colorField, linkField].forEach {
            styleField($0)
            if let tf = $0 as? UITextField {
                tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
            } else if let tv = $0 as? UITextView {
                tv.heightAnchor.constraint(equalToConstant: 80).isActive = true
            }
            textFieldStack.addArrangedSubview($0)
        }
        
        nameField.placeholder = "Title"
        dateField.placeholder = "Date"
        startTimeField.placeholder = "Start Time"
        endTimeField.placeholder = "End Time"
        colorField.placeholder = "Goal Color"
        linkField.placeholder = "Link to Goal"
        descriptionView.text = "Description"
        descriptionView.font = UIFont(name: fontName, size: 16)
    }
    
    private func styleField(_ view: UIView) {
        if let tf = view as? UITextField {
            tf.borderStyle = .none
            tf.backgroundColor = lightGrayColor
            tf.layer.cornerRadius = 12
            tf.setLeftPaddingPoints(10)
            tf.font = UIFont(name: fontName, size: 16)
        } else if let tv = view as? UITextView {
            tv.backgroundColor = lightGrayColor
            tv.layer.cornerRadius = 12
        }
    }
    
    private func setupButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: fontName, size: 18)
        saveButton.backgroundColor = .black
        saveButton.layer.cornerRadius = 14
        
        contentView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: textFieldStack.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
}

// Padding helper
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

