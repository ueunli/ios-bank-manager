//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by J.E on 2023/02/23.
//

import Foundation

class Bank {
    private let clerks: [BankClerk]
    private(set) var customers: Queue<String>
    private var numberOfCustomers: Int = 0 {
        willSet {
            let isEmpty = customers.isEmpty()
            NotificationCenter.default.post(name: Notification.Name("AddCustomerdInWaitingStackView"), object: nil, userInfo: ["은행": isEmpty])
        }
        didSet {
            lineUpCustomersInQueue(oldValue + 1 ... numberOfCustomers)
            //if oldValue == 0 { handleAllCustomers() }
        }
    }
    private var timer: Timer
    
    init(clerks: BankingService...) {
        self.customers = Queue<String>()
        self.clerks = Array(clerksPerType: clerks)
        self.timer = Timer()
    }
    
    func open() {
        timer.start()
        lineUpCustomersInQueue(0...0)
        handleAllCustomers()
        timer.finish()
    }
    
    private func lineUpCustomersInQueue(_ range: ClosedRange<Int>) {
        range.forEach {
            let customer = Customer<BankingService>(number: $0)
            customers.enqueue(customer)
            NotificationCenter.default.post(name: Notification.Name("AddCustomerdInWaitingStackView"), object: nil, userInfo: ["고객": customer])
        }
    }
    
    func handleAllCustomers() {
        let serviceManager = ServiceAsynchronizer<BankingService, BankClerk>(queue: customers)
        serviceManager.work(by: clerks)
    }
    
    func close() {
        let totalSpentTime = timer.totalTime()
        printClosingMessage(with: totalSpentTime)
    }
    
    private func printClosingMessage(with totalSpentTime: Double) {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(numberOfCustomers)명이며, 총 업무시간은 \(totalSpentTime)초입니다.")
    }
    
    func addMoreCustomers(_ count: Int = 10) {
        let isEmpty = customers.isEmpty()
        numberOfCustomers += count
        if isEmpty { handleAllCustomers() }
    }
}
