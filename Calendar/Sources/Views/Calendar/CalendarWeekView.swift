import SwiftUI

struct CalendarWeekView: View {
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                HoursColumn()
                
                CalendarWeekGrid()
                    .frame(maxWidth: .infinity)
            }
            .padding(8)
        }
        .scrollIndicators(.never)
    }
}

struct CalendarWeekGrid: View {
    let task1 = TaskModel(
        title: "Event One",
        project: "Project",
        deadline: Calendar.current.date(
            from: DateComponents(
                hour: 4,
                minute: 15
            )
        ),
        estimatedTime: 90
    )
    
    let task2 = TaskModel(
        title: "Event two",
        project: "Project",
        deadline: Calendar.current.date(
            from: DateComponents(
                hour: 4,
                minute: 30
            )
        ),
        estimatedTime: 30
    )
    
    var columnsLayout: [GridItem] =
        Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    
    var body: some View {
        LazyVGrid(columns: columnsLayout, spacing: 0) {
            ForEach(0..<7) { day in
                ZStack(alignment: .top) {
                    CalendarWeek()
                    
                    if day == 3 {
                        CalendarEventView(task: task1, color: .cyan)
                        CalendarEventView(task: task2, color: .green)
                    }
                }
            }
        }
        .border(.black, width: 1)
    }
}

struct CalendarDay: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .border(.black, width: 0.5)
    }
}

struct CalendarEventView: View {
    
    var task: TaskModel
    var color: Color

    var body: some View {
        let components = Calendar.current.dateComponents([.hour, .minute], from: task.deadline!)
        let deadlineHour: Float = DateUtils.minutesToHours(components.minute!) + Float(components.hour!)
        let estimatedTimeHour: Float = DateUtils.minutesToHours(task.estimatedTime)

        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundStyle(color)
                .clipShape(
                    .rect(cornerRadius: 6)
                )
                .padding(1)
                .frame(height: CGFloat(estimatedTimeHour) * 50)
            .opacity(0.8)
            
            Text(task.title)
                .padding(4)
                .font(.footnote)
        }
        .offset(y: CGFloat(deadlineHour) * 50)
    }
}

struct CalendarWeek: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { hour in
                CalendarDay()
            }
        }
    }
}

struct HoursColumn: View {
    var body: some View {
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
        .frame(width: 45, alignment: .leading)
    }
}

#Preview {
    CalendarWeekView()
        .padding()
        .frame(width: 800, height: 600)
        .preferredColorScheme(.light)
}
