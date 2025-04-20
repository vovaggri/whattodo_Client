// MARK: - Display Logic
import UIKit

// MARK: - View Controller

final class ReviewTaskViewController: UIViewController {
    static let lightGrayColor = UIColor(red: 247/255, green: 249/255, blue: 249/255, alpha: 1.0)
    
    var interactor: ReviewTaskBusinessLogic?

    private let task: Task

    // UI Elements
    private let dateLabel = UILabel()
    private let dayLabel = UILabel()
    private let timeLabel = UILabel()
    private let editButton = UIButton(type: .system)

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let separator = UIView()
    private let goalLabelTitle = UILabel()
    private let goalLabel = UILabel()
    private let colorLabelTitle = UILabel()
    private let colorLabel = UILabel()
    private let goalContainer = UIView()

    private let colorContainer = UIView()
    private let colorDotView = UIView()

    
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

    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getGoal(with: task.goalId ?? 0)
        setupUI()
        interactor?.loadTask(request: ReviewTaskModels.Request(task: task))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func displayTask(viewModel: ReviewTaskModels.ViewModel) {
        applyColorTheme(for: task.colour)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        //goalLabel.text = viewModel.goalName ?? "None"
        colorLabel.text = name(for: task.colour)
        
        if viewModel.startTime == viewModel.endTime {
            timeLabel.text = "Any time"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let startTime = viewModel.startTime, let endTime = viewModel.endTime {
                let localStart = startTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                let localEnd = endTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                
                timeLabel.text = "\(formatter.string(from: localStart)) → \(formatter.string(from: localEnd))"
            } else {
                timeLabel.text = "Any time"
            }
        }

        view.backgroundColor = viewModel.color

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        dateLabel.text = formatter.string(from: task.endDate)

        formatter.dateFormat = "EEEE"
        dayLabel.text = formatter.string(from: task.endDate)  + ","
    }
    
