import UIKit

// MARK: - Protocols
protocol GoalDetailDisplayLogic: AnyObject {
    func displayGoalInfo(viewModel: GoalDetail.Info.ViewModel)
}
import UIKit

final class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
  

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }

    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}



// MARK: - View Controller
final class GoalDetailViewController: UIViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationItem.hidesBackButton = true


        // Add shimmer only once
        if aiButton.subviews.contains(where: { $0 is ShimmerView }) { return }

        let shimmer = ShimmerView(frame: aiButton.bounds)
        shimmer.isUserInteractionEnabled = false
        shimmer.layer.cornerRadius = aiButton.layer.cornerRadius
        shimmer.clipsToBounds = true
        shimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        aiButton.insertSubview(shimmer, belowSubview: aiButton.titleLabel!)
        shimmer.startAnimating()
    }



    // MARK: - SVIP
    var interactor: GoalDetailBusinessLogic?

    // MARK: - UI Elements

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)

        // Use SF Symbol arrow
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
        return button
    }()

    private let gettingStartedLabel: UILabel = {
        let label = UILabel()
        label.text = "Getting Started"
        label.textAlignment = .center
        label.font = UIFont(name: "AoboshiOne-Regular", size: 22)
        label.textColor = .black
        return label
    }()


    private let goalTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "IOS dev"
        lbl.font = UIFont(name: "AoboshiOne-Regular", size: 50)
        lbl.textColor = UIColor(red: 179/255, green: 207/255, blue: 221/255, alpha: 1)
        return lbl
    }()

    private let tasksLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "tasks:"
        lbl.font = UIFont(name: "AoboshiOne-Regular", size: 50)
        lbl.textColor = .black
        return lbl
    }()

    private let taskContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 243/255, blue: 247/255, alpha: 1)
        view.layer.cornerRadius = 18
        return view
    }()

    private let addTaskButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(UIColor.black.withAlphaComponent(0.72), for: .normal)

        btn.backgroundColor = UIColor(red: 179/255, green: 207/255, blue: 221/255, alpha: 0.9)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 43, weight: .bold)
        btn.layer.cornerRadius = 78 / 2
        return btn
    }()

    private let aiButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("AI", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(white: 0.15, alpha: 1)
        btn.layer.cornerRadius = 48 / 2
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 24)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

       

        aiButton.titleLabel?.layer.zPosition = 1

        setupUI()
        setupConstraints()

        interactor?.fetchGoalInfo(request: GoalDetail.Info.Request())
    }

    private func setupUI() {
        [closeButton, gettingStartedLabel, goalTitleLabel, tasksLabel, taskContainerView, addTaskButton, aiButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }


        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        addTaskButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func plusButtonTapped() {
        let createGTaskVC = CreateGTaskAssembly.assembly()
        navigationController?.pushViewController(createGTaskVC, animated: true)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 70),
            closeButton.heightAnchor.constraint(equalToConstant: 70),
            gettingStartedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            gettingStartedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            goalTitleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24),
            goalTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            tasksLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 16),
            tasksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            addTaskButton.topAnchor.constraint(equalTo: tasksLabel.centerYAnchor, constant: 20.6),
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addTaskButton.widthAnchor.constraint(equalToConstant: 78),
            addTaskButton.heightAnchor.constraint(equalToConstant: 78),

            taskContainerView.topAnchor.constraint(equalTo: tasksLabel.bottomAnchor, constant: 24),
            taskContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            taskContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            taskContainerView.heightAnchor.constraint(equalToConstant: 300),

            aiButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            aiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            aiButton.widthAnchor.constraint(equalToConstant: 78),
            aiButton.heightAnchor.constraint(equalToConstant: 78),
        ])
    }
}

// MARK: - Display Logic
extension GoalDetailViewController: GoalDetailDisplayLogic {
    func displayGoalInfo(viewModel: GoalDetail.Info.ViewModel) {
        goalTitleLabel.text = viewModel.title
    }
}
