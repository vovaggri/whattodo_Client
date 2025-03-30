import UIKit

// MARK: - Protocols
protocol GoalDetailDisplayLogic: AnyObject {
    func displayGoalInfo(viewModel: GoalDetail.Info.ViewModel)
}

// MARK: - View Controller
final class GoalDetailViewController: UIViewController {

    // MARK: - SVIP
    var interactor: GoalDetailBusinessLogic?

    // MARK: - UI Elements

    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 19)
        return btn
    }()

    private let goalTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "IOS dev"
        lbl.font = UIFont(name: "AoboshiOne-Regular", size: 32)
        lbl.textColor = UIColor(red: 179/255, green: 207/255, blue: 221/255, alpha: 1)
        return lbl
    }()

    private let tasksLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "tasks:"
        lbl.font = UIFont(name: "AoboshiOne-Regular", size: 28)
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
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(red: 179/255, green: 207/255, blue: 221/255, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        btn.layer.cornerRadius = 48 / 2
        return btn
    }()

    private let aiButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("AI", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(white: 0.15, alpha: 1)
        btn.layer.cornerRadius = 48 / 2
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 20)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

       
        setupUI()
        setupConstraints()

        interactor?.fetchGoalInfo(request: GoalDetail.Info.Request())
    }

    private func setupUI() {
        [closeButton, goalTitleLabel, tasksLabel, taskContainerView, addTaskButton, aiButton].forEach {
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
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            goalTitleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24),
            goalTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            tasksLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 16),
            tasksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            addTaskButton.centerYAnchor.constraint(equalTo: tasksLabel.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addTaskButton.widthAnchor.constraint(equalToConstant: 48),
            addTaskButton.heightAnchor.constraint(equalToConstant: 48),

            taskContainerView.topAnchor.constraint(equalTo: tasksLabel.bottomAnchor, constant: 24),
            taskContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            taskContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            taskContainerView.heightAnchor.constraint(equalToConstant: 280),

            aiButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            aiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            aiButton.widthAnchor.constraint(equalToConstant: 64),
            aiButton.heightAnchor.constraint(equalToConstant: 64),
        ])
    }
}

// MARK: - Display Logic
extension GoalDetailViewController: GoalDetailDisplayLogic {
    func displayGoalInfo(viewModel: GoalDetail.Info.ViewModel) {
        goalTitleLabel.text = viewModel.title
    }
}
