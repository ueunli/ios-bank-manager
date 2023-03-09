//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/03/02.
//

import Foundation

final class Customer: Node<String>, Equatable {
    let number: Int
    let purpose: BankingService?
    
    init(number: Int) {
        self.number = number
        let bankServices = BankingService.allCases
        self.purpose = bankServices.randomElement()
        let data = "\(number) - \(self.purpose?.title ?? "")"
        super.init(data)
    }
    
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        lhs.data == rhs.data
    }
}
