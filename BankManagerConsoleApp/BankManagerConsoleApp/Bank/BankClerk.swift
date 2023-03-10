//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/23.
//

import Foundation

protocol BankClerkProtocol {
    var isWorking: Bool { get set }
    //var queue: DispatchQueue { get }
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
    var isWorking = false
    //var queue = DispatchQueue.global()
    let service: BankingService = .deposit()
}

struct BankClerkForLoan: BankClerkProtocol {
    var isWorking = false
    //var queue = DispatchQueue.global()
    let service: BankingService = .loan()
}
