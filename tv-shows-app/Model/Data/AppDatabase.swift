//
//  AppDatabase.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 23/11/2020.
//

import Foundation
import GRDB

class AppDatabase {
    static var shared: AppDatabase!
    
    private let dbQueue: DatabaseQueue
    
    init(_ dbQueue: DatabaseQueue) throws {
        self.dbQueue = dbQueue
        try migrator.migrate(dbQueue)
    }
    
    /// The DatabaseMigrator that defines the database schema.
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("createTvShow") { db in
            // Create a table
            try db.create(table: "tvShow") { t in
                t.primaryKey(["id"])
                t.column("originalName", .text).notNull()
                t.column("genreIds", .text)
                t.column("genres", .text)
                t.column("name", .text).notNull()
                t.column("popularity", .text).notNull()
                t.column("originCountry", .text).notNull()
                t.column("voteCount", .integer).notNull()
                t.column("firstAirDate", .date)
                t.column("backdropPath", .text)
                t.column("originalLanguage", .text).notNull()
                t.column("id", .integer).notNull()
                t.column("voteAverage", .double).notNull()
                t.column("overview", .text).notNull()
                t.column("posterPath", .text)
                t.column("subscribed", .boolean)
            }
        }

        return migrator
    }
}

extension AppDatabase {
    /// Save (insert or update) a tvShow.
    func saveTvShow(_ tvShow: inout TvShow) throws {
        try dbQueue.write { db in
            try tvShow.save(db)
        }
    }
    
    /// Delete the specified tvShow
    func deleteTvShow(ids: [Int64]) throws {
        try dbQueue.write { db in
            _ = try TvShow.deleteAll(db, keys: ids)
        }
    }
    
    /// Delete all tvShows
    func deleteAllTvShows() throws {
        try dbQueue.write { db in
            _ = try TvShow.deleteAll(db)
        }
    }
    
    /// get all tvShows
    func getAllTvShows() throws -> [TvShow] {
        do {
            return try dbQueue.read { db in
                try TvShow.fetchAll(db)
            }
        } catch {
            return []
        }
    }
    
    func getTvShow(by id: Int64) throws -> TvShow? {
        try dbQueue.read { db in
            if let tvShow = try TvShow.fetchOne(db, sql: "SELECT * FROM tvShow WHERE id = \(id)") {
                return tvShow
            }
            return nil
        }
    }
}
