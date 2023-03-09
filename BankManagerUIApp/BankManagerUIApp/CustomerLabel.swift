//
//  CustomerLabel.swift
//  BankManagerUIApp
//
//  Created by 김용재 on 2023/03/09.
//

import UIKit

class Customerlabel: UILabel {
    var customer: Customer?
    
    func setCustomer(_ customer: Customer) {
        self.customer = customer
    }
}
