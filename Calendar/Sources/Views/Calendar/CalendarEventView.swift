import SwiftUI

struct CalendarEventView: View {
    var task: TaskModel
    var color: Color

    var body: some View {
//        let deadlineCpnts = Calendar.current.dateComponents([.hour, .minute], from: task.deadline!)
//        let deadlineHours: Float = DateUtils.minutesToHours(deadlineCpnts.minute!) + Float(deadlineCpnts.hour!)
//        let estimatedTimeHours: Float = DateUtils.minutesToHours(task.estimatedTime)

        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundStyle(color)
                .opacity(0.4)
                .clipShape(
                    .rect(cornerRadius: 4)
                )
                .padding(1)
                //.frame(height: CGFloat(estimatedTimeHours) * 50)
            
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
            let _ = NSColor(red: 0.329, green: 0.745, blue: 0.941, alpha: 1).getHue(&hue, saturation: &saturation,brightness: &brightness, alpha: nil)
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.callout)
                    .fontWeight(.medium)
                    .truncationMode(.tail)
                    .lineLimit(3)
                    .foregroundStyle(Color(hue: hue, saturation: saturation, brightness: brightness - 0.15))

                if let doDateInterval = task.doDateInterval {
                    let start = doDateInterval.start.formatted(date: .omitted, time: .shortened)
                    let end = doDateInterval.end.formatted(date: .omitted, time: .shortened)
                    let duration = Duration.seconds(doDateInterval.duration).formatted(Duration.TimeFormatStyle(pattern: .hourMinute))
                    HStack {
                        Image(systemName: "clock")
                        
                        Text("\(start) - \(end) (\(duration))")
                    }
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundStyle(Color(hue: hue, saturation: saturation, brightness: brightness - 0.15))
                }
                
                if let deadline = task.deadline {
                    HStack {
                        Image(systemName: "flag")
                        Text("\(deadline.formatted())")
                    }
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundStyle(Color(hue: hue, saturation: saturation, brightness: brightness - 0.15))
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
        }
        

        //.offset(y: CGFloat(deadlineHours) * 50)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CalendarEventView(
            task: TaskModel(
                title: "A veeeeeeeeeeery long named task",
                project: "Test",
                deadline: Calendar.current.date(from: DateComponents(
                    year: 2024,
                    month: 9,
                    day: 15,
                    hour: 17,
                    minute: 20
                )),
                estimatedTime: 90,
                doDateInterval: DateInterval(
                    start: Calendar.current.date(from: DateComponents(
                        year: 2024,
                        month: 9,
                        day: 15,
                        hour: 12,
                        minute: 00
                    )
                )!, end:
                        Calendar.current.date(from: DateComponents(
                        year: 2024,
                        month: 9,
                        day: 15,
                        hour: 14,
                        minute: 00

                )
            )!)),
            color: .cyan
        )
        .frame(width: 150, height: 80)
        
        CalendarEventView(
            task: TaskModel(
                title: "A more regular task",
                project: "Test",
                estimatedTime: 90
            ),
            color: .green
        )
        .frame(width: 150, height: 80)
    }
    .padding()
}
