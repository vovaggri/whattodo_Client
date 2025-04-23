import UIKit

// MARK: - ViewController (GoalReviewViewController.swift)
final class GoalReviewViewController: UIViewController {
    // MARK: SVIP references
    var interactor: GoalReviewBusinessLogic?
    private let goal: Goal
    
    // MARK: UI Elements
    private let titleLabel = UILabel()
    private let colorTitleLabel = UILabel()
    private let colorContainer = UIView()
    private let colorNameLabel = UILabel()
    private let colorDotView = UIView()
    private let containerView = UIView()
    private let tasksTitleLabel = UILabel()
    private let messageLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let aiButton = UIButton(type: .system)
    
    // Font constant
    static let fontName = "AoboshiOne-Regular"
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)

        // Use SF Symbol arrow
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)

        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2
        button.clipsToBounds = false
        return button
    }()
    
    // MARK: Lifecycle
    init(goal: Goal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aiButton.addTarget(self, action: #selector(aiButtonTapped), for: .touchUpInside)
        setupUI()
        interactor?.loadGoal()
    }
    
    // MARK: - Display
    func displayGoal(viewModel: GoalReviewModels.ViewModel) {
        view.backgroundColor = viewModel.color
        titleLabel.text = viewModel.title
        colorNameLabel.text = name(for: goal.colour)
        colorDotView.backgroundColor = viewModel.color
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showProblemAI() {
        let alert = UIAlertController(title: "AI not available", message: "AI advice is not available for goals without description.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, -10)
        closeButton.pinLeft(to: view, 16)
        closeButton.setWidth(70)
        closeButton.setHeight(70)
        closeButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        
        // Add top elements
        [titleLabel, colorTitleLabel, colorContainer, containerView,editButton, aiButton].forEach {
            view.addSubview($0)
        }
        
        // Title styling
        titleLabel.font = UIFont(name: Self.fontName, size: 47)
        titleLabel.textAlignment = .left
       
        
        // Color title
        colorTitleLabel.font = UIFont(name: Self.fontName, size: 18)
        colorTitleLabel.text = "Goal Color"
        colorTitleLabel.textAlignment = .left
        
        // Color container styling
        colorContainer.backgroundColor = .white
        colorContainer.layer.cornerRadius = 14
        colorContainer.layer.masksToBounds = true
        
        // AI button styling
        aiButton.setTitle("AI", for: .normal)
        aiButton.titleLabel?.font = UIFont(name: Self.fontName, size: 18)
        aiButton.setTitleColor(.white, for: .normal)
        aiButton.backgroundColor = .black
        aiButton.layer.cornerRadius = 28
        
        
        // Inside color container: name and dot
        [colorNameLabel, colorDotView].forEach { colorContainer.addSubview($0) }
        colorNameLabel.font = UIFont(name: Self.fontName, size: 18)
        colorDotView.layer.cornerRadius = 8
        colorDotView.layer.masksToBounds = true
        
        // MARK: - Edit Button
        let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular) // You can adjust size & weight
        let pencilImage = UIImage(systemName: "pencil", withConfiguration: config)
        editButton.setImage(pencilImage, for: .normal)
        editButton.tintColor = .white
        editButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        editButton.layer.cornerRadius = 44
       
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 340)
        editButton.pinRight(to: view.trailingAnchor, 20)
        editButton.setWidth(88)
        editButton.setHeight(88)
      //  editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        
        // Configure bottom container (tasks panel)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.setHeight(620)
        containerView.pinTop(to: colorContainer.bottomAnchor, 188)
        
        containerView.addSubview(tasksTitleLabel)
                tasksTitleLabel.font = UIFont(name: Self.fontName, size: 24)
                tasksTitleLabel.text = "Your tasks"
                tasksTitleLabel.textAlignment = .left
                
        
        // Message label inside container
        containerView.addSubview(messageLabel)
        messageLabel.font = UIFont(name: Self.fontName, size: 18)
        messageLabel.text = "There are currently no tasks for this goal :("
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // Layout top elements
      //  titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 24)
        titleLabel.pinTop(to: closeButton.bottomAnchor, 12)
        titleLabel.pinLeft(to: view, 16)
        titleLabel.pinRight(to: view, 16)
        titleLabel.setHeight(77)
        titleLabel.setWidth(223)
        
        colorTitleLabel.pinTop(to: titleLabel.bottomAnchor, 24)
        colorTitleLabel.pinLeft(to: view, 16)
        colorTitleLabel.setHeight(30)
        colorTitleLabel.setWidth(223)
        
        // Color container below color title
        colorContainer.pinTop(to: colorTitleLabel.bottomAnchor, 8)
        colorContainer.pinLeft(to: view, 16)
        colorContainer.pinRight(to: view, 16)
        colorContainer.setHeight(52)
        
        // Layout inside colorContainer
        colorNameLabel.pinCenterY(to: colorContainer)
        colorNameLabel.pinLeft(to: colorContainer, 16)
        
        colorDotView.pinCenterY(to: colorContainer)
        colorDotView.setWidth(16)
        colorDotView.setHeight(16)
        colorDotView.pinRight(to: colorContainer, 16)
        
        // Layout bottom tasks container
        containerView.pinTop(to: colorContainer.bottomAnchor, 124)
        containerView.pinLeft(to: view)
        containerView.pinRight(to: view)
        containerView.pinBottom(to: view)
        
        // Layout message inside container
        messageLabel.pinCenterY(to: containerView)
        messageLabel.pinLeft(to: containerView, 16)
        messageLabel.pinRight(to: containerView, 16)
        tasksTitleLabel.pinTop(to: containerView, 24)
             tasksTitleLabel.pinLeft(to: containerView, 16)
        
        // Layout AI button bottom right
              aiButton.setWidth(70)
              aiButton.setHeight(70)
              aiButton.pinRight(to: view, 24)
              aiButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
          
        
      
    }
    
    private func name(for colorID: Int) -> String {
        switch colorID {
        case ColorIDs.aquaBlue: return "Aqua Blue"
        case ColorIDs.mossGreen: return "Moss Green"
        case ColorIDs.marigold: return "Marigold"
        case ColorIDs.lilac: return "Lilac"
        case ColorIDs.ultraPink: return "Ultra Pink"
        case ColorIDs.defaultWhite: return "Default White"
        default: return "Unknown"
        }
    }
    
    @objc private func backButtonTapped() {
        // Navigate directly to Task Detail screen
        let mainDetailVC = MainAssembly.assembly() // Ensure TaskDetailAssembly is implemented
        self.navigationController?.pushViewController(mainDetailVC, animated: true)
    }
    
    @objc private func aiButtonTapped() {
        interactor?.checkGoal(with: goal)
    }
}
