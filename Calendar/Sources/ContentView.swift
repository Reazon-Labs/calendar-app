import SwiftUI

public struct ContentView: View {
    @State private var currentDate = Date()
    
    public var body: some View {
        CalendarView(currentDate: $currentDate)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
