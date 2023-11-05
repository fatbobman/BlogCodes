import Foundation
import TabularData

let url = Bundle.main.url(forResource: "atlcrime", withExtension: "csv")!
var readOption:CSVReadingOptions = {
    var option = CSVReadingOptions()
    let dateStrategy = Date.ParseStrategy(format: "\(month: .twoDigits)/\(day: .twoDigits)/\(year: .defaultDigits)", timeZone: .init(identifier: "America/New_York")!)
    option.addDateParseStrategy(dateStrategy)
    return option
}()

public let datasource = try! DataFrame(contentsOfCSVFile: url, rows: 0 ..< 100, options: readOption)
