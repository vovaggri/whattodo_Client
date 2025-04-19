import UIKit

// MARK: - View Controller
final class GoalDetailViewController: UIViewController {
    var goalId: Int?
    var goal: Goal?
    // MARK: - SVIP
    var interactor: GoalDetailBusinessLogic?
    private var tasks: [Task] = []

    // MARK: - UI Elements

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)

//        // Use SF Symbol arrow
//        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
//        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
//        button.setImage(image, for: .normal)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 22)

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
    
    private var taskGCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        aiButton.titleLabel?.layer.zPosition = 1
        guard let goalId = goalId else {
            return
        }
        interactor?.fetchGoalInfo(with: goalId)
        interactor?.loadTasks(with: goalId)

        setupUI()
        setupConstraints()
        configureTaskCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.loadTasks(with: goalId ?? 0)
    }
    
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
    
    func displayGoalInfo(viewModel: GoalDetail.Info.ViewModel, goalResponse: Goal) {
        goal = goalResponse
        goalTitleLabel.text = viewModel.title
        goalTitleLabel.textColor = goal?.getColour().adjusted(saturationOffset: 0.20, brightnessOffset: -0.15)
        taskContainerView.backgroundColor = goal?.getColour()
        addTaskButton.backgroundColor = goal?.getColour().adjusted(saturationOffset: 0.20, brightnessOffset: -0.15)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
//    func showDeleteAlert(with taskId: Int, at indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Delete task", message: "Are you sure that you want delete this task", preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//            guard let self = self else { return }
//            self.tasks.remove(at: indexPath.row)
//            self.taskGCollectionView.deleteItems(at: [indexPath])
//            self.interactor?.deleteTask(with: taskId)
//        }
//        alert.addAction(deleteAction)
//        
//        present(alert, animated: true)
//    }
    
    func showTasks(with tasks: [Task]) {
        self.tasks = tasks
        taskGCollectionView.reloadData()
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
        let mainVC = MainAssembly.assembly()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
    @objc private func plusButtonTapped() {
        let createGTaskVC = CreateGTaskAssembly.assembly(with: goalId ?? 0)
        navigationController?.pushViewController(createGTaskVC, animated: true)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
    
    private func configureTaskCollection() {
        // Регистрируем нашу кастомную ячейку
        taskGCollectionView.register(TaskGCell.self, forCellWithReuseIdentifier: TaskGCell.Constants.identifier)

        
        view.addSubview(taskGCollectionView)
        taskGCollectionView.dataSource = self
        taskGCollectionView.delegate = self
        
        taskGCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        taskGCollectionView.pinTop(to: addTaskButton.bottomAnchor, 30)
        taskGCollectionView.pinLeft(to: taskContainerView.leadingAnchor)
        taskGCollectionView.pinRight(to: taskContainerView.trailingAnchor)
        taskGCollectionView.pinBottom(to: taskContainerView.bottomAnchor, 10)
    }
}

extension GoalDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskGCell.Constants.identifier, for: indexPath) as? TaskGCell else {
            return UICollectionViewCell()
        }
        
        let task = self.tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}

extension GoalDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        print("Selected \(selectedTask.title)")
    }
}

extension GoalDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 90)
    }
}
