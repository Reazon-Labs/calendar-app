import SwiftUI

let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

struct CalendarView: View {
    @Binding var currentDate: Date
    @Binding var presentation: CalendarViewPresentation
    @State private var currentMonth: Int = 0
    
    var body: some View {
        switch presentation {
        case .month:
            MonthView(currentDate: $currentDate)
        case .week:
            WeekView()
        }
    }
}

struct WeekComponent: View {
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
               HoursColumn()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                    ForEach(0..<7) { i in
                        ZStack(alignment: .top) {
                            VStack(spacing: 0) {
                                ForEach(0..<24) { hour in
                                    HourSlot(hour: hour)
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
                            
                            if i == 0 {
                                Event(hour: 2)
                            }
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
    
    func Event(hour: Int) -> some View {
        Rectangle()
            .foregroundStyle(Color.cyan)
            .frame(height: 80 - 2 * 1)
            .cornerRadius(6)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            .padding(1)
            .offset(y: CGFloat(hour * 80))
            .gesture(
                DragGesture()
                    
                    .onEnded { value in
                    }
            )
    }
    
    func HoursColumn() -> some View {
        VStack(spacing: 0) {
            ForEach(1..<25) { hour in
                let hourStr = hour != 24 ? "\(hour):00" : "0:00"
                
                Text(hourStr)
                    .padding([.trailing], 5)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y:8)
            }
        }
        .frame(width: 60, alignment: .leading)
        .overlay(
            Rectangle()
                .frame(height: 1, alignment: .top)
                .foregroundColor(.gray),
            alignment: .top
        )
    }
    
    func HourSlot(hour: Int) -> some View {
        Rectangle()
            .foregroundStyle(Color.clear)
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

struct WeekView: View {
    var body: some View {
        VStack {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding([.leading], 60)
            
            WeekComponent()
        }
    }
}

struct MonthView: View {
    @Binding var currentDate: Date
    
    var body: some View {
        VStack {
            ControlHeader(currentDate: $currentDate)
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
    
    private func isToday(day: Int) -> Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        return components.year == todayComponents.year &&
        components.month == todayComponents.month &&
        day == todayComponents.day
    }
}

struct ControlHeader: View {
    @Binding var currentDate: Date
    
    var body: some View {
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
