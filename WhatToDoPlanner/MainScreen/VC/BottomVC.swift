//
//  BottomVC.swift

import UIKit

protocol BottomSheetDelegate: AnyObject {
    func changeDetent(to detent: UISheetPresentationController.Detent.Identifier)
}

final class BottomSheetViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let textConstraints: Double = 20
        static let textColor: String = "000000"
        static let textSize: CGFloat = 20
        
        static let todayLabelText: String = "Todays tasks"
        static let todayAlpha: CGFloat = 0.8
        
        static let switcherSmallText: String = "See all"
        static let switcherLargreText: String = "Less"
        static let switcherAlpha: CGFloat = 0.34
    }
    
    var interactor: BottomBusinessLogic?
    weak var delegate: BottomSheetDelegate?
    
    private let todayLabel: UILabel = UILabel()
    private let presentSwictherButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F0F1F1")
        
        configureUI()
    }
    
    func updateSwitcherButton(title: String) {
        presentSwictherButton.setTitle(title, for: .normal)
    }
    
    private func configureUI() {
        configureTodayLabel()
        configureSwitcherButton()
    }
    
    private func configureTodayLabel() {
        view.addSubview(todayLabel)
        
        todayLabel.font = UIFont(name: Constants.fontName, size: Constants.textSize)
        todayLabel.text = Constants.todayLabelText
        todayLabel.textColor = UIColor(hex: Constants.textColor, alpha: Constants.todayAlpha)
        
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.pinTop(to: view, Constants.textConstraints)
        todayLabel.pinLeft(to: view, Constants.textConstraints)
    }
    
    private func configureSwitcherButton() {
        view.addSubview(presentSwictherButton)
        presentSwictherButton.setTitle(Constants.switcherSmallText, for: .normal)
        presentSwictherButton.setTitleColor(UIColor(hex: Constants.textColor, alpha: Constants.switcherAlpha), for: .normal)
        presentSwictherButton.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.textSize)
        
        presentSwictherButton.translatesAutoresizingMaskIntoConstraints = false
        presentSwictherButton.pinTop(to: view, Constants.textConstraints)
        presentSwictherButton.pinRight(to: view, Constants.textConstraints)
        
        presentSwictherButton.addTarget(self, action: #selector(switcherPressed), for: .touchUpInside)
    }
    
    @objc private func switcherPressed() {
        interactor?.switcherPressed()
    }
}


