import Quick
import Nimble
@testable import nBack

class CoreDataToRealmMigratorSpec: QuickSpec {
    override func spec() {
        beforeSuite { 
        }
        describe("fetchAllCoreDataGameResults should turn an array of GameResults ") { 
            let results = CoreDataToRealmMigrator.fetchAllCoreDataResults()
            expect(results.count).to(beGreaterThan(5))
        }
    }
}

