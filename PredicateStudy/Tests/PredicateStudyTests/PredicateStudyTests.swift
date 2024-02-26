@testable import PredicateStudy
import XCTest

final class PredicateStudyTests: XCTestCase {
  func testContains() throws {
    let names = ["fat", "bob", "man"]
    let fat = People.fat
    let predicate = #Predicate<People> { people in
      names.contains(where: { $0.localizedLowercase == people.name.localizedLowercase })
    }
    XCTAssertTrue(try predicate.evaluate(fat))
  }

  func testSubscript() throws {
    let names = ["fat", "bob", "man"]
    let predicate = #Predicate<[String]> { $0.first == "fat" && $0[2] != "n" && $0.count == 3 }
    try XCTAssertTrue(predicate.evaluate(names))
  }

  func testMultiInput() throws {
    let dog = Dog.patton
    let fat = People.fat
    let predicate = #Predicate<Dog, People> { $0.age < 10 && $1.age < 10 }
    try XCTAssertFalse(predicate.evaluate(dog, fat))
  }

  func testNSObject() throws {
    class MyObject: NSObject {
      @objc var name: String
      init(name: String) {
        self.name = name
      }
    }
    let object = MyObject(name: "fat")
    let predicate = NSPredicate(format: "name = %@", "fat")
    XCTAssertTrue(predicate.evaluate(with: object)) // true

    let objs = [object]
    // filter object by predicate
    let filteredObjs = (objs as NSArray).filtered(using: predicate) as! [MyObject]
    XCTAssertEqual(filteredObjs.count, 1)
  }

  func testSwiftPredicate() throws {
    class MyObject {
      var name:String
      init(name: String) {
        self.name = name
      }
    }

    let object = MyObject(name: "fat")
    let predicate = #Predicate<MyObject>{ object in
      object.name == "fat" && object.name.count >= 3
    }
    try XCTAssertTrue(predicate.evaluate(object)) // true

    let objs = [object]
    let filteredObjs = try objs.filter(predicate)
    XCTAssertEqual(filteredObjs.count, 1)
  }

  func testHexCompare() throws {
    let fat = People.fat
    let predicate = #Predicate<People> { $0.age == 0x13 }
    try XCTAssertTrue(predicate.evaluate(fat))
  }

  func testExpression() throws {
    let express = { (value1: PredicateExpressions.Variable<Int>, value2: PredicateExpressions.Variable<Int>) in
      PredicateExpressions.build_Comparison(
        lhs: value1,
        rhs: value2,
        op: .lessThan
      )
    }

    let predicate = Predicate {
      express($0, $1)
    }

    let n = 3
    let m = 4

    try XCTAssertTrue(predicate.evaluate(n, m)) // true
  }

  func testExpression1() throws {
    let predicate = #Predicate<Int, Int> { $0 < $1 }

    let n = 3
    let m = 4

    try XCTAssertTrue(predicate.evaluate(n, m)) // true
  }

  func testFunction() throws {
    struct Address {
      var city: String
    }
    struct People {
      var address: [Address]
    }

    let predicate = #Predicate<People> { people in
      people.address.contains { address in
        address.city == "Dalian"
      }
    }

    let p = People(address: [.init(city: "Dalian")])
    XCTAssertTrue(try predicate.evaluate(p))
  }
}
