import Foundation
import TabularData

let url = Bundle.main.url(forResource: "atlcrime", withExtension: "csv")!
var readOption = CSVReadingOptions()
let dateStrategy = Date.ParseStrategy(format: "\(month: .twoDigits)/\(day: .twoDigits)/\(year: .defaultDigits)", timeZone: .init(identifier: "America/New_York")!)
readOption.addDateParseStrategy(dateStrategy)

let date = Date.now
let df = try! DataFrame(contentsOfCSVFile: url, types: ["id":.string], options: readOption)
let duration = Date.now.timeIntervalSince(date)
print(duration)
print(df)