    func displayGoalText(with text: String) {
        goalLabel.text = text
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func name(for colorId: Int) -> String {
        switch colorId {
        case ColorIDs.aquaBlue: return "Aqua Blue"
        case ColorIDs.mossGreen: return "Moss Green"
        case ColorIDs.marigold: return "Marigold"
        case ColorIDs.lilac: return "Lilac"
        case ColorIDs.ultraPink: return "Ultra Pink"
        case ColorIDs.defaultWhite: return "Default White"
        default: return "Unknown"
        }
    }

    private func applyColorTheme(for colorId: Int) {
        let labelColor: UIColor
        let timeAlpha: CGFloat
        let buttonColor: UIColor
        let goalcontainercolor: UIColor
        let colorcontainer: UIColor
        let colordot: UIColor

        switch colorId {
        case ColorIDs.ultraPink:
            labelColor = UIColor(hex: "514F4F") ?? .black
            timeAlpha = 0.7
            buttonColor = UIColor(hex: "EA9AF1") ?? .black
            goalcontainercolor = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colordot = UIColor(hex: "EA9AF1") ?? .black
        colorcontainer = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
        case ColorIDs.aquaBlue:
            labelColor = UIColor(hex: "514F4F") ?? .black
            timeAlpha = 0.7
            buttonColor = UIColor(hex: "89BACD") ?? .black
            goalcontainercolor = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorcontainer = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colordot = UIColor(hex: "89BACD") ?? .black
        case ColorIDs.mossGreen:
            labelColor = UIColor(hex: "514F4F") ?? .black
            timeAlpha = 0.7
            buttonColor = UIColor(hex: "94CA85") ?? .black
            goalcontainercolor = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorcontainer = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colordot = UIColor(hex: "94CA85") ?? .black
        case ColorIDs.lilac:
            labelColor = UIColor(hex: "514F4F") ?? .black
            timeAlpha = 0.7
            buttonColor = UIColor(hex: "8587CA") ?? .black
            goalcontainercolor = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorcontainer = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colordot = UIColor(hex: "8587CA") ?? .black
        case ColorIDs.marigold:
            labelColor = UIColor(hex: "514F4F") ?? .black
            timeAlpha = 0.7
            buttonColor = UIColor(hex: "F1D693") ?? .black
            goalcontainercolor = UIColor(hex: "514F4F", alpha: 0.2) ?? .black
            colorcontainer = UIColor(hex: "514F4F", alpha: 0.1) ?? .black
            colordot = UIColor(hex: "F1D693") ?? .black
        case ColorIDs.defaultWhite:
            labelColor = UIColor(hex: "514F4F") ?? .black
            timeAlpha = 0.5
            buttonColor = UIColor(hex: "FFFFFF") ?? .black
            goalcontainercolor = UIColor(hex: "F7F9F9") ?? .black
            colorcontainer = UIColor(hex: "F7F9F9", alpha: 0.1) ?? .black
            colordot = UIColor(hex: "FFFFFF") ?? .black
        default:
            labelColor = .black
            timeAlpha = 0.7
            buttonColor = .black
            goalcontainercolor = .black
            colorcontainer = .black
            colordot = .black
        }

        dayLabel.textColor = labelColor
        dateLabel.textColor = labelColor
        timeLabel.textColor = labelColor.withAlphaComponent(timeAlpha)
        editButton.tintColor = .white
        editButton.backgroundColor = buttonColor
        goalContainer.backgroundColor = goalcontainercolor
        colorContainer.backgroundColor = colorcontainer
        colorDotView.backgroundColor = colordot
    }

    private func setupUI() {
        view.backgroundColor = .white

        // MARK: - Top labels
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, -10)
        closeButton.pinLeft(to: view, 16)
        closeButton.setWidth(70)
        closeButton.setHeight(70)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
           dayLabel.font = UIFont(name: "AoboshiOne-Regular", size: 60)
           dayLabel.textAlignment = .left
           view.addSubview(dayLabel)
           dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.pinTop(to: closeButton.bottomAnchor, 8)
           dayLabel.pinLeft(to: view, 30)

           dateLabel.font = UIFont(name: "AoboshiOne-Regular", size: 58)
           dateLabel.textAlignment = .left
           view.addSubview(dateLabel)
           dateLabel.translatesAutoresizingMaskIntoConstraints = false
           dateLabel.pinTop(to: dayLabel.bottomAnchor, 5)
           dateLabel.pinLeft(to: view, 30)

           timeLabel.font = UIFont.systemFont(ofSize: 24)
           timeLabel.textAlignment = .center
           timeLabel.textColor = .darkGray
           view.addSubview(timeLabel)
           timeLabel.translatesAutoresizingMaskIntoConstraints = false
           timeLabel.pinTop(to: dateLabel.bottomAnchor, 16)
           timeLabel.pinLeft(to: view, 30)



           // MARK: - White Container
           containerView.backgroundColor = .white
           containerView.layer.cornerRadius = 32
           containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           view.addSubview(containerView)
           containerView.translatesAutoresizingMaskIntoConstraints = false
           containerView.pinTop(to: timeLabel.bottomAnchor, 70)
           containerView.pinLeft(to: view)
           containerView.pinRight(to: view)
           containerView.pinBottom(to: view)

        // MARK: - Edit Button
        let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular) // You can adjust size & weight
        let pencilImage = UIImage(systemName: "pencil", withConfiguration: config)
        editButton.setImage(pencilImage, for: .normal)
        editButton.tintColor = .white
        editButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        editButton.layer.cornerRadius = 44
       
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 316)
        editButton.pinRight(to: view.trailingAnchor, 20)
        editButton.setWidth(88)
        editButton.setHeight(88)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
           // Title Label
           titleLabel.font = UIFont(name: "AoboshiOne-Regular", size: 36)
           titleLabel.numberOfLines = 0
           containerView.addSubview(titleLabel)
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.pinTop(to: containerView.topAnchor, 32)
           titleLabel.pinLeft(to: containerView, 24)
           titleLabel.pinRight(to: containerView, 24)

           // Description Label
           descriptionLabel.font = UIFont.systemFont(ofSize: 16)
           descriptionLabel.numberOfLines = 0
           descriptionLabel.textAlignment = .center
           descriptionLabel.textColor = .darkGray
           containerView.addSubview(descriptionLabel)
           descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
           descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 12)
           descriptionLabel.pinCenterX(to: view.centerXAnchor)

           // Separator
           separator.backgroundColor = .lightGray
           containerView.addSubview(separator)
           separator.translatesAutoresizingMaskIntoConstraints = false
           separator.pinTop(to: descriptionLabel.bottomAnchor, 24)
           separator.pinLeft(to: containerView, 24)
           separator.pinRight(to: containerView, 24)
           separator.setHeight(1)
        
        
