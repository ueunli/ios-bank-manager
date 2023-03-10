//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/23.
//

import Foundation

protocol BankClerkProtocol {
    static var queue: Queue<String> { get }
    var service: BankingService { get }
    func serve(_ customer: Customer)
}

extension BankClerkProtocol {
    func serve(_ customer: Customer) {
        guard let purposeOfVisit = customer.purpose else { return }
        Thread.sleep(forTimeInterval: purposeOfVisit.timeSpent)
    }
}

struct BankClerkForDeposit: BankClerkProtocol {
    static var queue = Queue<String>()
    let service: BankingService = .deposit()
}

struct BankClerkForLoan: BankClerkProtocol {
    static var queue = Queue<String>()
    let service: BankingService = .loan()
}
