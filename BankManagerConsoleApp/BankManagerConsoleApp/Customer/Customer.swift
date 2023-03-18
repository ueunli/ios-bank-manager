//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/03/02.
//

import Foundation

final class Customer: Node<String>, Equatable {
    let purpose: BankingService?
    
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        return lhs.data == rhs.data
    }
    
    init(number: Int) {
        let bankServices = BankingService.allCases
        self.purpose = bankServices.randomElement()
        let data = "\(number) - \(self.purpose?.title ?? "")"
        super.init(data)
    }
}
