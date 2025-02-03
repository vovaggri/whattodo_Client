//
//  ConfirmViewController.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import UIKit

//protocol ConfirmViewControllerProtocol: AnyObject {
//    func displayConfirmationResult(_ viewModel: ConfirmScreen.ScreenMessage.ViewModel)
//}

final class ConfirmViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let firstTitleLabelText: String = "Confirm"
        static let secondTitleLabelText: String = "your e-mail"
        
        static let titleLabelSize: CGFloat = 40
        
        static let firstTitleLabelTop: Double = 154
        static let titleLabelLeft: Double = 21
        
        static let secondTitleLabelTop: Double = 60
    }
    
    let interactor: ConfirmInteractorProtocol
    let firstTitleLabel: UILabel = UILabel()
    let secondTitleLabel: UILabel = UILabel()
    
    init(interactor: ConfirmInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented (ConfirmViewController)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    private func configureTitleLabels() {
        view.addSubview(firstTitleLabel)
        view.addSubview(secondTitleLabel)
        
        firstTitleLabel.text = Constants.firstTitleLabelText
        firstTitleLabel.font = UIFont(name: Constants.fontName, size: Constants.titleLabelSize)
        firstTitleLabel.textColor = .black
        firstTitleLabel.pinTop(to: view, Constants.firstTitleLabelTop)
        firstTitleLabel.pinLeft(to: view, Constants.titleLabelLeft)
        
        secondTitleLabel.text = Constants.secondTitleLabelText
        secondTitleLabel.font = UIFont(name: Constants.fontName, size: Constants.titleLabelSize)
        secondTitleLabel.textColor = .black
        secondTitleLabel.pinTop(to: firstTitleLabel, Constants.secondTitleLabelTop)
        secondTitleLabel.pinLeft(to: view, Constants.titleLabelLeft)
        
        
    }
}

//extension ConfirmViewController: ConfirmViewControllerProtocol {
//    func displayConfirmationResult(_ viewModel: ConfirmScreen.ScreenMessage.ViewModel) {
//        // Отображаем результат (например, сообщение об успешном подтверждении)
//        let alert = UIAlertController(title: "Результат", message: viewModel.message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
