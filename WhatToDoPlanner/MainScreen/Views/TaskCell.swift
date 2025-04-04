import UIKit

final class TaskCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "TaskCell"
        static let fontName: String = "AoboshiOne-Regular"
    }
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        contentView.backgroundColor = task.getColour()
        
        if task.startTime == task.endTime {
            timeLabel.text = "Any time today"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(abbreviation: "UTC") // Указываем явно UTC
            
            if let startTime = task.startTime, let endTime = task.endTime {
                // Конвертируем UTC-время в локальную зону устройства
                let localStart = startTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                let localEnd = endTime.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                
                timeLabel.text = "\(formatter.string(from: localStart)) - \(formatter.string(from: localEnd))"
            } else {
                timeLabel.text = "Any time today"
            }
        }
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.pinTop(to: contentView.topAnchor, 40)
        titleLabel.pinLeft(to: contentView.leadingAnchor, 30)
        titleLabel.pinRight(to: contentView.trailingAnchor)
    }
    
    private func configureTimeLabel() {
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.pinTop(to: titleLabel.bottomAnchor, 20)
        timeLabel.pinLeft(to: contentView.leadingAnchor, 30)
        timeLabel.pinRight(to: contentView.trailingAnchor)
    }
}
