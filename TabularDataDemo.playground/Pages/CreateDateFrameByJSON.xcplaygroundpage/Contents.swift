import Foundation
import TabularData

let url = Bundle.main.url(forResource: "atlcrime", withExtension: "json")!
var readOption = JSONReadingOptions()
let strategy = Date.ParseStrategy(format: "\(month: .twoDigits)/\(day: .twoDigits)/\(year: .defaultDigits)", timeZone: .init(identifier: "America/New_York")!)
readOption.addDateParseStrategy(strategy)
let df = try! DataFrame(contentsOfJSONFile: url,options: readOption)
