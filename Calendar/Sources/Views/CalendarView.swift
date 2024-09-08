import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    @Binding var presentation: CalendarViewPresentation
    @State private var currentMonth: Int = 0
    
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private let weekColumnsLayout: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
        switch presentation {
        case .month:
           monthView
        case .week:
            weekView
        }
    }
    
    var weekView: some View {
        VStack {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding([.leading], 80)
            
            ScrollView {
                HStack {
                    VStack(spacing: 0) {
                        ForEach(0..<24) { hour in
                             Text("\(hour):00")
                                .padding([.trailing], 5)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .offset(y:8)
                        }
                    }
                    .frame(width: 80, alignment: .leading)
                    
                    LazyVGrid(columns: weekColumnsLayout, spacing: 0) {
                        ForEach(0..<7) { i in
                            HStack {
                                VStack(spacing: 0) {
                                    ForEach(0..<24) { hour in
                                        Text("")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 80)
                                            .overlay(
                                                Rectangle()
                                                    .frame(height: hour == 0 ? 1 : 0.5, alignment: .top)
                                                    .foregroundColor(.gray),
                                                alignment: .top
                                            )
                                            .overlay(
                                                Rectangle()
                                                    .frame(height: hour == 23 ? 1 : 0.5, alignment: .bottom)
                                                    .foregroundColor(.gray),
                                                alignment: .bottom
                                            )
                                    }
                                }
                                .overlay(
                                    Rectangle()
                                        .frame(width: i == 0 ? 1 : 0.5, alignment: .leading)
                                        .foregroundColor(.gray),
                                    alignment: .leading
                                )
                                 .overlay(
                                    Rectangle()
                                        .frame(width: i == 6 ? 1 : 0.5, alignment: .trailing)
                                        .foregroundColor(.gray),
                                    alignment: .trailing
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding([.bottom], 8)
            }
            .scrollIndicators(.never)
        }
    }
   
    var monthView: some View {
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
            let firstDayMondayBased = DateUtils.weekDayFromMonday(firstDay) - 1
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<firstDayMondayBased, id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                ForEach(1...daysInMonth, id: \.self) { day in
                    Text("\(day)")
                        .id(firstDayMondayBased + day)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(isToday(day: day) ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                }
            }
        }
    }
    
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

public enum CalendarViewPresentation {
    case month
    case week
}


struct CalendarViewPreview: View {
    @State private var currentDay: Date
    @State private var presentation: CalendarViewPresentation
    var body: some View {
        CalendarView(currentDate: $currentDay, presentation: $presentation)
    }
    
    init(currentDay: Date = Date(), presentation: CalendarViewPresentation = CalendarViewPresentation.month) {
        self.currentDay = currentDay
        self.presentation = presentation
    }
}


#Preview("Month") {
    CalendarViewPreview()
        .padding()
        .frame(width: 800)
}

#Preview("Week") {
    CalendarViewPreview(presentation: .week)
        .padding()
        .frame(width: 800, height: 600)
}
