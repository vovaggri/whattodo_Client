import UIKit

final class CatCell: UICollectionViewCell {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 12
        static let interItemSpacing: CGFloat = 14
        static let progressHeight: CGFloat = 9
    }
    
    private let titleLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let tasksLeftLabel = UILabel()
    static let reuseIdentifier = "CatCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        progressView.layoutIfNeeded()
        
        let radius = progressView.frame.height / 2
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        
        for subview in progressView.subviews {
            subview.layer.cornerRadius = radius
            subview.clipsToBounds = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with goal: Goal, progress: Int) {
        let baseColor = goal.getColour()
        layer.shadowColor = baseColor.cgColor
        // Title
        titleLabel.text = goal.title
                
        // Progress bar
        progressView.progress = Float(progress) / 100.0
        // Lightet than base color
        progressView.progressTintColor = baseColor.adjusted(saturationOffset: 0.20, brightnessOffset: -0.15)
        progressView.trackTintColor = UIColor(hex: "000000", alpha: 0.2)
                
        // Percentage
        progressLabel.text = "\(progress)%"
                
        // Completed / total
        tasksLeftLabel.text = "\(goal.completedTasks)/\(goal.totalTasks)"
                
        contentView.backgroundColor = baseColor
    }
    private func setupAppearance() {
          // round the corners of the content view
          contentView.layer.cornerRadius = 34
          contentView.layer.masksToBounds = true
          
          // if you ever want a shadow behind that rounded card:
          layer.shadowColor   = UIColor.black.cgColor
          layer.shadowOpacity = 0.4
          layer.shadowOffset  = CGSize(width: 0, height: 4)
          layer.shadowRadius  = 4
       
          layer.masksToBounds = false
      }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
                
        [titleLabel, progressView, progressLabel, tasksLeftLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
                
        
        titleLabel.font = UIFont(name: Constants.fontName, size: 35)
            titleLabel.numberOfLines = 1
            titleLabel.adjustsFontSizeToFitWidth = true
    
            // give it 60% opacity
            titleLabel.textColor = UIColor.label.withAlphaComponent(0.76)
  
                
        progressLabel.font = UIFont(name: Constants.fontName, size: 11)
        tasksLeftLabel.font = UIFont(name: Constants.fontName, size: 14)
        
        titleLabel.textAlignment = .right
        titleLabel.pinCenterY(to: contentView.centerYAnchor, -30)
     //   titleLabel.pinLeft(to: contentView.leadingAnchor, Constants.horizontalPadding)
        titleLabel.pinRight(to: contentView.leadingAnchor, -165)
        titleLabel.widthAnchor
            .constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7)
            .isActive = true
                
        
        progressView.pinTop(to: titleLabel.bottomAnchor, Constants.interItemSpacing)
        progressView.pinLeft(to: contentView.leadingAnchor, 24)
        progressView.pinRight(to: contentView.trailingAnchor, 24)
        progressView.setHeight(Constants.progressHeight)
        
        progressLabel.pinBottom(to: progressView.topAnchor, 5)
        progressLabel.pinLeft(to: progressView)
       progressLabel.textColor = UIColor.label.withAlphaComponent(0.85)
        
        tasksLeftLabel.pinTop(to: progressView.bottomAnchor, 3)
        tasksLeftLabel.pinRight(to: progressView.trailingAnchor)
        tasksLeftLabel.font = UIFont(name: Constants.fontName, size: 14)
          tasksLeftLabel.textColor = UIColor.label.withAlphaComponent(0.5)
    }
}
