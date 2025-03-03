import UIKit

final class HeaderView: UIView {
    
    private let avatarImageView = UIImageView()
    private let greetingLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    private let explination = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: "F0F1F1")
        
        // Avatar
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        // Greeting label
        greetingLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        greetingLabel.textColor = .black
        
        // Settings button
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .black
        
        addSubview(avatarImageView)
        addSubview(greetingLabel)
        addSubview(settingsButton)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            greetingLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            greetingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            settingsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 24),
            settingsButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func displayHeader(greeting: String, avatar: UIImage?) {
        greetingLabel.text = greeting
        avatarImageView.image = avatar
    }
}
