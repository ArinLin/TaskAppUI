//
//  CustomDatePicker.swift
//  Task App UI With Custom Date Picker
//
//  Created by Arina on 06.05.2023.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currenDate: Date
    
    // Обновление месяца по клику на кнопку со стрелкой
    @State var currentMonth: Int = 0
    
    var body: some View {
        
        VStack (spacing: 35) {
            // Дни
            let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            HStack (spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraData()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraData()[1])
                        .font(.title.bold())
                }
                Spacer(minLength: 0)
                
                Button {
                    withAnimation{currentMonth -= 1}
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation{currentMonth += 1}
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            // day View
            
            HStack (spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            // Даты
            // lazy grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    cardView(value: value)
                        .background(
                        Capsule()
                            .fill(Color("PalePink"))
                            .padding(.horizontal, 8)
                            .opacity(isSameDay(date1: value.date, date2: currenDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currenDate = value.date
                        }
                }
            }
            VStack (spacing: 15) {
                Text("Tasks")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: currenDate)
                }) {
                    ForEach(task.task){task in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(task.time
                                .addingTimeInterval(CGFloat
                                .random(in: 0...5000)),style:
                                .time)
                            Text(task.title)
                                .font(.title2.bold())
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Color("PalePink")
                                .opacity(0.5)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("There are no tasks")
                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { newValue in
            // Обновление месяца
            currenDate = getCurrentMonth()
        }
        .padding()
    }
    
    @ViewBuilder func cardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: {task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currenDate) ? .white: .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Circle()
                        .fill(isSameDay(date1: task.taskDate, date2: currenDate) ? .white: Color("PalePink"))
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currenDate) ? .white: .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical)
        .frame(height: 60, alignment: .top)
    }
    // проверяем даты
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    // Вычисляем год и месяц
    func extraData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currenDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        // достаем текущую дату
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        // достаем текущую дату
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
            // получаем день
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        // добавляем смещение, чтобы получить точный день недели
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


// Расширение для получения текущей даты месяца
extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        // получаем начальную дату
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        // получение даты
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
