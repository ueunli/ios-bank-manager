//
//  CustomerLabel.swift
//  BankManagerUIApp
//
//  Created by 김용재 on 2023/03/09.
//

import UIKit

class Customerlabel: UILabel {
    var customer: Customer<ServiceType>
    
    init(customer: Customer<ServiceType>) {
        self.customer = customer
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.text = self.customer.data
        guard self.customer.purpose == .loan() else { return }
        self.textColor = .purple
    }
}
