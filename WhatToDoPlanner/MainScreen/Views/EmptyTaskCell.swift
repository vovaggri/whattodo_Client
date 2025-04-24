import UIKit

final class EmptyTaskCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "EmptyTaskCell"
        static let fontName: String = "AoboshiOne-Regular"
        static let titleText: String = "No tasks for today :("
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 17)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Устанавливаем скруглённые углы на contentView
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        titleLabel.text = Constants.titleText
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.pinCenterX(to: contentView)
        titleLabel.pinCenterY(to: contentView)
 
    }
}
