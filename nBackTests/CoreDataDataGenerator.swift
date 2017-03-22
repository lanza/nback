import Foundation
import CoreData
import nBack


class CoreDataDataGenerator {
    let context = TestableCoreData().context
    func generateFakeData(count: Int) {
        for _ in 1...count {
            _ = generateFakeGameResultWithThreeTypeResults()
        }
    }
    
    func fetchAllGameResults() -> [GameResult] {
        return GameResult.fetch(in: context)
    }
    
    func fetchAllTypeResults() -> [TypeResult] {
        return TypeResult.fetch(in: context)
    }
    
    func deleteGameResults() {
        let gameResults = fetchAllGameResults()
        gameResults.forEach { context.delete($0) }
        do {
            try context.save()
        } catch {
            print(error)
            fatalError()
        }
    }
    
    func deleteTypeResults() {
        let typeResults = fetchAllTypeResults()
        typeResults.forEach { context.delete($0) }
        do {
            try context.save()
        } catch {
            print(error)
            fatalError()
        }
    }
    
    func deleteAllData() {
        deleteTypeResults()
        deleteGameResults()
    }
    
    func deleteContainer() {
        let cd = NSPersistentContainer(name: "nBack")
        cd.loadPersistentStores { (desc, error) in
            try! FileManager.default.removeItem(at: desc.url!)
        }
    }
    
    func generateFakeGameResultWithThreeTypeResults() -> GameResult {
        var result: GameResult! = nil
        context.performAndWait {
            result = GameResult(context: self.context)
            result.initialize(with: Date(timeInterval: Double(Utilities.random(max: 100000000) - 50000000), since: Date()))
            for type in [.squares, .numbers, .colors] as [NBackType] {
                result.types.insert(self.generateFakeTypeResult(type))
            }
            self.context.save { Utilities.show(error: $0) }
        }
        return result
    }
    
    func generateFakeTypeResult(_ type: NBackType) -> TypeResult {
        let result = TypeResult(context: context)
        
        result.type = type
        
        result.falseFalse = Int16(Utilities.random(max: 10))
        result.falseTrue = Int16(Utilities.random(max: 10))
        result.trueFalse = Int16(Utilities.random(max: 10))
        result.trueTrue = Int16(Utilities.random(max: 10))
        
        result.correct = result.falseFalse + result.trueTrue
        result.incorrect = result.falseTrue + result.trueFalse
        result.matches = result.trueTrue + result.falseTrue
        
        return result
    }
}
