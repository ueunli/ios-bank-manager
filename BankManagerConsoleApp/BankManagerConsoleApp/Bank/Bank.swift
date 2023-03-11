//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/02/23.
//

import Foundation

struct Bank {
    private let despositClerks: [BankClerkProtocol]
    private let loanClerks : [BankClerkProtocol]
    private(set) var depositCustomers: Queue<String>
    private(set) var loanCustomers: Queue<String>
    private var numberOfCustomers: Int = 0 {
        didSet {
            lineUpCustomersInQueue(oldValue + 1 ... numberOfCustomers)
        }
    }
    private var timer: Timer
    private(set) var operationStatus: OperationStatus
    
    init(clerks: BankingService...) {
        self.depositCustomers = Queue<String>()
        self.loanCustomers = Queue<String>()
        self.despositClerks = Array(clerksPerType: clerks).filter { $0.service == .deposit()}
        self.loanClerks = Array(clerksPerType: clerks).filter { $0.service == .loan()}
        self.operationStatus = OperationStatus()
        self.timer = Timer()
    }
    
    
    private func lineUpCustomersInQueue(_ range: ClosedRange<Int>) {
        range.forEach {
            let customer = Customer(number: $0)
            switch customer.purpose! {
            case .deposit(_):
                depositCustomers.enqueue(customer)
            case .loan(_):
                loanCustomers.enqueue(customer)
            }
            NotificationCenter.default.post(name: Notification.Name("AddCustomerdInWaitingStackView"), object: nil, userInfo: ["고객": customer])
        }
    }
    
    func handleDepositCustomers() {
        var depositServiceManager = DepositServiceAsynchronizer(queue: depositCustomers)
        depositServiceManager.work(by: despositClerks)
    }
    
    func handleLoanCustomers() {
        var loanServiceManager = LoanServiceAsychronizer(queue: loanCustomers)
        loanServiceManager.work(by: loanClerks)
    }
    
    mutating func close() {
        operationStatus.close()
    }
    
    private func printClosingMessage(with totalSpentTime: Double) {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(numberOfCustomers)명이며, 총 업무시간은 \(totalSpentTime)초입니다.")
    }
    
    mutating func addMoreCustomers(_ count: Int = 10) {
        numberOfCustomers += count
    }
}
