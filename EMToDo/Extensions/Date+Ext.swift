//
//  Date+Ext.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 25.03.2025.
//

import Foundation

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: self)
    }
}
