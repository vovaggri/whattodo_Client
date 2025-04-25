import UIKit

protocol taskCellDelegate: AnyObject {
    func taskCellDidCompleteTask(_ cell: TaskCell)
}

final class TaskCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "TaskCell"
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    weak var delegate: taskCellDelegate?
    private var task: Task?
    
    // MARK: - Subviews
    
    private let verticalBar: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7  // half of 14 for a rounded bar
        view.clipsToBounds = true
        return view
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "D9D9D9", alpha: 0.3)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.setImage(nil, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.textColor = .black
        return label
    }()
    
    private let timeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "clock.fill"))
        iv.tintColor = UIColor(hex: "000000", alpha: 0.5)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 14)
        label.textColor = UIColor(hex: "000000", alpha: 0.5)
        return label
    }()
    
    // If you need description below time, just create another label similarly

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Cell styling
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // 1) Vertical bar on the left
        configureVerticalBar()
        
        // 2) Complete button on the right
        configureCompleteButton()
        
        // 3) Title label at the top (and will stretch toward the right)
        configureTitleLabel()
        
        // 4) Time icon below the title
        configureTimeIcon()
        
        // 5) Time label next to the time icon
        configureTimeLabel()
        
        // If you want a description label below timeLabel, add here
        // configureDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Methods
    
    func configureMain(with task: Task) {
        self.task = task
        
        // Always white for the cell background
        contentView.backgroundColor = .white
        
        // The vertical bar color is based on the user's chosen color
        verticalBar.backgroundColor = task.getColour()
        
        // Main task title
        titleLabel.text = task.title
        
        // Time logic
        if let startTime = task.startTime, let endTime = task.endTime, startTime != endTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let localStart = startTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
            let localEnd = endTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
            timeLabel.text = "\(formatter.string(from: localStart)) - \(formatter.string(from: localEnd))"
        } else {
            timeLabel.text = "Any time today"
        }
        
        // Check if you have a description property
        // ...
        
        // Update the complete button state (checked or not)
        updateCompleteButtonAppearance()
    }
    
    func configureReview(with task: Task) {
        self.task = task
        
        // Always white for the cell background
        contentView.backgroundColor = .white
        
        // The vertical bar color is based on the user's chosen color
        verticalBar.backgroundColor = task.getColour()
        
        // Main task title
        titleLabel.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let formattedDate = formatter.string(from: task.endDate)
        timeLabel.text = formattedDate
        
        updateCompleteButtonAppearance()
    }
    
    func updateCompleteButtonAppearance() {
        guard let task = task else { return }
        
        if task.done {
            completeButton.backgroundColor = .systemYellow
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.tintColor = .white
        } else {
            completeButton.backgroundColor = UIColor(hex: "D9D9D9", alpha: 0.3)
            completeButton.setImage(nil, for: .normal)
        }
    }
    
    // MARK: - Private Subview Configuration
    
    private func configureVerticalBar() {
        contentView.addSubview(verticalBar)
        verticalBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalBar.widthAnchor.constraint(equalToConstant: 14),
            verticalBar.heightAnchor.constraint(equalToConstant: 62)
        ])
    }
    
    private func configureCompleteButton() {
        contentView.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add target
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            completeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 40),
            completeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title at the top; pinned between verticalBar on the left and completeButton on the right
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.5),
            titleLabel.leadingAnchor.constraint(equalTo: verticalBar.trailingAnchor, constant: 11),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: completeButton.leadingAnchor, constant: -8)
        ])
    }
    
    private func configureTimeIcon() {
        contentView.addSubview(timeIcon)
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Placed under the titleLabel
            timeIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            // Start to the right of the verticalBar
            timeIcon.leadingAnchor.constraint(equalTo: verticalBar.trailingAnchor, constant: 8),
            timeIcon.widthAnchor.constraint(equalToConstant: 16),
            timeIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureTimeLabel() {
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Align center vertically with timeIcon
            timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor),
            // Start just to the right of timeIcon
            timeLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 8),
            // Don’t overlap the complete button
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: completeButton.leadingAnchor, constant: -8)
        ])
    }
    
    // If you want a descriptionLabel, place it below timeLabel similarly

    // MARK: - Actions
    
    @objc private func didTapCompleteButton() {
        guard let task = task else { return }
        UIView.animate(withDuration: 0.3) {
            if task.done == false {
                self.task?.done = true
                self.completeButton.backgroundColor = .systemYellow
                self.completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            } else {
                self.task?.done = false
                self.completeButton.backgroundColor = UIColor(hex: "D9D9D9", alpha: 0.3)
                self.completeButton.setImage(nil, for: .normal)
            }
        } completion: { _ in
            self.delegate?.taskCellDidCompleteTask(self)
        }
    }
}
