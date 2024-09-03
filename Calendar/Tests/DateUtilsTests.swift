import Foundation
import XCTest
import Calendar

final class DateUtilsTests: XCTestCase {
    func test_september_has_30_days_a_month() {
        let septemberCpnts = DateComponents(month: 9)
        let september = Calendar.current.date(from: septemberCpnts)!
        
        XCTAssertEqual(DateUtils.daysInMonth(september), 30)
    }
    
    func test_september_2024_starts_on_sunday() {
        let septemberCpnts = DateComponents(year: 2024, month: 9)
        let september = Calendar.current.date(from: septemberCpnts)!
        
        let sundayBased = DateUtils.firstWeekDayOfMonth(september)
        XCTAssertEqual(sundayBased, 1)
        
        let mondayBased = DateUtils.weekDayFromMonday(sundayBased)
        XCTAssertEqual(mondayBased, 7)
    }
    
    func test_october_2024_starts_on_tuesday() {
        let octoberCpnts = DateComponents(year: 2024, month: 10)
        let october = Calendar.current.date(from: octoberCpnts)!
        
        let sundayBased = DateUtils.firstWeekDayOfMonth(october)
        XCTAssertEqual(sundayBased, 3)
        
        let mondayBased = DateUtils.weekDayFromMonday(sundayBased)
        XCTAssertEqual(mondayBased, 2)
    }
}
