import Foundation

extension Date {
    public var string: String {
        let calendar = Calendar.autoupdatingCurrent

        if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "%.2d:%.2d", hour, minute)
        } else {
            return DateFormatter.currentYear.string(from: self)
        }
    }
}

extension DateFormatter {
    static public var currentYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        return formatter
    }
}
