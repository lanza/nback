import Quick
import Nimble
@testable import nBack

class CoreDataDataGeneratorSpec: QuickSpec {
    override func spec() {
        
        var gen: CoreDataDataGenerator!
        
        beforeEach {
            gen = CoreDataDataGenerator()
        }
        
        describe("generateFakeData") {
            it("should generate the right amount of fake data") {
                gen.generateFakeData(count: 10)
                let results = gen.fetchAllGameResults()
                let typeResults = gen.fetchAllTypeResults()
                
                expect(results.count).to(equal(10))
                expect(typeResults.count).to(equal(30))
            }
            afterEach {
                gen.deleteAllData()
            }
        }
        
        describe("generateFakeGameResultWithThreeTypeResults") {
            
            var result: GameResult?
            
            beforeEach {
                result = gen.generateFakeGameResultWithThreeTypeResults()
            }
            
            it("should return a GameResult in CoreData") {
                let fetchedResults = gen.fetchAllGameResults()
                
                expect(fetchedResults).to(contain(result!))
            }
            
            it("should have three type results") {
                expect(result?.types.count).to(equal(3))
            }
            
            afterEach {
                gen.deleteAllData()
            }
        }
        describe("fetchAllGameResults") {
            beforeEach {
                _ = gen.generateFakeGameResultWithThreeTypeResults()
                _ = gen.generateFakeGameResultWithThreeTypeResults()
            }
            
            it("should have two results after creating two results") {
                let results = gen.fetchAllGameResults()
                
                expect(results.count).to(equal(2))
            }
            
            afterEach {
                gen.deleteAllData()
            }
        }
        describe("deleteAllData") {
            print("describe delete all data")
            it("should leave the database with 0 entries") {
                gen.deleteAllData()
                let results = gen.fetchAllGameResults()
                expect(results.count).to(equal(0))
            }
        }
        
    }

    
    
}

