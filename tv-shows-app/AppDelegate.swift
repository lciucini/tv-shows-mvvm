//
//  AppDelegate.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import UIKit
import GRDB

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = .black
        
        try! setupDatabase()
        return true
    }
    
    // MARK: - Database Setup
    private func setupDatabase() throws {
        // AppDelegate chooses the location of the database file.
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        let dbQueue = try DatabaseQueue(path: databaseURL.path)
        
        // Create the shared application database
        let database = try AppDatabase(dbQueue)
        
        // Expose it to the rest of the application
        AppDatabase.shared = database
    }
}

