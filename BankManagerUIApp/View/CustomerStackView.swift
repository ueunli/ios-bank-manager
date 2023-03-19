//
//  CustomerStackView.swift
//  BankManagerUIApp
//
//  Created by J.E on 2023/03/19.
//

import UIKit

class CustomerStackView: UIStackView {
    private static var customerLabels: [Int: Customerlabel] = [:]
//    private var customerLabels: [Customerlabel] = []
//    override var arrangedSubviews: [UIView] {
//        get { self.arrangedSubviews }
//        set { self.customerLabels = newValue as! [Customerlabel] }
//    }
    
    func beObserver(about type: Notification.Name) {
        //DispatchQueue.main.async {
        NotificationCenter.default.addObserver(forName: type, object: nil, queue: .main) {
                guard let customer = $0.userInfo?["고객"] as? Customer else { return }
                switch type {
                case .add:
                    let label = Customerlabel(customer: customer)
                    self.addArrangedSubview(label)
                    print(customer.data, "add됨")
                case .serve:
                    guard let label = Self.customerLabels[customer.number] else { return }
                    label.removeFromSuperview()
                    self.addArrangedSubview(label)
                    print(customer.data, "serve됨")
                case .remove:
                    guard let label = Self.customerLabels[customer.number] else { return }
                    label.removeFromSuperview()
                    print(customer.data, "remove됨")
                default: break
                }
            }
        }
    //}
}
