import UIKit

protocol HeaderViewDelegate: AnyObject {
    func headerViewDidTapGreeting(_ headerView: HeaderView)
}

final class HeaderView: UIView {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    weak var delegate: HeaderViewDelegate?
    
    var bottomAnchorView: UIView {
        return line2Label
    }
    
    private let avatarImageView = UIImageView()
    private let greetingLabel = UILabel()
    private let settingsButton = UIButton(type: .system)

    private let line1Label: UILabel = {
        let label = UILabel()
        label.text = "Manage your"
        label.font = UIFont(name: Constants.fontName, size: 32)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let line2Label: UILabel = {
        let label = UILabel()
        label.text = "goals in categories"
        label.font = UIFont(name: Constants.fontName, size: 32)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white

        // Turn off Auto Layout for subviews
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        line1Label.translatesAutoresizingMaskIntoConstraints = false
        line2Label.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        addSubview(avatarImageView)
        addSubview(greetingLabel)
        addSubview(settingsButton)
        addSubview(line1Label)
        addSubview(line2Label)

        // Example layout:
        // 1) "Hi, Jovana!" pinned to top-left
        greetingLabel.pinTop(to: self, 16)
        greetingLabel.pinLeft(to: self, 16)

        // 2) line1Label pinned below greetingLabel
        line1Label.pinTop(to: greetingLabel.bottomAnchor, 16)
        line1Label.pinLeft(to: self, 16)
        line1Label.pinRight(to: self, 16)

        // 3) line2Label pinned below line1Label
        line2Label.pinTop(to: line1Label.bottomAnchor, 4)
        line2Label.pinLeft(to: line1Label.leadingAnchor)
        line2Label.pinRight(to: line1Label.trailingAnchor)

        // (Optional) Position the avatar top-left, or near greetingLabel
        avatarImageView.pinTop(to: self, 16)
        avatarImageView.pinLeft(to: self, 16, .equal)
        avatarImageView.setWidth(mode: .equal, 40)
        avatarImageView.setHeight(mode: .equal, 40)

        // (Optional) Position settings button top-right
        settingsButton.pinTop(to: self, 16)
        settingsButton.pinRight(to: self, 16)
        settingsButton.setWidth(mode: .equal, 24)
        settingsButton.setHeight(mode: .equal, 24)
        
        greetingLabel.font = UIFont(name: Constants.fontName, size: 20)
        
        // Tap Gesture
        greetingLabel.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(grettingTapped))
        greetingLabel.addGestureRecognizer(tapGR)
    }

    
    func displayHeader(greeting: String, avatar: UIImage?) {
        avatarImageView.image = avatar

        let font = greetingLabel.font ?? UIFont(name: Constants.fontName, size: 20) ?? .systemFont(ofSize: 20)
        let color = greetingLabel.textColor ?? .black

        let text = greeting + " "
        let attributed = NSMutableAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: color
        ])

        let attachment = NSTextAttachment()
        if let image = UIImage(systemName: "chevron.compact.forward") {
            attachment.image = image

            let ratio = image.size.width / image.size.height
            let height = 15.0
            let width = 16.0
            let yOffset = (font.descender + font.ascender - height) / 2
            attachment.bounds = CGRect(x: 0, y: yOffset, width: width, height: height)
        }
        
        attributed.append(NSAttributedString(attachment: attachment))
        greetingLabel.attributedText = attributed
        avatarImageView.image = avatar
    }
    
    @objc private func grettingTapped() {
        delegate?.headerViewDidTapGreeting(self)
    }
}
extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

