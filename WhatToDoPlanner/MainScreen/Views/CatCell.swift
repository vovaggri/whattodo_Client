import UIKit

final class CatCell: UICollectionViewCell {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    private let titleLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let tasksLeftLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with goal: Goal) {
        // Normal category display
        titleLabel.font = UIFont(name: Constants.fontName, size: 24)
        titleLabel.text = goal.title
        titleLabel.textColor = UIColor(hex: "000000", alpha: 0.65)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
//        progressLabel.text = category.progressText
//        progressView.progress = category.progressValue
        
        contentView.backgroundColor = goal.getColour()
            
        // Show/hide whichever subviews you need
//        progressLabel.isHidden = false
//        progressView.isHidden = false
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        titleLabel.pinCenterY(to: contentView.centerYAnchor, -30)
        titleLabel.pinRight(to: contentView.trailingAnchor, 15)
    }
}
