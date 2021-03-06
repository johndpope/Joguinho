//
//  AppDelegate.swift
//  Joguinho
//
//  Created by Andre Machado Parente on 10/21/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if userDefaults.value(forKey: "lastLevel") == nil {
            userDefaults.set(1, forKey: "lastLevel")
            userDefaults.set(0, forKey: "coinsBalance")
            
            planetsGlobal = getArrayPlanets()
            DAO().savePlanets(planets: planetsGlobal)
            userDefaults.set(true, forKey: "soundOn")
        } else {
            planetsGlobal = DAO().getPlanets()
        }
        
        if userDefaults.value(forKey: "levels") == nil {
        levels.removeAll()
           levelsStars.removeAll()
           for _ in 0...7 {
        levels.append(["lockLayer","lockLayer","lockLayer","lockLayer","lockLayer","lockLayer","lockLayer","lockLayer","lockLayer"])
            levelsStars.append([0,0,0,0,0,0,0,0])
         }
            
            levels[0][0] = "1"
            levelsStars[0][0] = 0
            
            
            userDefaults.set(levels, forKey: "levels")
            userDefaults.set(levelsStars, forKey: "levelStars")
        }
        else {
            var m = 0
            var n = 0

            var levelsAntigos = userDefaults.value(forKey: "levels") as! [[String]]
            for level in levelsAntigos {
                for valor in level {
                    if valor == "lock" {
                        print(valor)
                        levelsAntigos[m][n] = "lockLayer"
                    }
                    n += 1
                }
                n = 0
                m+=1
            }
            userDefaults.set(levelsAntigos, forKey: "levels")
        }
        if userDefaults.value(forKey: "currentSpaceship")  == nil{
            userDefaults.set(userDefaults.value(forKey: "coinsBalance"),forKey:"NeptuneGems")
            userDefaults.set(0, forKey: "UranusGems")
            userDefaults.set(0, forKey: "coinsBalance")
            userDefaults.set(0, forKey: "currentSpaceship")
            spaceships = [true,false,false]
            userDefaults.set(spaceships, forKey: "spaceships")
        }
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if currentScene != nil && isPlaying {
            currentScene.isPaused = true
            let  scene1 = PauseScene()
            let skView = self.window?.rootViewController!.view as! SKView
            scene1.currentSceneState = currentScene
            scene1.size = skView.bounds.size
            scene1.scaleMode = .aspectFill
            skView.presentScene(scene1, transition: transition)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
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
