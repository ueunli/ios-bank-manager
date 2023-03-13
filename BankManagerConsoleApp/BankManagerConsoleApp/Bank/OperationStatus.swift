//
//  OperationStatus.swift
//  BankManagerUIApp
//
//  Created by 김용재 on 2023/03/11.
//

import Foundation

class OperationStatus {
    private(set) var isWorking: Bool
    
    init() {
        self.isWorking = true
    }
    
    func stop() {
        isWorking = false
    }
}
