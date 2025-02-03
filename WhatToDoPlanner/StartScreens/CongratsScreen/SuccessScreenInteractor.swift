import UIKit

protocol SuccessScreenBusinessLogic {
    func fetchSuccessMessage(request: SuccessScreen.SuccessMessage.Request)
}

class SuccessScreenInteractor: SuccessScreenBusinessLogic {
    var presenter: SuccessScreenPresentationLogic?
    
    func fetchSuccessMessage(request: SuccessScreen.SuccessMessage.Request) {
        let response = SuccessScreen.SuccessMessage.Response(message: "Congratulations!\nYou have successfully registered to WhatToDo.")
        presenter?.presentSuccessMessage(response: response)
    }
}


