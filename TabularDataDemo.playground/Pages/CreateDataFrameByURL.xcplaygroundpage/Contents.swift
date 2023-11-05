import Foundation
import TabularData

let url = URL(string:"https://media.githubusercontent.com/media/datablist/sample-csv-files/main/files/people/people-100.csv")!
let df = try! DataFrame(contentsOfCSVFile: url,rows: 0..<10)

print(df)
