//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/23.
//

import Foundation

protocol BankClerkProtocol {
    var delegate: BankClerkDelegate? { get set }
    //var servingCustomer: Customer? { get set }
    var service: BankingService { get }
    func serve(_ customer: Customer)
}

extension BankClerkProtocol {
    func serve(_ customer: Customer) {
        guard let purposeOfVisit = customer.purpose else { return }
//        NotificationCenter.default.post(name: .started,
//                                        object: nil,
//                                        userInfo: ["고객정보": customer])
        delegate?.addLabel(of: customer)
        Thread.sleep(forTimeInterval: purposeOfVisit.timeSpent)
        delegate?.removeLabel(of: customer)
//        NotificationCenter.default.post(name: .finished,
//                                        object: nil,
//                                        userInfo: ["고객정보": customer])
    }
}

struct BankClerkForDeposit: BankClerkProtocol {
    var delegate: BankClerkDelegate?
    //var servingCustomer: Customer?
    let service: BankingService = .deposit()
}

struct BankClerkForLoan: BankClerkProtocol {
    var delegate: BankClerkDelegate?
    //var servingCustomer: Customer?
    let service: BankingService = .loan()
}
