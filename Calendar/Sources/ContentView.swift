import SwiftUI

public struct ContentView: View {
//    @State private var currentDate = Date()
//    @State private var presentation = CalendarViewPresentation.week

    public var body: some View {
//        CalendarView(currentDate: $currentDate, presentation: $presentation)
       CalendarWeekView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
