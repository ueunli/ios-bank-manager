//
//  CustomerLabel.swift
//  BankManagerUIApp
//
//  Created by 김용재 on 2023/03/09.
//

import UIKit

class Customerlabel: UILabel {
    var customer: Customer
    
    init(customer: Customer) {
        self.customer = customer
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
