import Quick
import Nimble
import RealmSwift
import CoreData
@testable import nBack

class CoreDataToRealmMigratorSpec: QuickSpec {
    override func spec() {
        
        var gen: CoreDataDataGenerator!
        
        beforeEach {
            gen = CoreDataDataGenerator()
            Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "Test"
        }
        afterEach {
            gen.deleteAllData()
            gen.deleteRealmItems() 
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
        
        describe("convertTypeResult(_ typeResult:)") {
            it("should convert a CD type to a Realm type") {
                let cd = gen.generateFakeTypeResult(.colors)
                
                let r = CoreDataToRealmMigrator.convertTypeResult(cd)
                
                self.compareTypeResults(cd: cd, r: r)
            }
        }
        describe("convertTypeResults") {
            
            var cdGr: GameResult!
            var rs: [TypeResultRealm]!
            
            beforeEach {
                cdGr = gen.generateFakeGameResultWithThreeTypeResults()
                rs = CoreDataToRealmMigrator.convertTypeResults(for: cdGr)
            }
            
            it("yield the right amount of typeResults") {
                expect(rs.count).to(equal(cdGr.types.count))
            }
            it("should yield equivalent type results") {
                let cds = Array(cdGr.types)
                let rs = CoreDataToRealmMigrator.convertTypeResults(for: cdGr)
                
                let cdColors = cds.index(where: { typeResult in
                    return typeResult.type == NBackType.colors
                })!
                let cdNumbers = cds.index(where: { typeResult in
                    return typeResult.type == NBackType.numbers
                })!
                let cdSquares = cds.index(where: { typeResult in
                    return typeResult.type == NBackType.squares
                })!
                
                let rColors = rs.index(where: { typeResult in
                    return typeResult.nBackType == .colors
                })!
                let rNumbers = rs.index(where: { typeResult in
                    return typeResult.nBackType == .numbers
                })!
                let rSquares = rs.index(where: { typeResult in
                    return typeResult.nBackType == .squares
                })!
                
                self.compareTypeResults(cd: cds[cdColors], r: rs[rColors])
                self.compareTypeResults(cd: cds[cdSquares], r: rs[rSquares])
                self.compareTypeResults(cd: cds[cdNumbers], r: rs[rNumbers])
            }
        }
        
        describe("convertGameResult") {
            
            var cd: GameResult!
            var r: GameResultRealm!
            
            beforeEach {
                cd = gen.generateFakeGameResultWithThreeTypeResults()
                r = CoreDataToRealmMigrator.convertGameResult(cd)
            }
            
            it("should return a matching result") {
                
                expect(cd.date).to(equal(r.date))
                
                expect(Int(cd.columns)).to(equal(r.columns))
                expect(Int(cd.rows)).to(equal(r.rows))
                
                expect(Int(cd.level)).to(equal(r.level))
                expect(Int(cd.numberOfTurns)).to(equal(r.numberOfTurns))
                expect(cd.secondsBetweenTurns).to(equal(r.secondsBetweenTurns))
                expect(cd.squareHighlightTime).to(equal(r.squareHighlightTime))
            }
        }
        
        describe("linkTypeResults") {
            var grcd: GameResult!
            var grr: GameResultRealm!
            
            beforeEach {
                grcd = gen.generateFakeGameResultWithThreeTypeResults()
                grr = CoreDataToRealmMigrator.convertGameResult(grcd)
            }
            
            it("should connect the TypeResults from the GameResult to the GameResultRealm") {
                CoreDataToRealmMigrator.linkTypeResults(from: grcd, to: grr)
                
                var count = 0
                grr.types.forEach { _ in count += 1 }
                let cdCount = grcd.types.count
                
                expect(cdCount).to(equal(count))
            }
        }
        
        describe("getCoreDataFiles") {
            beforeEach {
                gen.generateFakeData(count: 10)
            }
            
            it("should return the three core data files") {
                let files = try! CoreDataToRealmMigrator.getCoreDataFiles()
                
                let last = files.map { $0.lastPathComponent }
                expect(last.count).to(equal(3))
                
                let extensions = files.map { $0.pathExtension }
                
                let containsSQLite = extensions.contains("sqlite")
                let containsSQLiteshm = extensions.contains("sqlite-shm")
                let containsSQLitewal = extensions.contains("sqlite-wal")
                
                expect(last.count).to(equal(3))
                expect(containsSQLite).to(equal(true))
                expect(containsSQLiteshm).to(equal(true))
                expect(containsSQLitewal).to(equal(true))
            }
        }
        
        
        describe("processGameResult") {
            var cd: GameResult!
            beforeEach {
                cd = gen.generateFakeGameResultWithThreeTypeResults()
            }
            
            it("should convert a CD type to a Realm type") {
                CoreDataToRealmMigrator.processGameResult(cd)
                
                let rs = try! Realm().objects(GameResultRealm.self)
                
                expect(rs.count).to(equal(1))
            }
        }
        
//        describe("convertData") {
//            beforeEach {
//                gen.generateFakeData(count: 10)
//            }
//            
//            it("should convert the 10 CD types to 10 R types and delete teh 10 CD") {
//                let cds = CoreDataToRealmMigrator.fetchAllCoreDataGameResults()
//                expect(cds.count).to(equal(10))
//                
//                CoreDataToRealmMigrator.convertData()
//                
//                let fm = FileManager.default
//                let url = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
//                let urls = try! fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
//                
//                expect(urls.count).to(equal(0))
//                
//                let realms = try! Realm().objects(GameResultRealm.self)
//                expect(realms.count).to(equal(10))
//            }
//        }
//        describe("deleteDatabase") {
//            beforeEach {
//                gen.generateFakeData(count: 10)
//            }
//            it("should remove the CoreData database") {
//                
//                CoreDataToRealmMigrator.deleteCoreDataDatabase()
//                
//                let fm = FileManager.default
//                let url = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
//                
//                let contents = try! fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
//                
//                expect(contents.count).to(equal(0))
//            }
//        }
    }
}

extension CoreDataToRealmMigratorSpec {
    func compareTypeResults(cd: TypeResult, r: TypeResultRealm) {
        expect(Int(cd.correct)).to(equal(r.correct))
        expect(Int(cd.incorrect)).to(equal(r.incorrect))
        expect(Int(cd.matches)).to(equal(r.matches))
        
        expect(Int(cd.falseFalse)).to(equal(r.falseFalse))
        expect(Int(cd.falseTrue)).to(equal(r.falseTrue))
        expect(Int(cd.trueFalse)).to(equal(r.trueFalse))
        expect(Int(cd.trueTrue)).to(equal(r.trueTrue))
        
        expect(cd.type).to(equal(r.nBackType))
    }
}


