//
//  AppDelegate.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullPath = paths[0].appendingPathComponent("userPreferences")
        
        let appVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let existingVersion = UserDefaults.standard.object(forKey: "CurrentVersionNumber") as? String ?? appVersionNumber
        
        if let nsData = NSData(contentsOf: fullPath) {
            do {

                let data = Data(referencing:nsData)

                if let loadedPreferences = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserPreferences{
                    //Make sure Hexadecimal tab is not disabled by default (new user preference added in version 1.2.0)
                    let updatePreferencesVersions = ["1.0.0", "1.0.1", "1.0.2", "1.1.0", "1.1.1"]
                    if (updatePreferencesVersions.firstIndex(of: existingVersion) != nil) {
                        let userPreferences = UserPreferences(colour: loadedPreferences.colour, colourNum: loadedPreferences.colourNum,
                                                              hexTabState: true, binTabState: loadedPreferences.binTabState, decTabState: loadedPreferences.decTabState,
                                                              setCalculatorTextColour: loadedPreferences.setCalculatorTextColour,
                                                              copyActionIndex: 0, pasteActionIndex: 1)
                        DataPersistence.savePreferences(userPreferences: userPreferences)
                        UserDefaults.standard.set(appVersionNumber, forKey: "CurrentVersionNumber")
                    }
                    UITabBar.appearance().tintColor = loadedPreferences.colour
                }
            } catch {
                print("Couldn't read file.")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HexaCalc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

