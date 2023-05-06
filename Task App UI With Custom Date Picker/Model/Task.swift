//
//  Task.swift
//  Task App UI With Custom Date Picker
//
//  Created by Arina on 06.05.2023.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}


// для тестов
func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}

var tasks: [TaskMetaData] = [TaskMetaData(task: [Task(title: "Решить 2 задачи на leetcode"),
                                                Task(title: "Прочитать Грокаем алгоритмы"),
                                                Task(title: "Поработать над пет-проектом"),
                                                Task(title: "Посмотреть лайвкодинг интервью")],
                                          taskDate: getSampleDate(offset: 1)),
                             TaskMetaData(task: [Task(title: "Разобраться с многопоточностью")],
                                          taskDate: getSampleDate(offset: -3)),
                             TaskMetaData(task: [Task(title: "Решить 4 задачи на leetcode")],
                                          taskDate: getSampleDate(offset: -5)),
                             TaskMetaData(task: [Task(title: "Почитать документацию")],
                                          taskDate: getSampleDate(offset: -10))
                            ]


