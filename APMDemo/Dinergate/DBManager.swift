import Foundation
import SQLite

protocol LogInfo {
    var id: Int { get }
    var date: Date { get }
}
struct CallStackLogInfo: LogInfo {
    let id: Int
    let title: String
    let desc: String?
    let callStack: String
    let date: Date
    let appInfo: String?
}

struct TickLogInfo: LogInfo {
    let id: Int
    let title: String
    let desc: String?
    let date: Date
    let type: String?
}

final class DBManager {
    
    static let shared = DBManager()
    
    private var diskDb: Connection?
    private var cacheDb: Connection?

    private let stuckTable = Table("stuckLogList")
    private let crashTable = Table("crashLogList")
    private let logTable = Table("LogTable")
    
    let id = Expression<Int>("id")
    let title = Expression<String>("title")
    let desc = Expression<String?>("desc")
    let date = Expression<Date>("date")
    let callStack = Expression<String>("callStack")
    let appInfo = Expression<String?>("appInfo")
    let type = Expression<String?>("type")
    
    func config() {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        
        guard let diskDb = try? Connection("\(path)/Dinergate_logDB.sqlite3") else { return }
        guard let cacheDb = try? Connection() else { return }
        diskDb.busyTimeout = 3
        cacheDb.busyTimeout = 3
        
        _ = try? cacheDb.run(stuckTable.create(temporary: false, ifNotExists: true, block: { (builder) in
            builder.column(id, primaryKey: .autoincrement)
            builder.column(title)
            builder.column(desc)
            builder.column(date)
            builder.column(callStack)
            builder.column(appInfo)
        }))
        
        _ = try? diskDb.run(crashTable.create(temporary: false, ifNotExists: true, block: { (builder) in
            builder.column(id, primaryKey: .autoincrement)
            builder.column(title)
            builder.column(desc)
            builder.column(date)
            builder.column(callStack)
            builder.column(appInfo)
        }))
        
        _ = try? cacheDb.run(logTable.create(temporary: false, ifNotExists: true, block: { (builder) in
            builder.column(id, primaryKey: .autoincrement)
            builder.column(title)
            builder.column(desc)
            builder.column(date)
            builder.column(type)
        }))
        
        self.diskDb = diskDb
        self.cacheDb = cacheDb
    }
    
    func stuckInfos() -> [CallStackLogInfo] {
        guard let array = try? cacheDb?.prepare(stuckTable) else { return [] }
        return array.map({
            CallStackLogInfo(id: $0[id], title: $0[title], desc: $0[desc], callStack: $0[callStack], date: $0[date], appInfo: $0[appInfo])
        })
    }
    
    func crashInfos() -> [CallStackLogInfo] {
        guard let array = try? diskDb?.prepare(crashTable) else { return [] }
        return array.map({
            CallStackLogInfo(id: $0[id], title: $0[title], desc: $0[desc], callStack: $0[callStack], date: $0[date], appInfo: $0[appInfo])
        })
    }
    
    func tickLogTypes() -> [String?] {
        guard let array = try? cacheDb?.prepare(logTable) else { return [] }
        var set = Set<String?>()
        var types: [String?] = []
        array.forEach({
            let temp = $0[type]
            if !set.contains(temp) {
                set.insert(temp)
                types.append(temp)
            }
        })
        return types
    }
    
    func tickLogs(for type: String?) -> [TickLogInfo] {
        guard let array = try? cacheDb?.prepare(logTable) else { return [] }
        return array.filter({
            $0[self.type] == type
        }).map({
            TickLogInfo(id: $0[id], title: $0[title], desc: $0[desc], date: $0[date], type: $0[self.type])
        })
    }
    
    func tickLogs() -> [TickLogInfo] {
        guard let array = try? cacheDb?.prepare(logTable) else { return [] }
        return array.map({
            TickLogInfo(id: $0[id], title: $0[title], desc: $0[desc], date: $0[date], type: $0[type])
        })
    }
    
    func stuckCallStack(id: Int) -> String? {
        let query = stuckTable.filter(self.id == id).select(callStack).limit(1)
        return try? cacheDb?.prepare(query).map({ $0[callStack] }).first
    }
    
    func crashCallStack(id: Int) -> String? {
        let query = crashTable.filter(self.id == id).select(callStack).limit(1)
        return try? diskDb?.prepare(query).map({ $0[callStack] }).first
    }
    
    func insertStuck(title: String, desc: String?, callStack: String, date: Date, appInfo: String?) {
        let insert = stuckTable.insert(self.title <- title, self.desc <- desc, self.callStack <- callStack, self.date <- date, self.appInfo <- appInfo)
        _ = try? cacheDb?.run(insert)
    }
    
    func insertCrash(title: String, desc: String?, callStack: String, date: Date, appInfo: String?) {
        let insert = crashTable.insert(self.title <- title, self.desc <- desc, self.callStack <- callStack, self.date <- date, self.appInfo <- appInfo)
        _ = try? diskDb?.run(insert)
    }
    
    func insertTickLog(log: String, date: Date, desc: String?, type: String?) {
        let insert = logTable.insert(self.title <- log, self.desc <- desc, self.date <- date, self.type <- type)
        _ = try? cacheDb?.run(insert)
    }
    
    func deleteAllStuck() {
        _ = try? cacheDb?.run(stuckTable.delete())
    }
    
    func deleteAllCrash() {
        _ = try? diskDb?.run(crashTable.delete())
    }
}
