//
//  Nofication.swift
//  BankManagerUIApp
//
//  Created by J.E on 2023/03/18.
//

import UIKit

extension Notification.Name {
    static let add = Notification.Name("newCustomer")
    static let serve = Notification.Name("CustomerInProcess")
    static let remove = Notification.Name("finishedService")
}

extension NotificationCenter {
    func post(_ type: Notification.Name, about customer: Customer) {
        post(name: type, object: nil, userInfo: ["고객": customer])
    }
    
    func addObserver(observedBy observer: UIStackView, about type: Notification.Name, toPerform selector: Selector) {
        addObserver(observer, selector: selector, name: type, object: nil)
    }
    func beObserver(_ self: ViewController, about type: Notification.Name, toPerform selector: Selector) {
        addObserver(self, selector: selector, name: type, object: nil)
    }
}


//private func addObserver() {
//    NotificationCenter.default.addObserver(forName: .add,
//                                           object: nil,
//                                           queue: .main,
//                                           using: waitingCustomersStackView.addArrangedSubview)
//    NotificationCenter.default.addObserver(forName: .serve,
//                                           object: nil,
//                                           queue: .main,
//                                           using: waitingCustomersStackView.moveArrangedSubview)
//    NotificationCenter.default.addObserver(forName: .remove,
//                                           object: nil,
//                                           queue: .main,
//                                           using: waitingCustomersStackView.removeArrangedSubview)
//}
