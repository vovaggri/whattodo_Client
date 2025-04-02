import UIKit

final class CategoryCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        // Title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        // Progress label
        progressLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

        
        func configure(with category: MainModels.Fetch.CategoryViewModel) {
            // Normal category display
            titleLabel.text = category.title
            progressLabel.text = category.progressText
            progressView.progress = category.progressValue
            
            contentView.backgroundColor = category.color.withAlphaComponent(0.2)
            
            // Show/hide whichever subviews you need
            titleLabel.isHidden = false
            progressLabel.isHidden = false
            progressView.isHidden = false
        }
        
    func configureAsAddGoal() {
        // Special "Add Goal" style: Set up text with two lines.
        titleLabel.text = "Tap here to\nadd a new goal"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: MainScreenViewController.Constants.fontName, size: 16)
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        
        // Set background color.
        contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        // Remove any previous constraints on titleLabel (if necessary)
        titleLabel.removeFromSuperview()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Center the titleLabel within the contentView.
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
        
        // Adjust cell size: set fixed width and height for the contentView.
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 180),
            contentView.heightAnchor.constraint(equalToConstant: 135)
        ])
        
        // Hide progress elements.
        progressLabel.isHidden = true
        progressView.isHidden = true
    }



    }

    

    
  


    

