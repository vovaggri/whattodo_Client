import UIKit

//protocol SettingsBusinessLogic: AnyObject {
//    func fetchUserInfo()
//    func logOut()
//}

final class SettingsVC: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let fontName               = "AoboshiOne-Regular"
        static let margin: CGFloat        = 16
        static let containerCornerRadius: CGFloat = 30
        static let lightGrayColor = UIColor(
            red:   247.0/255.0,
            green: 249.0/255.0,
            blue:  249.0/255.0,
            alpha: 1.0
        )
        static let rowHeight: Double      = 60
        
        
        // …
        static let separatorHeight: Double = 1
        static let separatorInset: Double = 10  // same as your margin
    }

    // MARK: - SVIP Reference
    var interactor: SettingsBusinessLogic?

    // MARK: - UI Elements
    private var backButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        
        button.tintColor = .black
        button.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Settings"
        lbl.font = UIFont(name: Constants.fontName, size: 27)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()

    private let fullNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Constants.fontName, size: 27)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()

    private let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.textColor = .gray
        return lbl
    }()

    private let generalLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "General"
        lbl.font = UIFont(name: Constants.fontName, size: 14)
        lbl.textColor = .darkGray
        return lbl
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Constants.lightGrayColor
        v.layer.cornerRadius = Constants.containerCornerRadius
        v.clipsToBounds = true
        return v
    }()
    
    // MARK: —– separators
    private let separator1: UIView = {
      let v = UIView()
   //   v.backgroundColor = .lightGray
      return v
    }()
    private let separator2: UIView = {
      let v = UIView()
      v.backgroundColor = .lightGray
      return v
    }()


    private lazy var changeUsernameRow = makeRow(title: "Change username", icon: "chevron.right")
    private lazy var changePasswordRow = makeRow(title: "Change password", icon: "chevron.right")
    private lazy var logoutRow         = makeRow(title: "Logout",          icon: "arrow.right.square")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel

        setupHierarchy()
        setupConstraints()

        interactor?.fetchUserInfo()
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Display Logic
    func displayUser(_ user: MainModels.Fetch.UserResponse) {
        fullNameLabel.text = user.firstName + " " + user.secondName
        emailLabel.text    = user.email
    }
    
    // MARK: - Setup
    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(fullNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(generalLabel)
        view.addSubview(containerView)
        
        

        containerView.addSubview(changeUsernameRow)
        containerView.addSubview(changePasswordRow)
        containerView.addSubview(logoutRow)
        
        // add separators
        containerView.addSubview(separator1)
        containerView.addSubview(separator2)
    }
    
    

    private func setupConstraints() {
        // turn off autoresizing
        [ backButton, titleLabel, fullNameLabel, emailLabel, generalLabel, containerView,
         changeUsernameRow, changePasswordRow, logoutRow]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, -10)
        backButton.pinLeft(to: view, 16)
        backButton.setWidth(70)
        backButton.setHeight(70)
        
        
        titleLabel
            .pinTop(to: view.safeAreaLayoutGuide.topAnchor, 40)
        titleLabel.pinCenterX(to: view)
        
        // Top labels
        fullNameLabel
            .pinTop(to: titleLabel.bottomAnchor, 100)
        fullNameLabel.pinCenterX(to: view)

        emailLabel
            .pinTop(to: fullNameLabel.bottomAnchor, 8)
        emailLabel.pinCenterX(to: view)

        // "General"
        generalLabel
            .pinTop(to: emailLabel.bottomAnchor, 166)
        generalLabel.pinLeft(to: view, Constants.margin)
        generalLabel.pinRight(to: view, Constants.margin)

        // Container
        containerView
            .pinTop(to: generalLabel.bottomAnchor, 13)
        containerView.pinLeft(to: view, Constants.margin)
        containerView.pinRight(to: view, Constants.margin)

        // Rows inside container
        changeUsernameRow
            .pinTop(to: containerView, 0)
        changeUsernameRow.pinLeft(to: containerView, 0)
        changeUsernameRow.pinRight(to: containerView, 0)
        changeUsernameRow.setHeight(Constants.rowHeight)
        
        separator1.translatesAutoresizingMaskIntoConstraints = false
          separator1
            .pinLeft(to: containerView, Constants.separatorInset)
          separator1
            .pinRight(to: containerView, Constants.separatorInset)
          separator1
            .setHeight(Constants.separatorHeight)
          separator1
            .pinTop(to: changeUsernameRow.bottomAnchor, 0)
        separator1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)

        changePasswordRow
            .pinTop(to: changeUsernameRow.bottomAnchor, 0)
        changePasswordRow.pinLeft(to: containerView, 0)
        changePasswordRow.pinRight(to: containerView, 0)
        changePasswordRow.setHeight(Constants.rowHeight)
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
         separator2
           .pinLeft(to: containerView, Constants.separatorInset)
         separator2
           .pinRight(to: containerView, Constants.separatorInset)
         separator2
           .setHeight(Constants.separatorHeight)
         separator2
           .pinTop(to: changePasswordRow.bottomAnchor, 0)
        separator2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)


        logoutRow
            .pinTop(to: changePasswordRow.bottomAnchor, 0)
        logoutRow.pinLeft(to: containerView, 0)
        logoutRow.pinRight(to: containerView, 0)
        logoutRow.setHeight(Constants.rowHeight)
        logoutRow.pinBottom(to: containerView, 0)
    }

    // MARK: - Row Factory
    private func makeRow(title: String, icon: String) -> UIView {
        let row = UIView()
        let lbl = UILabel()
        lbl.text = title
        lbl.font = UIFont(name: Constants.fontName, size: 16)
        lbl.textColor = (title == "Logout") ? .systemRed : .darkGray

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit

        row.addSubview(lbl)
        row.addSubview(iconView)

        lbl.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // label & icon constraints
        lbl.pinLeft(to: row, Constants.margin)
        lbl.pinCenterY(to: row)

        iconView.pinRight(to: row, Constants.margin)
        iconView.setHeight(20)
        iconView.setWidth(20)
        iconView.pinCenterY(to: row)

        // tap handling
        row.isUserInteractionEnabled = true
        row.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(rowTapped(_:)))
        )
        return row
    }
    
    private func confirmLogOut() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.addAction(
            UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
                self?.interactor?.logOut()
            }
        )
        present(alert, animated: true)
    }

    // MARK: - Actions
    @objc private func rowTapped(_ g: UITapGestureRecognizer) {
        guard let v = g.view else { return }
        switch v {
        case changeUsernameRow:
            // … handle change username
            break
        case changePasswordRow:
            let forgotPasswordVC = ForgotScreenAssembly.assemble()
            navigationController?.pushViewController(forgotPasswordVC, animated: true)
        case logoutRow:
            confirmLogOut()
        default:
            break
        }
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
