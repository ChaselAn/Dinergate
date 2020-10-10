import Foundation
import SQLite

struct LogDBInfo {
    let id: Int
    let title: String
    let callStack: String
    let date: Date
}
final class DBManager {
    
    static let shared = DBManager()
    
    var db: Connection?
    
    private let stuckTable = Table("stuckLogList")
    private let crashTable = Table("crashLogList")
    
    let id = Expression<Int>("id")
    let title = Expression<String>("title")
    let date = Expression<Date>("date")
    let callStack = Expression<String>("callStack")
    
    func config() {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true ).first else { return }
        guard let db = try? Connection("\(path)/Dinergate/db.splite3") else { return }
        db.busyTimeout = 3
        
        _ = try? db.run(stuckTable.create(temporary: false, ifNotExists: true, block: { (builder) in
            builder.column(id, primaryKey: .autoincrement)
            builder.column(title)
            builder.column(date)
            builder.column(callStack)
        }))
        
        _ = try? db.run(crashTable.create(temporary: false, ifNotExists: true, block: { (builder) in
            builder.column(id, primaryKey: .autoincrement)
            builder.column(title)
            builder.column(date)
            builder.column(callStack)
        }))

        self.db = db
    }
    
    func stuckInfos() -> [LogDBInfo] {
        guard let array = try? db?.prepare(stuckTable) else { return [] }
        return array.map({
            LogDBInfo(id: $0[id], title: $0[title], callStack: $0[callStack], date: $0[date])
        })
    }
    
    func crashInfos() -> [LogDBInfo] {
        guard let array = try? db?.prepare(crashTable) else { return [] }
        return array.map({
            LogDBInfo(id: $0[id], title: $0[title], callStack: $0[callStack], date: $0[date])
        })
    }
    
    func stuckCallStack(id: Int) -> String? {
        let query = stuckTable.filter(self.id == id).select(callStack).limit(1)
        return try? db?.prepare(query).map({ $0[callStack] }).first
    }
    
    func crashCallStack(id: Int) -> String? {
        let query = crashTable.filter(self.id == id).select(callStack).limit(1)
        return try? db?.prepare(query).map({ $0[callStack] }).first
    }
    
    func insertStuck(info: LogDBInfo) {
        let insert = stuckTable.insert(title <- info.title, callStack <- info.callStack, date <- info.date)
        _ = try? db?.run(insert)
    }
    
    func insertCrash(info: LogDBInfo) {
        let insert = crashTable.insert(title <- info.title, callStack <- info.callStack, date <- info.date)
        _ = try? db?.run(insert)
    }
    
    func deleteAllStuck() {
        _ = try? db?.run(stuckTable.delete())
    }
    
    func deleteAllCrash() {
        _ = try? db?.run(crashTable.delete())
    }
}
