import Foundation

typealias UnixTimestamp = Int64

extension UnixTimestamp {
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }
}

extension Date {
    func isEqualDay(to date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}

extension Date {
    var formatDateToDayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = .current
        return formatter.string(from: self)
    }
}
