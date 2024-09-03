import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    @State private var currentMonth: Int = 0
    
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var controlHeader: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            
            Text(DateUtils.monthYearFormatter.string(from: currentDate))
                .font(.headline)
            
            Spacer()
            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }
    
    var body: some View {
        VStack {
            controlHeader
                .padding()
            
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let daysInMonth = DateUtils.daysInMonth(currentDate)
            let firstDay = DateUtils.firstWeekDayOfMonth(currentDate)
            let mondayBased = DateUtils.weekDayFromMonday(firstDay) - 1
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<mondayBased, id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                ForEach(1...daysInMonth, id: \.self) { day in
                    Text("\(day)")
                        .id(mondayBased + day)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(isToday(day: day) ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }
    
    private func isToday(day: Int) -> Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        return components.year == todayComponents.year &&
        components.month == todayComponents.month &&
        day == todayComponents.day
    }
}


struct CalendarViewPreview: View {
    @State private var currentDay: Date
    var body: some View {
       CalendarView(currentDate: $currentDay)
    }
    
    init(currentDay: Date = Date()) {
        self.currentDay = currentDay
    }
}


#Preview {
    CalendarViewPreview()
        .padding()
        .frame(width: 800)
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
        ForEach(0...5, id: \.self) { i in
            Text("\(i)")
        }
        ForEach(6...12, id: \.self) { i in
            Text("\(i)")
        }
    }
    .padding()
    .frame(width: 700)
}
