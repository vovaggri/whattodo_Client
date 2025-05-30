import UIKit

// MARK: - ViewController (GoalReviewViewController.swift)
final class GoalReviewViewController: UIViewController {
    // Font constant
    static let fontName = "AoboshiOne-Regular"
    
    // MARK: SVIP references
    var interactor: GoalReviewBusinessLogic?
    let deleteColor = UIColor(hex: "A92424", alpha: 0.6)
    private let goal: Goal
    private var tasks: [Task] = []
    
    // MARK: UI Elements
    private let titleLabel = UILabel()
    private let colorTitleLabel = UILabel()
    private let colorContainer = UIView()
    private let colorNameLabel = UILabel()
    private let colorDotView = UIView()
    private let containerView = UIView()
    private let tasksTitleLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let aiButton = UIButton(type: .system)
  //  private let buttonColor : UIColor
    
    private let deleteContainer = UIView()
    private let deleteIcon = UIImageView(image: UIImage(systemName: "trash"))
    private let deleteLabel = UILabel()
    
    private let descriptionTitleLabel = UILabel()
    private let descriptionContainer = UIView()
    
    private let descriptionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    
    private var descriptionLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont(name: Constants.fontName, size: 16)
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = .darkGray
        return l
    }()

    // New: Collection view for tasks
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(EmptyTaskCell.self, forCellWithReuseIdentifier: EmptyTaskCell.Constants.identifier)
        cv.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.Constants.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
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
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        interactor?.loadTasks(with: goal.id)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard aiButton.subviews.contains(where: { $0 is ShimmerView }) == false else { return }
            
        let shimmer = ShimmerView(frame: aiButton.bounds)
        shimmer.isUserInteractionEnabled = false
        shimmer.layer.cornerRadius = aiButton.layer.cornerRadius
        shimmer.clipsToBounds = true
        shimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let titleLabel = aiButton.titleLabel {
            aiButton.insertSubview(shimmer, belowSubview: titleLabel)
        } else {
            aiButton.addSubview(shimmer)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        aiButton.layoutIfNeeded() // гарантия, что фрейм актуален
        aiButton.subviews
            .compactMap { $0 as? ShimmerView }
            .forEach { $0.startAnimating() }
    }

    
    // MARK: - Display
    func displayGoal(viewModel: GoalReviewModels.ViewModel) {
        view.backgroundColor = viewModel.color

        // 2) theme everything else
        applyColorTheme(for: goal.colour)

        // 3) your existing updates
        titleLabel.text        = viewModel.title
        colorNameLabel.text    = name(for: goal.colour)
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
    
    func showTasks(with tasks: [Task]) {
        self.tasks = tasks
        collectionView.reloadData()
    }
    
    private func applyColorTheme(for colorId: Int) {
        let labelColor: UIColor
        let timeAlpha: CGFloat
        let buttonColor: UIColor
        let goalContainerColor: UIColor
        let colorContainerColor: UIColor
        let colorDotColor: UIColor

        switch colorId {
        case ColorIDs.ultraPink:
            labelColor          = UIColor(hex: "514F4F") ?? .black
            timeAlpha           = 0.7
            buttonColor         = UIColor(hex: "EA9AF1") ?? .black
            goalContainerColor  = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colorContainerColor = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colorDotColor       = UIColor(hex: "EA9AF1") ?? .black

        case ColorIDs.aquaBlue:
            labelColor          = UIColor(hex: "514F4F") ?? .black
            timeAlpha           = 0.7
            buttonColor         = UIColor(hex: "89BACD") ?? .black
            goalContainerColor  = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorContainerColor = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colorDotColor       = UIColor(hex: "89BACD") ?? .black

        case ColorIDs.mossGreen:
            labelColor          = UIColor(hex: "514F4F") ?? .black
            timeAlpha           = 0.7
            buttonColor         = UIColor(hex: "94CA85") ?? .black
            goalContainerColor  = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorContainerColor = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colorDotColor       = UIColor(hex: "94CA85") ?? .black

        case ColorIDs.lilac:
            labelColor          = UIColor(hex: "514F4F") ?? .black
            timeAlpha           = 0.7
            buttonColor         = UIColor(hex: "8587CA") ?? .black
            goalContainerColor  = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorContainerColor = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colorDotColor       = UIColor(hex: "8587CA") ?? .black

        case ColorIDs.marigold:
            labelColor          = UIColor(hex: "514F4F") ?? .black
            timeAlpha           = 0.7
            buttonColor         = UIColor(hex: "D6C69E") ?? .black
            goalContainerColor  = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorContainerColor = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colorDotColor       = UIColor(hex: "D6C69E") ?? .black

        case ColorIDs.defaultWhite:
            labelColor          = UIColor(hex: "514F4F") ?? .black
            timeAlpha           = 0.5
            buttonColor         = UIColor(hex: "888C8C") ?? .white
            goalContainerColor  = UIColor(hex: "F7F9F9") ?? .white
            colorContainerColor = UIColor(hex: "F7F9F9", alpha: 0.1) ?? .white
            colorDotColor       = UIColor.white

        default:
            labelColor          = .black
            timeAlpha           = 0.7
            buttonColor         = .black
            goalContainerColor  = .black
            colorContainerColor = .black
            colorDotColor       = .black
        }

        // Apply to your labels / container views
      

       // goalContainer.backgroundColor  = goalContainerColor
    //    colorContainer.backgroundColor = colorContainerColor
        colorDotView.backgroundColor   = colorDotColor

        // Finally theme the edit button:
        editButton.backgroundColor = buttonColor.withAlphaComponent(0.8)
        editButton.tintColor       = .white
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
        colorTitleLabel.font = UIFont(name: Self.fontName, size: 14)
        colorTitleLabel.text = "Goal Color"
        colorTitleLabel.textAlignment = .left
        
        // Color container styling
        colorContainer.backgroundColor = .white
        colorContainer.layer.cornerRadius = 14
        colorContainer.layer.masksToBounds = true
        
        descriptionTitleLabel.font = UIFont(name: Self.fontName, size: 14)
         descriptionTitleLabel.text = "Description"
         descriptionTitleLabel.textAlignment = .left
         
         descriptionContainer.backgroundColor = .white
         descriptionContainer.layer.cornerRadius = 14
         descriptionContainer.layer.masksToBounds = true
        
        descriptionContainer.addSubview(descriptionScrollView)
        descriptionScrollView.addSubview(descriptionLabel)
        
        descriptionScrollView.pinTop(to: descriptionContainer.topAnchor)
        descriptionScrollView.pinLeft(to: descriptionContainer.leadingAnchor)
        descriptionScrollView.pinRight(to: descriptionContainer.trailingAnchor)
        descriptionScrollView.pinBottom(to: descriptionContainer.bottomAnchor)
        
        descriptionLabel.text = goal.description
        descriptionLabel.pinTop(to: descriptionScrollView.topAnchor, 10)
        descriptionLabel.pinLeft(to: descriptionScrollView.leadingAnchor, 16)
        descriptionLabel.pinRight(to: descriptionScrollView.trailingAnchor, 16)
        descriptionLabel.pinBottom(to: descriptionScrollView.bottomAnchor, 10)
        descriptionLabel.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor, constant: -20).isActive = true
        
        // AI button styling
        aiButton.setTitle("AI", for: .normal)
        aiButton.titleLabel?.font = UIFont(name: Self.fontName, size: 18)
        aiButton.setTitleColor(.white, for: .normal)
        aiButton.backgroundColor = .black
        aiButton.layer.cornerRadius = 72/2
        
        
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
       // editButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        editButton.layer.cornerRadius = 44
        editButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        editButton.tintColor       = .white
       
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 440)
        editButton.pinRight(to: view.trailingAnchor, 20)
        editButton.setWidth(88)
        editButton.setHeight(88)
      //  editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        
        // Configure bottom container (tasks panel)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       // containerView.setHeight(420)
        containerView.pinTop(to: colorContainer.bottomAnchor, 250)
        
        containerView.addSubview(tasksTitleLabel)
                tasksTitleLabel.font = UIFont(name: Self.fontName, size: 24)
                tasksTitleLabel.text = "Your tasks"
                tasksTitleLabel.textAlignment = .left
                
        
        // Layout top elements
      //  titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 24)
        titleLabel.pinTop(to: closeButton.bottomAnchor, 12)
        titleLabel.pinLeft(to: view, 16)
        titleLabel.pinRight(to: view, 16)
        titleLabel.setHeight(67)
        titleLabel.setWidth(223)
        
        colorTitleLabel.pinTop(to: titleLabel.bottomAnchor, 12)
        colorTitleLabel.pinLeft(to: view, 16)
        colorTitleLabel.setHeight(32)
        colorTitleLabel.setWidth(352)
        
        // Color container below color title
        colorContainer.pinTop(to: colorTitleLabel.bottomAnchor, 8)
        colorContainer.pinLeft(to: view, 16)
        colorContainer.setWidth(352)
        colorContainer.setHeight(52)

        
        // Layout inside colorContainer
        colorNameLabel.pinCenterY(to: colorContainer)
        colorNameLabel.pinLeft(to: colorContainer, 16)
        colorNameLabel.setHeight(52)
        colorNameLabel.setWidth(352)
        
        colorDotView.pinCenterY(to: colorContainer)
        colorDotView.setWidth(20)
        colorDotView.setHeight(20)
        colorDotView.pinRight(to: colorContainer, 16)
        colorDotView.layer.cornerRadius = 10
        
        //description
        view.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.pinTop(to: colorContainer.bottomAnchor, 9)
        descriptionTitleLabel.pinLeft(to: view, 16)
        descriptionTitleLabel.setHeight(22)
        descriptionTitleLabel.setWidth(352)
        
        view.addSubview(descriptionContainer)
       descriptionContainer.pinTop(to: descriptionTitleLabel.bottomAnchor, 8)
        descriptionContainer.pinLeft(to: view, 16)
        descriptionContainer.setWidth(352)
        descriptionContainer.setHeight(68)
        
        
        
        // DELETE CONTAINER
        view.addSubview(deleteContainer)
        deleteContainer.translatesAutoresizingMaskIntoConstraints = false
        deleteContainer.backgroundColor = .white
        deleteContainer.layer.cornerRadius = 14
        deleteContainer.layer.masksToBounds = true
        
        // включаем тап для контейнера
        deleteContainer.isUserInteractionEnabled = true
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteContainerTapped))
        deleteContainer.addGestureRecognizer(deleteTap)

        deleteContainer.pinTop(to: descriptionContainer.bottomAnchor, 22)
        deleteContainer.pinLeft(to: view, 16)
        deleteContainer.setWidth(352)
        deleteContainer.setHeight(52)

        // Trash icon
        deleteContainer.addSubview(deleteIcon)
        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        deleteIcon.tintColor = deleteColor

        // Label
        
        
        deleteIcon.contentMode = .scaleAspectFit

        deleteIcon.pinLeft(to: deleteContainer, 16)
        deleteIcon.pinCenterY(to: deleteContainer)
        deleteIcon.setWidth(20)
        deleteIcon.setHeight(20)

        // Label
        deleteContainer.addSubview(deleteLabel)
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteLabel.text = "Delete Goal"
        deleteLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        deleteLabel.textColor = deleteColor

        deleteLabel.pinLeft(to: deleteIcon.trailingAnchor, 16)
        deleteLabel.pinCenterY(to: deleteContainer)

        
        
        // Layout bottom tasks container
      //  containerView.pinTop(to: colorContainer.bottomAnchor, 124)
        containerView.pinLeft(to: view)
        containerView.pinRight(to: view)
        containerView.pinBottom(to: view)
        
        // Layout message inside container
        tasksTitleLabel.pinTop(to: containerView, 24)
             tasksTitleLabel.pinLeft(to: containerView, 16)
       
              aiButton.setWidth(72)
              aiButton.setHeight(72)
              aiButton.pinRight(to: view, 24)
              aiButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
          
        // Add collection view
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinTop(to: tasksTitleLabel.bottomAnchor, 30)
        collectionView.pinLeft(to: containerView)
        collectionView.pinRight(to: containerView)
        collectionView.pinBottom(to: containerView)
      
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func aiButtonTapped() {
        interactor?.checkGoal(with: goal)
    }
     @objc private func editButtonTapped() {
         let changeTaskVC = ChangeGoalAssembly.makeModule(goal)
         navigationController?.pushViewController(changeTaskVC, animated: true)
    }
    
    @objc private func deleteContainerTapped() {
        let alert = UIAlertController(
          title: "Delete goal",
          message: "Are you sure that you want delete this goal?",
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(
          title: "Delete",
          style: .destructive,
          handler: { [weak self] _ in
              guard let goal = self?.goal else {
                  return
              }
              self?.interactor?.deleteGoal(with: goal)
          }
        ))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView
extension GoalReviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.isEmpty ? 1 : tasks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tasks.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTaskCell.Constants.identifier, for: indexPath) as? EmptyTaskCell else {
                return UICollectionViewCell()
            }
            cell.configureReviewGoal()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.Constants.identifier, for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            let task = tasks[indexPath.row]
            cell.configureReview(with: task)
            cell.delegate = self
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 104)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !tasks.isEmpty else { return }
        let selectedTask = tasks[indexPath.row]
        // Navigate to task detail or notify interactor
        interactor?.didSelectTask(selectedTask)
    }
}

// MARK: - TaskCell Delegate
extension GoalReviewViewController: taskCellDelegate {
    func taskCellDidCompleteTask(_ cell: TaskCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        tasks[indexPath.row].done.toggle()
        cell.updateCompleteButtonAppearance()
        interactor?.updateTask(tasks[indexPath.row])
    }
}