//           // Goal Label
//           goalLabelTitle.text = "Goal"
//           goalLabelTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//           containerView.addSubview(goalLabelTitle)
//           goalLabelTitle.translatesAutoresizingMaskIntoConstraints = false
//            goalLabelTitle.pinTop(to: separator.bottomAnchor, 10)
//           goalLabelTitle.pinLeft(to: containerView, 24)
//
//           goalLabel.font = UIFont.systemFont(ofSize: 18)
//           containerView.addSubview(goalLabel)
//           goalLabel.translatesAutoresizingMaskIntoConstraints = false
//           goalLabel.pinTop(to: goalLabelTitle.bottomAnchor, 14)
//           goalLabel.pinLeft(to: containerView, 24)
//        
//        // goal container
//        
//        containerView.addSubview(goalContainer)
//        goalContainer.setWidth(352)
//        goalContainer.setHeight(52)
//        goalContainer.pinLeft(to: view, 20)
//        goalContainer.pinTop(to: goalLabel.topAnchor, -12)
//        goalContainer.layer.cornerRadius = 14
//        goalContainer.layer.masksToBounds = true
//       goalContainer.translatesAutoresizingMaskIntoConstraints = false
        
        goalLabelTitle.text = "Goal"
        goalLabelTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        containerView.addSubview(goalLabelTitle)
        goalLabelTitle.translatesAutoresizingMaskIntoConstraints = false
         goalLabelTitle.pinTop(to: separator.bottomAnchor, 24)
        goalLabelTitle.pinLeft(to: containerView, 24)
        
        containerView.addSubview(goalContainer)
        goalContainer.translatesAutoresizingMaskIntoConstraints = false
        goalContainer.setWidth(352)
        goalContainer.setHeight(52)
        goalContainer.pinLeft(to: view, 20)
        goalContainer.pinTop(to: goalLabelTitle.bottomAnchor, 8)
        goalContainer.layer.cornerRadius = 14
        goalContainer.layer.masksToBounds = true
        
        goalLabel.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(goalLabel)
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.pinCenterY(to: goalContainer)
        goalLabel.pinLeft(to: goalContainer, 16)

        // Color Label Title
        colorLabelTitle.text = "Task Color"
        colorLabelTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        containerView.addSubview(colorLabelTitle)
        colorLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        colorLabelTitle.pinTop(to: goalContainer.bottomAnchor, 24)
        colorLabelTitle.pinLeft(to: containerView, 24)

        // Task Color Container
        containerView.addSubview(colorContainer)
        colorContainer.translatesAutoresizingMaskIntoConstraints = false
        colorContainer.setWidth(352)
        colorContainer.setHeight(52)
        colorContainer.pinLeft(to: view, 20)
        colorContainer.pinTop(to: colorLabelTitle.bottomAnchor, 8)
        colorContainer.layer.cornerRadius = 14
        colorContainer.layer.masksToBounds = true

        // Task Color Label (INSIDE the container)
        colorLabel.font = UIFont.systemFont(ofSize: 18)
        colorContainer.addSubview(colorLabel) // ✅ only here
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
//        colorLabel.pinCenterX(to: colorContainer)
//        colorLabel.pinCenterY(to: colorContainer)
        colorLabel.pinCenterY(to: colorContainer)
        colorLabel.pinLeft(to: colorContainer, 16)

        // Add color dot view
        colorDotView.translatesAutoresizingMaskIntoConstraints = false
        colorDotView.backgroundColor = UIColor.systemPink // or whatever color you need
        colorDotView.layer.cornerRadius = 10 // make it round
        colorDotView.layer.masksToBounds = true

        colorContainer.addSubview(colorDotView)

        // Pin it to the right side inside the container
        colorDotView.pinRight(to: colorContainer, 16) // 16pt from the right
        colorDotView.pinCenterY(to: colorContainer)   // vertically centered
        colorDotView.setWidth(20)
        colorDotView.setHeight(20)



       }

    @objc private func editButtonTapped() {
        let changeTaskVC = ChangeTaskAssembly.assembly()
        navigationController?.pushViewController(changeTaskVC, animated: true)
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
