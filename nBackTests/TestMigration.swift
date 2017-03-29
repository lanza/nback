import Quick
import Nimble
import RealmSwift
@testable import nBack
import Reuse
import SwiftyUserDefaults

class TestMigration: QuickSpec {
    override func spec() {
        
        let gen = CoreDataDataGenerator()
        let defaults = UserDefaults.standard
        
        describe("initializer") {
            
            afterEach {
                defaults[.hasDoneSetup] = true
                defaults[.hasConvertedFromCoreData] = true
            }
            
            it("should have 0 cd and 10 r at the end") {
                gen.deleteAllData()
                gen.deleteRealmItems()
                
                defaults[.hasDoneSetup] = nil
                defaults[.hasConvertedFromCoreData] = nil
                
                gen.generateFakeData(count: 10)
                
                let cd = gen.fetchAllGameResults()
                expect(cd.count).to(equal(10))
                
                Initializer.run()
               
//                let r = try! Realm().objects(GameResultRealm.self)
                
                
                let fm = FileManager.default
                let url = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                let files = try! fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
               
                expect(files.count).to(equal(2))
                
            }
        }
    }
    
    
    
    
}
