//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/23.
//

import Foundation

protocol BankClerkProtocol: AnyObject {
    var isWorking: Bool { get set }
    var service: BankingService { get }
    func serve(_ customer: Customer)
    init(service: BankingService)
}

extension BankClerkProtocol {
    func serve(_ customer: Customer) {
        self.isWorking = true
        guard let purposeOfVisit = customer.purpose else { return }
        Thread.sleep(forTimeInterval: purposeOfVisit.timeSpent)
        self.isWorking = false
    }
}

class BankClerk: BankClerkProtocol {
    typealias Service = BankingService
    var isWorking = Bool()  //MARK: 기본값 false
    var service: BankingService

    required init(service: BankingService) {
        self.service = service
    }
}
