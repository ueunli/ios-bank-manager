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
    private var depositServiceManager: DepositServiceAsynchronizer
    private var loanServiceManager: LoanServiceAsychronizer
    private var numberOfCustomers: Int = 0 {
        willSet {
            guard depositCustomers.isEmpty() && loanCustomers.isEmpty() else { return }
            self.numberOfCustomers = 0
        }
        didSet {
            lineUpCustomersInQueue(oldValue + 1 ... numberOfCustomers)
        }
    }
    private var timer: Timer
    
    init(clerks: BankingService...) {
        self.depositCustomers = Queue<String>()
        self.loanCustomers = Queue<String>()
        self.despositClerks = Array(clerksPerType: clerks).filter { $0.service == .deposit()}
        self.loanClerks = Array(clerksPerType: clerks).filter { $0.service == .loan()}
        self.depositServiceManager = DepositServiceAsynchronizer(queue: depositCustomers)
        self.loanServiceManager = LoanServiceAsychronizer(queue: loanCustomers)
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
    
    mutating func handleDepositCustomers() {
        depositServiceManager.work(by: despositClerks)
    }
    
    mutating func handleLoanCustomers() {
        loanServiceManager.work(by: loanClerks)
    }
    
    mutating func close() {
        depositCustomers.clear()
        loanCustomers.clear()
    }
    
    mutating func addMoreCustomers(_ count: Int = 10) {
        numberOfCustomers += count
    }
}
