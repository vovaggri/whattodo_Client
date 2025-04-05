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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.textColor = .black
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 14)
        label.textColor = UIColor(hex: "000000", alpha: 0.5)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: Constants.fontName, size: 14)
        label.textColor = UIColor(hex: "000000", alpha: 0.5)
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.4) // Базовый цвет
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Устанавливаем скруглённые углы на contentView
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
            
        // Для тени добавляем настройки на саму ячейку (layer ячейки, а не contentView)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        configureTitleLabel()
        configureTimeLabel()
        configureDescriptionLabel()
        configureCompleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task = nil
        titleLabel.text = nil
        timeLabel.text = nil
        descriptionLabel.text = nil
        completeButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.4) // Сброс к базовому состоянию
        completeButton.setImage(nil, for: .normal)
    }
    
    func configure(with task: Task) {
        self.task = task
        titleLabel.text = task.title
        contentView.backgroundColor = task.getColour()
        
        if task.startTime == task.endTime {
            timeLabel.text = "Any time today"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let startTime = task.startTime, let endTime = task.endTime {
                // Converting UTC to the local zone
                let localStart = startTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                let localEnd = endTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                
                timeLabel.text = "\(formatter.string(from: localStart)) - \(formatter.string(from: localEnd))"
            } else {
                timeLabel.text = "Any time today"
            }
        }
        
        if task.description == "" {
            descriptionLabel.text = "No description"
        } else {
            if let description = task.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = "No description"
            }
        }
        
        updateCompleteButtonAppearance()
    }
    
    func updateCompleteButtonAppearance() {
        guard let task = task else { return }
        
        if task.done {
            completeButton.backgroundColor = .systemYellow
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.tintColor = .white
        } else {
            completeButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.4)
            completeButton.setImage(nil, for: .normal)
        }
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.pinTop(to: contentView.topAnchor, 20)
        titleLabel.pinLeft(to: contentView.leadingAnchor, 30)
        titleLabel.pinRight(to: contentView.trailingAnchor)
    }
    
    private func configureTimeLabel() {
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.pinTop(to: titleLabel.bottomAnchor, 10)
        timeLabel.pinLeft(to: contentView.leadingAnchor, 30)
        timeLabel.pinRight(to: contentView.trailingAnchor)
    }
    
    private func configureDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.pinTop(to: timeLabel.bottomAnchor, 10)
        descriptionLabel.pinLeft(to: contentView.leadingAnchor, 30)
        descriptionLabel.pinRight(to: contentView.trailingAnchor, 30)
    }
    
    private func configureCompleteButton() {
        contentView.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        completeButton.setHeight(30)
        completeButton.setWidth(30)
        completeButton.pinCenterY(to: contentView.centerYAnchor)
        completeButton.pinRight(to: contentView.trailingAnchor, 10)
    }
    
    @objc private func didTapCompleteButton() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.task?.done == false {
                self.task?.done = true
                self.completeButton.backgroundColor = .systemYellow
                self.completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            } else {
                self.task?.done = false
                self.completeButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.4)
                self.completeButton.setImage(nil, for: .normal)
            }
        }) { _ in
            // Message to vc that task is completed
            self.delegate?.taskCellDidCompleteTask(self)
        }
    }
}
