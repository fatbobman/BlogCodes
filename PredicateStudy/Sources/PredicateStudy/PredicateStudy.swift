// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftData

public struct People {
  public var name: String
  public var age: Int

  public init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
  
  public static let fat = People(name: "Fat", age: 19)
}

public struct Dog {
  public var name: String
  public var age: Int
  public init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
  
  public static let patton = Dog(name: "Patton", age: 1)
}

public class NSDog: NSObject {
  public var name: String
  public var age: Int
  public init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
}

@Model
public final class Note {
  public var name: String?
  @Relationship(deleteRule: .cascade)
  public var item: [Item]?
  public init(name: String? = nil) {
    self.name = name
    item = item
  }
}

@Model
public final class Item {
  public var name: String?
  public var content: String?
  @Relationship(deleteRule: .nullify)
  public var note: Note?
  public init(name: String? = nil, content: String? = nil) {
    self.name = name
    self.content = content
  }
}
