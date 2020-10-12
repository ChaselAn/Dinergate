import Foundation
import SQLite

struct LogDBInfo {
    let id: Int
    let title: String
    let desc: String?
    let callStack: String
    let date: Date
    let appInfo: String?
}
final class DBManager {
    
    static let shared = DBManager()
    
    var db: Connection?
    
    private let stuckTable = Table("stuckLogList")
    private let crashTable = Table("crashLogList")
    
    let id = Expression<Int>("id")
    let title = Expression<String>("title")
    let desc = Expression<String?>("desc")
    let date = Expression<Date>("date")
    let callStack = Expression<String>("callStack")
    let appInfo = Expression<String?>("appInfo")
    
    func config() {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        do {
            let db = try Connection("\(path)/Dinergate_logDB.sqlite3")
            db.busyTimeout = 3
            
            _ = try db.run(stuckTable.create(temporary: false, ifNotExists: true, block: { (builder) in
                builder.column(id, primaryKey: .autoincrement)
                builder.column(title)
                builder.column(desc)
                builder.column(date)
                builder.column(callStack)
                builder.column(appInfo)
            }))
            
            _ = try db.run(crashTable.create(temporary: false, ifNotExists: true, block: { (builder) in
                builder.column(id, primaryKey: .autoincrement)
                builder.column(title)
                builder.column(desc)
                builder.column(date)
                builder.column(callStack)
                builder.column(appInfo)
            }))

            self.db = db
        } catch {
            print("------------Connection: ", error)
        }
    }
    
    func stuckInfos() -> [LogDBInfo] {
        guard let array = try? db?.prepare(stuckTable) else { return [] }
        return array.map({
            LogDBInfo(id: $0[id], title: $0[title], desc: $0[desc], callStack: $0[callStack], date: $0[date], appInfo: $0[appInfo])
        })
    }
    
    func crashInfos() -> [LogDBInfo] {
        do {
            guard let array = try db?.prepare(crashTable) else { return [] }
            return array.map({
                LogDBInfo(id: $0[id], title: $0[title], desc: $0[desc], callStack: $0[callStack], date: $0[date], appInfo: $0[appInfo])
            })
        } catch {
            print("------------ ", error)
            return []
        }
    }
    
    func stuckCallStack(id: Int) -> String? {
        let query = stuckTable.filter(self.id == id).select(callStack).limit(1)
        return try? db?.prepare(query).map({ $0[callStack] }).first
    }
    
    func crashCallStack(id: Int) -> String? {
        let query = crashTable.filter(self.id == id).select(callStack).limit(1)
        return try? db?.prepare(query).map({ $0[callStack] }).first
    }
    
    func insertStuck(title: String, desc: String?, callStack: String, date: Date, appInfo: String?) {
        let insert = stuckTable.insert(self.title <- title, self.desc <- desc, self.callStack <- callStack, self.date <- date, self.appInfo <- appInfo)
        _ = try? db?.run(insert)
    }
    
    func insertCrash(title: String, desc: String?, callStack: String, date: Date, appInfo: String?) {
        let insert = crashTable.insert(self.title <- title, self.desc <- desc, self.callStack <- callStack, self.date <- date, self.appInfo <- appInfo)
        _ = try? db?.run(insert)
    }
    
    func deleteAllStuck() {
        _ = try? db?.run(stuckTable.delete())
    }
    
    func deleteAllCrash() {
        _ = try? db?.run(crashTable.delete())
    }
}
