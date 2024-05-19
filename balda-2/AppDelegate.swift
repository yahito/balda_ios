//
//  AppDelegate.swift
//  balda-2
//
//  Created by Andrey on 22/09/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainVC: GameViewController
    var state: GameGridState?
    
    override init() {
        mainVC = GameViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        restoreData()
        
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if state == nil {
            mainVC.gridState = GameGridState(Words.getRandomWord(Size.FIVE.getGridSize(), Level.MEDIUM, Lang.RUS)!,
                                             Size.FIVE, 0, Level.MEDIUM, Lang.RUS, "Игрок");
        } else {
            mainVC.gridState = state
        }
        self.window?.rootViewController = mainVC
        self.window?.backgroundColor = .lightGray
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        saveData()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func saveData() {
        let encoder = JSONEncoder()
        let data = mainVC.gridView?.game?.save(encoder)
        UserDefaults.standard.set(data, forKey: "personData3")
    }

    func restoreData() {
        if let savedData = UserDefaults.standard.data(forKey: "personData3") {
            let decoder = JSONDecoder()
            do {
                state = try decoder.decode(GameGridState.self, from: savedData)
            } catch {
                state = nil
            }
        }
    }

}

