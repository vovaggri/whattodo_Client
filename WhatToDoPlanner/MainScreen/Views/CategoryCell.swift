//import UIKit
//
//class CategoryCell: UICollectionViewCell {
//    
//    private let titleLabel = UILabel()
//    private let progressLabel = UILabel()
//    private let progressView = UIProgressView(progressViewStyle: .default)
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//    }
//    
//    private func setupUI() {
//        contentView.layer.cornerRadius = 12
//        contentView.clipsToBounds = true
//        
//        // Title
//        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
//        
//        // Progress label
//        progressLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(progressLabel)
//        contentView.addSubview(progressView)
//        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        progressLabel.translatesAutoresizingMaskIntoConstraints = false
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            
//            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            
//            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
//            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            progressView.heightAnchor.constraint(equalToConstant: 4),
//            progressView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//    
//    func configure(with viewModel: MainScreen.CategoryViewModel) {
//        titleLabel.text = viewModel.title
//        progressLabel.text = viewModel.progressText
//        progressView.progress = viewModel.progressValue
//        contentView.backgroundColor = viewModel.color.withAlphaComponent(0.2)
//    }
//}
