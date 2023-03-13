//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/03/02.
//

import Foundation

final class Customer<Service: ServiceType>: Node<String> {
    let number: Int
    let purpose: Service?
    
    init(number: Int) {
        self.number = number
        let services = Service.allCases
        self.purpose = services.randomElement()
        let data = "\(number) - \(self.purpose?.title ?? "")"
        super.init(data)
    }
}
