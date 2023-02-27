//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 김용재 on 2023/02/23.
//

import Foundation

struct BankClerk {
    private let timeSpent: useconds_t = 100000
    
    func serve(customer: Node<String>) {
        print("\(customer.data) 예금 업무 시작")
        usleep(timeSpent)
        print("\(customer.data) 예금 업무 완료")
    }
}

struct BankClerkDaeChul {
    private let timeSpent: useconds_t = 0
    
    func serve(customer: Node<String>) {
        print("\(customer.data) 대출 업무 시작")
        usleep(timeSpent)
        print("\(customer.data) 대출 업무 완료")
    }
}
