//
//  CustomerLabel.swift
//  BankManagerUIApp
//
//  Created by 김용재 on 2023/03/09.
//

import UIKit

class Customerlabel: UILabel {
    var customer: Customer?
    override var text: String? {
        get { self.customer?.data }
        set {  }
    }
    override var textColor: UIColor! {
        get { self.customer?.purpose == .loan() ? .purple : .black }
        set {  }
    }
    
    func setCustomer(_ customer: Node<String>?) {
        self.customer = customer as? Customer
    }
}
