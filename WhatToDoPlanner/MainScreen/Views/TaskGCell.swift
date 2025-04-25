import UIKit

final class TaskGCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "TaskGCell"
        static let fontName: String = "AoboshiOne-Regular"
    }
    
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
    
    func configure(with task: Task) {
        self.task = task
        
        // Always white for the cell background
        contentView.backgroundColor = .white
        
        // The vertical bar color is based on the user's chosen color
        verticalBar.backgroundColor = task.getColour()
        
        // Main task title
        titleLabel.text = task.title
        
        // Time logic
//        if let startTime = task.startTime, let endTime = task.endTime, startTime != endTime {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH:mm"
//            formatter.timeZone = TimeZone(abbreviation: "UTC")
//            let localStart = startTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
//            let localEnd = endTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
//            timeLabel.text = "\(formatter.string(from: localStart)) - \(formatter.string(from: localEnd))"
//        } else {
//            timeLabel.text = "Any time today"
//        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let formattedDate = formatter.string(from: task.endDate)
        timeLabel.text = formattedDate
        // Check if you have a description property
        // ...
        
        // Update the complete button state (checked or not)
        updateCompleteButtonAppearance()
    }
    
    func updateCompleteButtonAppearance() {
        guard let task = task else { return }
        
        if task.done {
            completeButton.backgroundColor = UIColor(hex: "#DAECF3")
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.tintColor = UIColor(hex: "#3E3E3E")
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
            verticalBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            verticalBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            verticalBar.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title at the top; pinned between verticalBar on the left and completeButton on the right
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: verticalBar.trailingAnchor, constant: 11),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureTimeIcon() {
      contentView.addSubview(timeIcon)
      timeIcon.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        timeIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        timeIcon.leadingAnchor.constraint(equalTo: verticalBar.trailingAnchor, constant: 8),
        timeIcon.widthAnchor.constraint(equalToConstant: 16),
        timeIcon.heightAnchor.constraint(equalToConstant: 16),
        timeIcon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
      ])
    }

    private func configureTimeLabel() {
      contentView.addSubview(timeLabel)
      timeLabel.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor),
        timeLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 8),
        timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
        timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
      ])
    }

    // MARK: - Actions
}
