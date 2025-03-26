//
//  Int+Ext.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 26.03.2025.
//

extension Int {
    func tasksCountString() -> String {
        switch self % 10 {
        case 1 where self % 100 != 11:
            return "\(self) задача"
        case 2...4 where !(self % 100 >= 12 && self % 100 <= 14):
            return "\(self) задачи"
        default:
            return "\(self) задач"
        }
    }
}
