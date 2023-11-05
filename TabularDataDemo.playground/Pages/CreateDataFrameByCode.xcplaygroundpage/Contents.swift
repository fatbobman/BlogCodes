import Foundation
import TabularData

let df1 = DataFrame(
    dictionaryLiteral:
    ("id", [1, 2, 3, 4, 5]),
    ("name", ["Tom", "Peter", "Jane", "John", "Mark"]),
    ("age", [34, 25, 26, 23, 56])
)

print(df1)

let id = ColumnID("id", Int.self)
let idColumn = Column(id, contents: [1, 2, 3, 4, 5])
let name = ColumnID("name", String.self)
let nameColumn = Column(name, contents: ["Tom", "Peter", "Jane", "John", "Mark"])
let age = ColumnID("age", Int.self)
let ageColumn = Column(age, contents: [34, 25, 26, 23, 56])

var df2 = DataFrame()
df2.append(column: idColumn)
df2.append(column: nameColumn)
df2.append(column: ageColumn)

print(df2)
