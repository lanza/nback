import XCTest
import nBack

class nBackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
  
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class DataGeneratorCoreData {
  let context = CoreData.shared.context
  var date = Date(timeInterval: -1000, since: Date())
  func testEntries() {
    for _ in 1...10 {
      _ = generateFakeResult()
    }
  }
  
  func generateFakeResult() -> GameResult {
    var result: GameResult! = nil
    context.performAndWait {
      result = GameResult(context: self.context)
      result.initialize(with: Date(timeInterval: Double(Utilities.random(max: 100000000) - 50000000), since: Date()))
      for type in [.squares, .numbers, .colors] as [NBackType] {
        result.types.insert(self.generateFakeType(type))
      }
      try! self.context.save()
    }
    return result
  }
  
  func generateFakeType(_ type: NBackType) -> TypeResult {
    let result = TypeResult(context: context)
    
    result.correct = Int16(Utilities.random(max: 10))
    result.incorrect = Int16(Utilities.random(max: 10))
    result.matches = Int16(Utilities.random(max: 10))
    result.type = type
    
    result.falseFalse = Int16(Utilities.random(max: 10))
    result.falseTrue = Int16(Utilities.random(max: 10))
    result.trueFalse = Int16(Utilities.random(max: 10))
    result.trueTrue = Int16(Utilities.random(max: 10))
    
    return result
  }
}
