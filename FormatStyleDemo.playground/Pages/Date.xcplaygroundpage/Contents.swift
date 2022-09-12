import Foundation

let now = Date.now
let yesterday = Calendar.current.date(byAdding: .day,value: -1, to: now)
let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)
let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: now)

now.formatted(.dateTime.dayOfYear(.threeDigits))


let format = Date.FormatStyle().day().month().year()
let d1 = now.formatted(format)
try? Date(d1, strategy: format)

let strategy = Date.ParseStrategy(format:"\(year:.padded(6))-\(month: .defaultDigits)-\(day: .defaultDigits)",timeZone: .current)
try? Date("2033-01-01",strategy: strategy)

let d = 35.1.rounded(.toNearestOrAwayFromZero)
Int(d).formatted(.percent)
