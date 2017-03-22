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
        
        describe("convertTypeResult(_ typeResult:)") {
            it("should convert a CD type to a Realm type") {
                let cd = gen.generateFakeTypeResult(.colors)
                
                let r = CoreDataToRealmMigrator.convertTypeResult(cd)
                
                self.compareTypeResults(cd: cd, r: r)
                
            }
        }
        describe("convertTypeResults") {
            
            let cdGr = gen.generateFakeGameResultWithThreeTypeResults()
            let rs = CoreDataToRealmMigrator.convertTypeResults(for: cdGr)
            
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
            let cd = gen.generateFakeGameResultWithThreeTypeResults()
            let r = CoreDataToRealmMigrator.convertGameResult(cd)
            
            it("should return a matching result") {
                
                expect(cd.date).to(equal(r.date))
                
                expect(Int(cd.columns)).to(equal(r.columns))
                expect(Int(cd.rows)).to(equal(r.rows))
                
                expect(Int(cd.level)).to(equal(r.level))
                expect(Int(cd.numberOfTurns)).to(equal(r.numberOfTurns))
                expect(cd.secondsBetweenTurns).to(equal(r.secondsBetweenTurns))
                expect(cd.squareHighlightTime).to(equal(r.squareHighlightTime))
                
                expect(cd.types.count).to(equal(r.types.count))
                
                expect(cd.percentage).to(equal(r.percentage))
                expect(cd.totalCorrect).to(equal(r.totalCorrect))
                expect(cd.totalIncorrect).to(equal(r.totalIncorrect))
            }
           
            
            
        }
        
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


