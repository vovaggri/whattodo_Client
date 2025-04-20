import UIKit

final class AIVC: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    var interactor: AIBusinessLogic?
    var goalId: Int? = 0
    
    // MARK: – Data
    private var goal: Goal? {
        didSet {
            // обновляем заголовок сразу после получения цели
            DispatchQueue.main.async { self.configureHeader() }
        }
    }
    
    private let aiHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "WhatToDo AI"
        label.textAlignment = .center
        label.font = UIFont(name: "AoboshiOne-Regular", size: 22)
        label.textColor = .black
        return label
    }()
    
    private let headerScreen: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Constants.fontName, size: 27)
        return label
    }()
    
    private let generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate advice", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)

        // Use SF Symbol arrow
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)

        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2
        button.clipsToBounds = false
        return button
    }()
    
    // MARK: – UI для AI‑ответа
    private let aiView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let shimmerView: ShimmerView = {
        let v = ShimmerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    
    private let thinkingLabel: UILabel = {
        let l = UILabel()
        l.text = "AI is thinking"
        l.textAlignment = .left
        l.font = UIFont(name: Constants.fontName, size: 18)
        l.textColor = .gray
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let responseLabel: UILabel = {
        let l = UILabel()
        l.text = ""
        l.numberOfLines = 0
        l.font = UIFont(name: Constants.fontName, size: 16)
        l.textColor = .black
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = goalId else { return }
        interactor?.fetchGoalInfo(with: id)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func fillGoal(_ goal: Goal) {
        self.goal = goal
    }
    
    // MARK: – Обновление UI по ответу
    func displayAIAnswer(_ answer: String) {
        DispatchQueue.main.async {
            self.generateButton.isEnabled = true
            self.generateButton.alpha = 1.0
            self.shimmerView.stopAnimating()
            UIView.animate(withDuration: 1.0) {
                self.shimmerView.isHidden = true
                self.thinkingLabel.isHidden = true

                self.responseLabel.text = answer
                self.responseLabel.isHidden = false
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [closeButton, aiHeaderLabel, aiView, headerScreen, generateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        aiView.addSubview(shimmerView)
        aiView.addSubview(thinkingLabel)
        aiView.addSubview(scrollView)
        
        scrollView.addSubview(responseLabel)
        
        setupConstraints()
    }
    
    private func configureHeader() {
        let labelText: String = "Advice for \(goal?.title ?? "None")"
        let attributedTextLabel = NSMutableAttributedString(string: labelText)

        let prefix = "Advice for "
        let prefixLength = prefix.count

        let fullLength = (labelText as NSString).length

        let restRange = NSRange(location: prefixLength,
                                length: fullLength - prefixLength)
        
        attributedTextLabel.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: prefixLength))
        attributedTextLabel.addAttribute(.foregroundColor, value: goal?.getColour().adjusted(saturationOffset: 0.20, brightnessOffset: -0.15) ?? .black, range: restRange)
        headerScreen.attributedText = attributedTextLabel
    }
    
    private func setupConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, -10)
        closeButton.pinLeft(to: view, 16)
        closeButton.setWidth(70)
        closeButton.setHeight(70)
        
        aiHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        aiHeaderLabel.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        aiHeaderLabel.pinCenterY(to: closeButton.centerYAnchor)
        
        headerScreen.pinTop(to: aiHeaderLabel.bottomAnchor, 24)
        headerScreen.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 16)
        headerScreen.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 16)
        
        generateButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 32)
        generateButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        generateButton.setHeight(50)
        generateButton.setWidth(352)
        
        aiView.pinTop(to: headerScreen.bottomAnchor, 24)
        aiView.pinLeft(to: view.leadingAnchor, 16)
        aiView.pinRight(to: view.trailingAnchor, 16)
        aiView.pinBottom(to: generateButton.topAnchor, 24)
        
        shimmerView.pinTop(to: aiView.topAnchor)
        shimmerView.pinLeft(to: aiView.leadingAnchor)
        shimmerView.pinRight(to: aiView.trailingAnchor)
        shimmerView.setHeight(40)
        
        thinkingLabel.pinCenterX(to: shimmerView.centerXAnchor)
        thinkingLabel.pinCenterY(to: shimmerView.centerYAnchor)
        
        scrollView.pinTop(to: shimmerView.bottomAnchor, 8)
        scrollView.pinLeft(to: aiView.leadingAnchor)
        scrollView.pinRight(to: aiView.trailingAnchor)
        scrollView.pinBottom(to: aiView.bottomAnchor)
        
        responseLabel.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        responseLabel.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        responseLabel.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        responseLabel.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        
        responseLabel.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func generateButtonTapped() {
        guard let id = goalId else { return }
        
        generateButton.isEnabled = false
        generateButton.alpha = 0.5

        UIView.animate(withDuration: 0.2) {
            // показываем thinking + шимер
            self.shimmerView.isHidden = false
            self.thinkingLabel.isHidden = false
        }
        shimmerView.startAnimating()
        responseLabel.isHidden = true

        interactor?.fetchAIAnswer(with: id)
    }
}
