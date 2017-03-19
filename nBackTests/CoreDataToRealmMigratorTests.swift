import Quick
import Nimble
@testable import nBack

class CoreDataToRealmMigratorSpec: QuickSpec {
    override func spec() {
        
        var gen: CoreDataDataGenerator!
        
        beforeEach {
            gen = CoreDataDataGenerator()
        }
        
        describe("fetchAllCoreDataGameResults") {
            it("should return the right amount of game results") {
                gen.generateFakeData(count: 10)
                let results = CoreDataToRealmMigrator.fetchAllCoreDataGameResults()
                expect(results.count).to(beGreaterThan(5))
            }
            afterEach {
                gen.deleteAllData()
            }
        }
    }
}

