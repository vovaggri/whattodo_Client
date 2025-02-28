//import UIKit
//
//class TaskCell: UITableViewCell {
//    
//    private let titleLabel = UILabel()
//    private let priorityLabel = UILabel()
//    private let timeLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//    }
//    
//    private func setupUI() {
//        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
//        priorityLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        
//        let stack = UIStackView(arrangedSubviews: [priorityLabel, titleLabel, timeLabel])
//        stack.axis = .vertical
//        stack.spacing = 4
//        
//        contentView.addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//    
//    func configure(with viewModel: MainScreen.TaskViewModel) {
//        titleLabel.text = viewModel.title
//        priorityLabel.text = viewModel.priority
//        timeLabel.text = viewModel.timeRange
//    }
//}
