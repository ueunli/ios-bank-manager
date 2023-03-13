//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/23.
//

import Foundation

//protocol BankClerkProtocol: ServerType {
//    var isWorking: Bool { get set }
//    var service: BankingService { get }
//    func serve(_ customer: Customer<BankingService>)
//    init(service: BankingService)
//}

extension ServerType where Service == BankingService {
    func serve(_ customer: Customer<Service>) {
        self.isWorking = true
        guard let purposeOfVisit = customer.purpose else { return }
        Thread.sleep(forTimeInterval: purposeOfVisit.timeSpent)
        self.isWorking = false
    }
}

class BankClerk: ServerType {
    typealias Service = BankingService
    var isWorking = Bool()  //MARK: 기본값 false
    var service: BankingService

    required init(service: BankingService) {
        self.service = service
    }
}

//class BankClerk: BankClerkProtocol {
//    var isWorking = Bool()  //MARK: 기본값 false
//    var service: BankingService
//
//    required init(service: BankingService) {
//        self.service = service
//    }
//}

//class BankClerk: ServerType {
//    var isWorking = Bool()
//    var service: BankingService
//
//    init(service: BankingService) {
//        self.service = service
//    }
//
//    func serve(_ customer: Customer<BankingService>) {
//        self.isWorking = true
//        guard let purposeOfVisit = customer.purpose else { return }
//        Thread.sleep(forTimeInterval: purposeOfVisit.timeSpent)
//        self.isWorking = false
//    }
//}
