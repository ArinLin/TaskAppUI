//
//  DateValue.swift
//  Task App UI With Custom Date Picker
//
//  Created by Arina on 06.05.2023.
//

import SwiftUI

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
