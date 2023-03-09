//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/03/02.
//

import Foundation

final class Customer: Node<String> {
    let purpose: BankingService?
    
    init(number: Int) {
        let bankServices = BankingService.allCases
        self.purpose = bankServices.randomElement()
        let data = "\(number) - \(self.purpose?.title ?? "")"
        super.init(data)
    }
}
