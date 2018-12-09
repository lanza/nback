import RealmSwift

struct MonthInfo {
    let year: Int
    let month: Int
    var dayInfoDict: [Int:DayInfo] = [:]
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
}

struct DayInfo: Hashable {
    
    var identity: Int {
        return day
    }
    
    let day: Int
    var results: [GameResultRealm] = []
    init(day: Int) {
        self.day = day
    }
    
    static func ==(lhs: DayInfo, rhs: DayInfo) -> Bool {
        return lhs.day == rhs.day
    }
    
    var hashValue: Int { return day }
}


struct YearMonth:  Hashable {
    var identity: Int {
        return hashValue
    }
    let year: Int
    let month: Int
    var hashValue: Int {
        return (year.hashValue + month.hashValue)
    }
    static func ==(lhs: YearMonth, rhs: YearMonth) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month
    }
}

class Database {
    static var monthInfos: [MonthInfo] {
        do {
            let realm = try Realm()
            let results = realm.objects(GameResultRealm.self).sorted { $0.0.date > $0.1.date }
            let pairs = results.map { result -> (components: DateComponents, result: GameResultRealm) in
                let c = Calendar.current.dateComponents([.year,.month,.day], from: result.date)
                return (c,result)
            }
            
            var monthInfos: [YearMonth:MonthInfo] = [:]
            
            for pair in pairs {
                guard let day = pair.components.day, let month = pair.components.month, let year = pair.components.year else { fatalError() }
                
                let yearMonth = YearMonth(year: year, month: month)
                var monthInfo: MonthInfo
                
                if let mi = monthInfos[yearMonth] {
                    monthInfo = mi
                } else {
                    monthInfo = MonthInfo(year: year, month: month)
                }
                
                var dayInfo: DayInfo
                
                if let r = monthInfo.dayInfoDict[day] {
                    dayInfo = r
                } else {
                    dayInfo = DayInfo(day: day)
                }
                
                dayInfo.results.append(pair.result)
                
                monthInfo.dayInfoDict[day] = dayInfo
                monthInfos[yearMonth] = monthInfo
            }
            return Array(monthInfos.values)
        } catch {
            print(error)
            return []
        }
    }
}
